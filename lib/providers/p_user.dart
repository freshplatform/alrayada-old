// import 'dart:async';
// import 'dart:convert';

// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
// import 'package:shared_alrayada/data/user/auth/m_auth_request_response.dart';
// import 'package:shared_alrayada/data/user/m_user.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../data/social_authentication/social_authentication.dart';
// import '../utils/constants/routes.dart';
// import '/services/networking/http_clients/dio/s_dio.dart';

// class UserNotifier extends StateNotifier<UserAuthenticatedResponse?> {
//   UserNotifier() : super(null);

//   final _dio = DioService.getDio();
//   static const _userPrefKey = 'user';
//   static const _jwtTokenPrefKey = 'jwtToken';
//   Timer? _authTimer;
//   var _isLoadingUser = false;

//   final secureStorage = const FlutterSecureStorage(
//     aOptions: AndroidOptions(
//       encryptedSharedPreferences: true,
//     ),
//   );

//   Future<String?> forgotPassword(String email) async {
//     try {
//       final response = await _dio.post(
//         RoutesConstants.authRoutes.forgotPassword,
//         queryParameters: {
//           'email': email,
//         },
//       );
//       if (response.statusCode == 200) {
//         return null;
//       }
//       return 'Error!';
//     } on DioError catch (e) {
//       return e.response?.data ??
//           'Unknown error, please check your internet connection';
//     }
//   }

//   Future<String?> updateUserData(UserData userData) async {
//     try {
//       if (state == null) {
//         throw 'User are not authneticated';
//       }
//       await _dio.put(
//         RoutesConstants.authRoutes.userData,
//         data: userData.toJson(),
//       );
//       final user = state!.user;
//       final updatedUserContainer =
//           state!.copyWith(user: user.copyWith(data: userData));
//       await _saveUser(updatedUserContainer);
//       return null;
//     } on DioError catch (e) {
//       return e.response?.data;
//     }
//   }

//   Future<String?> updateUserPassword({
//     required String currentPassword,
//     required String newPassword,
//   }) async {
//     try {
//       await _dio.patch(
//         RoutesConstants.authRoutes.updatePassword,
//         queryParameters: {
//           'currentPassword': currentPassword,
//           'newPassword': newPassword,
//         },
//       );
//       return null;
//     } on DioError catch (e) {
//       return e.response?.data as String? ?? 'Unknown error';
//     }
//   }

//   /// userData is required
//   Future<String?> authenticateWithSocialLogin(
//       SocialAuthentication socialAuthData, String provider) async {
//     try {
//       var fcmToken = '';
//       var oneSignalPlayerId = '';
//       try {
//         // fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
//         oneSignalPlayerId =
//             (await OneSignal.shared.getDeviceState())?.userId ?? '';
//       } catch (e) {
//         if (kDebugMode) {
//           print('Error while get fcmToken in authenticateWithSocialLogin()');
//         }
//       }
//       socialAuthData.deviceToken = UserDeviceNotificationsToken(
//           fcm: fcmToken, oneSignalPlayerId: oneSignalPlayerId);
//       final response = await _dio.post(
//         RoutesConstants.authRoutes.socialLogin,
//         data: socialAuthData.toJson(),
//         queryParameters: {
//           'provider': provider,
//         },
//       );
//       if (response.data == null) {
//         throw 'Response data when authenticate the user is null';
//       }
//       final userContainer = _getUserContainerFromJson(response.data!);
//       await _saveUser(userContainer);
//       DioService.addAuthorizationHeader(
//         'Bearer ${state!.token}',
//         () {
//           logout();
//         },
//       );
//       autoLogout();
//       return null;
//     } on DioError catch (e) {
//       /// if server returns "There is no matching email account, so please provider sign up data to create the account"
//       return e.response?.data;
//     }
//   }

