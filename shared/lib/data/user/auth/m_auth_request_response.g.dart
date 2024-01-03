// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'm_auth_request_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_AuthRequest _$$_AuthRequestFromJson(Map<String, dynamic> json) =>
    _$_AuthRequest(
      email: json['email'] as String,
      password: json['password'] as String,
      deviceToken: UserDeviceNotificationsToken.fromJson(
          json['deviceToken'] as Map<String, dynamic>),
      userData: json['userData'] == null
          ? null
          : UserData.fromJson(json['userData'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_AuthRequestToJson(_$_AuthRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'deviceToken': instance.deviceToken,
      'userData': instance.userData,
    };

_$_AuthSignInResponse _$$_AuthSignInResponseFromJson(
        Map<String, dynamic> json) =>
    _$_AuthSignInResponse(
      token: json['token'] as String,
      expiresIn: json['expiresIn'] as int,
      expiresAt: json['expiresAt'] as int,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_AuthSignInResponseToJson(
        _$_AuthSignInResponse instance) =>
    <String, dynamic>{
      'token': instance.token,
      'expiresIn': instance.expiresIn,
      'expiresAt': instance.expiresAt,
      'user': instance.user,
    };
