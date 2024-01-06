import 'dart:async' show Timer;
import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    show FlutterSecureStorage, AndroidOptions;
import 'package:shared_alrayada/services/networking/dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/native/notifications/s_notifications.dart';
import '../../utils/constants/routes.dart';
import '../social_authentication/social_authentication.dart';
import 'auth_exceptions.dart';
import 'auth_repository.dart';
import 'models/m_auth_credential.dart';
import 'models/m_auth_request.dart';
import 'models/m_user.dart';

class AuthRepositoryImpl extends AuthRepository {
  final _dio = DioService.getDio();
  Timer? _authTimer;
  final _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  @override
  Future<UserCredential> signInWithEmailAndPassword(
      AuthRequest authRequest) async {
    try {
      authRequest = authRequest.copyWith(
        deviceToken: await NotificationsService.instanse.getUserDeviceToken(),
      );
      final response = await _dio.post(
        RoutesConstants.authRoutes.signIn,
        data: authRequest.toJson(),
      );
      final userResponse = UserCredential.fromJson(jsonDecode(
        response.data.toString(),
      ));
      saveUser(userResponse);
      DioService.addAuthorizationHeader(
        'Bearer ${userResponse.token}',
        logout,
      );
      autoLogout(userResponse);
      return userResponse;
    } on DioException catch (e) {
      final code = e.response?.data['code'].toString() ?? '';
      final errorType = switch (code) {
        'USER_NOT_FOUND' => AuthenticateAuthErrorType.userNotFound,
        'INVALID_CREDENTIALS' => AuthenticateAuthErrorType.invalidCredentials,
        'VERIFICATION_LINK_ALREADY_SENT' =>
          AuthenticateAuthErrorType.sendEmailVerificationError,
        String() => AuthenticateAuthErrorType.unknownAuthError,
      };
      throw AuthenticateAuthException(message: code, type: errorType);
    } catch (e) {
      throw AuthenticateAuthException(
        message: e.toString(),
        type: AuthenticateAuthErrorType.genericAuthError,
      );
    }
  }

  @override
  Future<void> signUpWithEmailAndPassword(AuthRequest authRequest) async {
    authRequest = authRequest.copyWith(
      deviceToken: await NotificationsService.instanse.getUserDeviceToken(),
    );
    await _dio.post(
      RoutesConstants.authRoutes.signUp,
      data: authRequest.toJson(),
    );
  }

  void autoLogout(UserCredential userAuthenticatedResponse) {
    cancelTimer();
    final expiresAt = DateTime.fromMillisecondsSinceEpoch(
      userAuthenticatedResponse.expiresAt,
    );
    final secondsToExpire = expiresAt.difference(DateTime.now()).inSeconds;
    if (secondsToExpire <= 0) {
      logout();
      return;
    }
    _authTimer = Timer(Duration(seconds: secondsToExpire), logout);
  }

  void cancelTimer() {
    final authTimer = _authTimer;
    if (authTimer == null) {
      return;
    }
    if (authTimer.isActive) {
      authTimer.cancel();
    }
    _authTimer = null;
  }

  static const userPrefKey = 'user';
  static const jwtTokenPrefKey = 'jwtToken';

  Future<void> saveUser(
    UserCredential userCredential,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    // Don't save the token in shared prefs
    await prefs.setString(
      userPrefKey,
      jsonEncode(userCredential.copyWith(token: '')),
    );
    await _secureStorage.write(
      key: jwtTokenPrefKey,
      value: userCredential.token,
    );
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userPrefKey);
    await _secureStorage.delete(key: jwtTokenPrefKey);
    cancelTimer();
    DioService.removeAuthorizationHeader();
  }

  @override
  Future<UserCredential?> fetchSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUserJson = prefs.getString('user');
    if (savedUserJson == null) return null;
    final jwt = await _secureStorage.read(key: jwtTokenPrefKey);
    if (jwt == null) return null;
    // Without Jwt
    final userCredential =
        UserCredential.fromJson(jsonDecode(savedUserJson)).copyWith(
      token: jwt,
    );
    autoLogout(userCredential);
    DioService.addAuthorizationHeader('Bearer $jwt', logout);
    return userCredential;
  }

  @override
  Future<User?> fetchUser() async {
    final response = await _dio.get(RoutesConstants.authRoutes.user);
    final responseData = response.data;
    if (responseData == null) return null;
    final user = User.fromJson(jsonDecode(responseData));
    return user;
  }

  @override
  Future<UserCredential> authenticateWithSocialLogin(
      SocialAuthentication socialAuthentication) async {
    try {
      socialAuthentication = socialAuthentication.copyWith(
        deviceToken: await NotificationsService.instanse.getUserDeviceToken(),
      );
      final response = await _dio.post(
        RoutesConstants.authRoutes.socialLogin,
        data: socialAuthentication.toJson(),
        queryParameters: {
          'provider': socialAuthentication.provider,
        },
      );
      if (response.data == null) {
        throw 'Response data when authenticate the user is null';
      }
      final userCredential = UserCredential.fromJson(jsonDecode(response.data));
      await saveUser(userCredential);
      DioService.addAuthorizationHeader(
        'Bearer ${userCredential.token}',
        logout,
      );
      autoLogout(userCredential);
      return userCredential;
    } on DioException catch (e) {
      /// if server returns "There is no matching email account, so please provider sign up data to create the account"
      return e.response?.data;
    }
  }

  @override
  Future<void> deleteAccount() async {
    final response = await _dio.delete(
      RoutesConstants.authRoutes.deleteAccount,
    );
    if (response.statusCode != 200) {
      return;
    }
    await logout();
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await _dio.post(
      RoutesConstants.authRoutes.forgotPassword,
      queryParameters: {
        'email': email,
      },
    );
  }

  @override
  Future<void> updateDeviceToken() async {
    await _dio.patch(
      RoutesConstants.authRoutes.updateDeviceToken,
      data: (await NotificationsService.instanse.getUserDeviceToken()).toJson(),
    );
  }

  @override
  Future<void> updateUserData(
    UserData userData,
  ) async {
    await _dio.put(
      RoutesConstants.authRoutes.userData,
      data: userData.toJson(),
    );
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(userPrefKey);
    if (json == null) return;
    final userAuthenticatedResponse = UserCredential.fromJson(jsonDecode(json));

    await saveUser(userAuthenticatedResponse.copyWith(
      user: userAuthenticatedResponse.user.copyWith(
        data: userData,
      ),
    ));
  }

  @override
  Future<void> updateUserPassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _dio.patch(
      RoutesConstants.authRoutes.updatePassword,
      queryParameters: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
    );
  }
}