//   Future<void> authenticateWithEmailAndPassword(
//       bool isSignIn, AuthRequest authRequestWithoutDeviceToken) async {
//     try {
//       var authRequest = authRequestWithoutDeviceToken;
//       try {
//         // final fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
//         final oneSignalPlayerId =
//             (await OneSignal.shared.getDeviceState())?.userId ?? '';
//         authRequest = authRequest.copyWith(
//             deviceToken: UserDeviceNotificationsToken(
//           fcm: '',
//           oneSignalPlayerId: oneSignalPlayerId,
//         ));
//       } catch (e) {
//         if (kDebugMode) {
//           print('Error while get fcmToken in authenticate()');
//         }
//       }
//       if (isSignIn) {
//         final response = await _dio.post<String>(
//           RoutesConstants.authRoutes.signIn,
//           data: AuthRequest.customToJson(instance: authRequest, isSignIn: true),
//         );
//         if (response.data == null || response.statusCode != 200) {
//           if (kDebugMode) {
//             print(
//               'Unexpected error in authenticate() function: Status code != 200 or response.data is null',
//             );
//           }
//           return;
//         }
//         final user = _getUserContainerFromJson(response.data!);
//         await _saveUser(user);
//         DioService.addAuthorizationHeader(
//           'Bearer ${user.token}',
//           () {
//             logout();
//           },
//         );
//         autoLogout();
//         return;
//       }
//       await _dio.post<String>(
//         RoutesConstants.authRoutes.signUp,
//         data: AuthRequest.customToJson(instance: authRequest, isSignIn: false),
//       );
//     } on DioError {
//       rethrow;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<void> _saveUser(
//       UserAuthenticatedResponse userContainerWithToken) async {
//     if (userContainerWithToken.token.trim().isEmpty) {
//       throw 'Token should not be empty';
//     }
//     final prefs = await SharedPreferences.getInstance();
//     final token = userContainerWithToken.token;
//     await secureStorage.write(key: _jwtTokenPrefKey, value: token);
//     var userContainerWithoutToken = userContainerWithToken.copyWith(token: '');
//     await prefs.setString(
//         _userPrefKey, jsonEncode(userContainerWithoutToken.toJson()));
//     state = userContainerWithToken;
//   }

//   Future<void> loadSavedUser() async {
//     final prefs = await SharedPreferences.getInstance();
//     final loadedUser = prefs.getString(_userPrefKey);
//     if (loadedUser == null) return;
//     final userContainerWithoutToken = _getUserContainerFromJson(loadedUser);
//     final token = await secureStorage.read(key: _jwtTokenPrefKey);
//     if (token == null) {
//       throw 'The token from the saved user is null!';
//     }
//     final userContainer = userContainerWithoutToken.copyWith(token: token);
//     state = userContainer;
//     DioService.addAuthorizationHeader('Bearer ${state!.token}', () => logout());
//     autoLogout();
//   }

//   Future<String?> updateDeviceToken(
//       {String fcmToken = '', String oneSignalPlayerId = ''}) async {
//     await loadSavedUser();
//     if (state == null) {
//       return 'User is not authenticated';
//     }
//     var newOneSignalPlayerId = oneSignalPlayerId;
//     var newFcmToken = fcmToken;

//     if (newOneSignalPlayerId.trim().isEmpty) {
//       newOneSignalPlayerId =
//           (await OneSignal.shared.getDeviceState())?.userId ?? '';
//     }
//     if (newFcmToken.trim().isEmpty) {
//       // newFcmToken = await FirebaseMessaging.instance.getToken() ?? '';
//     }
//     try {
//       await _dio.patch(
//         RoutesConstants.authRoutes.updateDeviceToken,
//         data: UserDeviceNotificationsToken(
//           fcm: newFcmToken,
//           oneSignalPlayerId: newOneSignalPlayerId,
//         ).toJson(),
//       );
//       return null;
//     } on DioError catch (e) {
//       return 'Error: ${e.message}, ${e.response?.data}';
//     }
//   }

//   Future<void> loadUserFromServer() async {
//     if (state == null) return;
//     if (_isLoadingUser) return;
//     _isLoadingUser = true;
//     try {
//       final response = await _dio.get<String>(
//         RoutesConstants.authRoutes.user,
//       );
//       final responseData = response.data;
//       if (responseData == null) return;
//       final user = User.fromJson(jsonDecode(responseData));
//       final newUserContainer = state!.copyWith(user: user);
//       await _saveUser(newUserContainer);
//     } on DioError {
//       rethrow;
//     } finally {
//       _isLoadingUser = false;
//     }
//   }

