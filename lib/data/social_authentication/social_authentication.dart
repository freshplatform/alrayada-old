import 'package:json_annotation/json_annotation.dart';
import 'package:shared_alrayada/data/user/m_user.dart';

part 'social_authentication.g.dart';

@JsonSerializable(explicitToJson: true, createToJson: false)
class SocialAuthentication {

  SocialAuthentication(
    this.signUpUserData,
    this.deviceToken,
  );

  factory SocialAuthentication.fromJson(Map<String, dynamic> json) =>
      _$SocialAuthenticationFromJson(json);
  UserData? signUpUserData;
  UserDeviceNotificationsToken deviceToken;

  Map<String, dynamic> toJson() {
    if (this is GoogleAuthentication) {
      return (this as GoogleAuthentication).toJson();
    } else if (this is AppleAuthentication) {
      return (this as AppleAuthentication).toJson();
    } else {
      throw Exception('Unsupported toJson()');
    }
  }
}

@JsonSerializable(explicitToJson: true)
class GoogleAuthentication extends SocialAuthentication {

  GoogleAuthentication(
    this.idToken,
    UserData? signUpUserData,
    UserDeviceNotificationsToken deviceToken,
  ) : super(signUpUserData, deviceToken);

  factory GoogleAuthentication.fromJson(Map<String, dynamic> json) =>
      _$GoogleAuthenticationFromJson(json);
  static const provider = 'Google';
  final String idToken;

  @override
  Map<String, dynamic> toJson() => _$GoogleAuthenticationToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AppleAuthentication extends SocialAuthentication {

  AppleAuthentication(
    this.identityToken,
    this.userId,
    UserData? signUpUserData,
    UserDeviceNotificationsToken deviceToken,
  ) : super(signUpUserData, deviceToken);

  factory AppleAuthentication.fromJson(Map<String, dynamic> json) =>
      _$AppleAuthenticationFromJson(json);
  static const provider = 'Apple';
  final String identityToken;
  final String userId;

  @override
  Map<String, dynamic> toJson() => _$AppleAuthenticationToJson(this);
}
