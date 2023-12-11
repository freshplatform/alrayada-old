import 'package:freezed_annotation/freezed_annotation.dart';

import '../m_user.dart';

part 'm_auth_request_response.g.dart';
part 'm_auth_request_response.freezed.dart';

@freezed
class AuthRequest with _$AuthRequest {
  const factory AuthRequest({
    required String email,
    required String password,
    required UserDeviceNotificationsToken deviceToken,
    UserData? userData,
  }) = _AuthRequest;

  factory AuthRequest.fromJson(Map<String, dynamic> json) =>
      _$AuthRequestFromJson(json);

  static Map<String, dynamic> customToJson(
      {required AuthRequest instance, required bool isSignIn}) {
    final Map<String, dynamic> data = {
      'email': instance.email,
      'password': instance.password,
      'deviceToken': instance.deviceToken.toJson(),
    };
    if (!isSignIn) {
      data['userData'] = instance.userData!.toJson();
    }
    return data;
  }
}

@freezed
class UserAuthenticatedResponse with _$UserAuthenticatedResponse {
  const factory UserAuthenticatedResponse({
    required String token,
    required int expiresIn,
    required int expiresAt,
    required User user,
  }) = _AuthSignInResponse;

  factory UserAuthenticatedResponse.fromJson(Map<String, dynamic> json) =>
      _$UserAuthenticatedResponseFromJson(json);
}