//   UserAuthenticatedResponse _getUserContainerFromJson(String json) =>
//       UserAuthenticatedResponse.fromJson(jsonDecode(json));

//   Future<void> logout({bool byUser = false}) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_userPrefKey);
//     await secureStorage.delete(key: _jwtTokenPrefKey);
//     state = null;
//     cancelTimer();
//     DioService.removeAuthorizationHeader();
//   }

//   Future<bool> deleteAccount() async {
//     try {
//       final response = await _dio.delete(
//         RoutesConstants.authRoutes.deleteAccount,
//       );
//       if (response.statusCode != 200) {
//         return false;
//       }
//       await logout(byUser: true);
//       return true;
//     } on DioError {
//       return false;
//     }
//   }

//   void cancelTimer() {
//     if (_authTimer == null) {
//       return;
//     }
//     if (_authTimer!.isActive) {
//       _authTimer!.cancel();
//     }
//     _authTimer = null;
//   }

//   void autoLogout() {
//     cancelTimer();
//     if (state == null) {
//       return;
//     }
//     final expireInDate = DateTime.fromMillisecondsSinceEpoch(state!.expiresAt);
//     final durationToExpire = expireInDate.difference(DateTime.now());
//     final secondsToExpire = durationToExpire.inSeconds;
//     if (secondsToExpire <= 0) {
//       logout();
//       return;
//     }
//     _authTimer = Timer(Duration(seconds: secondsToExpire), logout);
//   }
// }

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/data/user/auth/m_auth_request_response.dart';
import 'package:shared_alrayada/providers/p_user.dart';

import '../data/social_authentication/social_authentication.dart';
import '../services/native/notifications/s_notifications.dart';
import '../services/networking/http_clients/dio/s_dio.dart';
import '../utils/constants/routes.dart';

class UserNotifier extends SharedUserNotifier {
  static final provider =
      StateNotifierProvider<UserNotifier, UserAuthenticatedResponse?>(
    (ref) => UserNotifier(),
  );

  static final _dio = DioService.getDio();

  Future<String?> updateDeviceToken() async {
    await loadSavedUser();
    if (state == null) {
      return 'User is not authenticated';
    }
    try {
      await _dio.patch(
        RoutesConstants.authRoutes.updateDeviceToken,
        data:
            (await NotificationsService.instanse.getUserDeviceToken()).toJson(),
      );
      return null;
    } on DioException catch (e) {
      return 'Error: ${e.message}, ${e.response?.data}';
    }
  }

  @override
  Future<void> authenticateWithEmailAndPassword(
      bool isSignIn, AuthRequest authRequestWithoutDeviceToken) async {
    var authRequest = authRequestWithoutDeviceToken;
    try {
      authRequest = authRequest.copyWith(
        deviceToken: await NotificationsService.instanse.getUserDeviceToken(),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error while get fcmToken in authenticate()');
      }
    }
    return super.authenticateWithEmailAndPassword(isSignIn, authRequest);
  }

  Future<String?> authenticateWithSocialLogin(
      SocialAuthentication socialAuthData, String provider) async {
    try {
      socialAuthData.deviceToken =
          await NotificationsService.instanse.getUserDeviceToken();
      final response = await _dio.post(
        RoutesConstants.authRoutes.socialLogin,
        data: socialAuthData.toJson(),
        queryParameters: {
          'provider': provider,
        },
      );
      if (response.data == null) {
        throw 'Response data when authenticate the user is null';
      }
      final userContainer = getUserContainerFromJson(response.data!);
      await saveUser(userContainer);
      DioService.addAuthorizationHeader(
        'Bearer ${state!.token}',
        logout,
      );
      autoLogout();
      return null;
    } on DioException catch (e) {
      /// if server returns "There is no matching email account, so please provider sign up data to create the account"
      return e.response?.data;
    }
  }
}
