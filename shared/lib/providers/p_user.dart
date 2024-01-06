// import 'dart:async';
// import 'dart:convert';

// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../services/networking/dio/dio.dart';
// import '../utils/constants/routes.dart';

// class SharedUserNotifier extends StateNotifier<UserAuthenticatedResponse?> {
//   SharedUserNotifier() : super(null);

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
//     } on DioException catch (e) {
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
//       await saveUser(updatedUserContainer);
//       return null;
//     } on DioException catch (e) {
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
//     } on DioException catch (e) {
//       return e.response?.data as String? ?? 'Unknown error';
//     }
//   }

//   Future<void> authenticateWithEmailAndPassword(
//       bool isSignIn, AuthRequest authRequestWithoutDeviceToken) async {
//     try {
//       final authRequest = authRequestWithoutDeviceToken;
//       // try {
//       //   // final fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
//       //   final oneSignalPlayerId =
//       //       (await OneSignal.shared.getDeviceState())?.userId ?? '';
//       //   authRequest = authRequest.copyWith(
//       //       deviceToken: UserDeviceNotificationsToken(
//       //     fcm: '',
//       //     oneSignalPlayerId: oneSignalPlayerId,
//       //   ));
//       // } catch (e) {
//       //   if (kDebugMode) {
//       //     print('Error while get fcmToken in authenticate()');
//       //   }
//       // }
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
//         final user = getUserContainerFromJson(response.data!);
//         await saveUser(user);
//         DioService.addAuthorizationHeader(
//           'Bearer ${user.token}',
//           logout,
//         );
//         autoLogout();
//         return;
//       }
//       await _dio.post<String>(
//         RoutesConstants.authRoutes.signUp,
//         data: AuthRequest.customToJson(instance: authRequest, isSignIn: false),
//       );
//     } on DioException {
//       rethrow;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<void> saveUser(
//       UserAuthenticatedResponse userContainerWithToken) async {
//     if (userContainerWithToken.token.trim().isEmpty) {
//       throw 'Token should not be empty';
//     }
//     final prefs = await SharedPreferences.getInstance();
//     final token = userContainerWithToken.token;
//     await secureStorage.write(key: _jwtTokenPrefKey, value: token);
//     final userContainerWithoutToken =
//         userContainerWithToken.copyWith(token: '');
//     await prefs.setString(
//         _userPrefKey, jsonEncode(userContainerWithoutToken.toJson()));
//     state = userContainerWithToken;
//   }

//   Future<void> loadSavedUser() async {
//     final prefs = await SharedPreferences.getInstance();
//     final loadedUser = prefs.getString(_userPrefKey);
//     if (loadedUser == null) return;
//     final userContainerWithoutToken = getUserContainerFromJson(loadedUser);
//     final token = await secureStorage.read(key: _jwtTokenPrefKey);
//     if (token == null) {
//       await logout(byUser: false);
//       throw 'The token from the saved user is null!';
//     }
//     final userContainer = userContainerWithoutToken.copyWith(token: token);
//     state = userContainer;
//     DioService.addAuthorizationHeader('Bearer ${state!.token}', logout);
//     autoLogout();
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
//       await saveUser(newUserContainer);
//     } on DioException {
//       rethrow;
//     } finally {
//       _isLoadingUser = false;
//     }
//   }

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
//     } on DioException {
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
