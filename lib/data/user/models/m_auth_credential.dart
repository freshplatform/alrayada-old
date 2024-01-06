import 'package:freezed_annotation/freezed_annotation.dart';

import 'm_user.dart';

part 'm_auth_credential.freezed.dart';
part 'm_auth_credential.g.dart';

@freezed
class UserCredential with _$UserCredential {
  const factory UserCredential({
    required String token,
    required int expiresIn,
    required int expiresAt,
    required User user,
  }) = _UserCredential;

  factory UserCredential.fromJson(Map<String, dynamic> json) =>
      _$UserCredentialFromJson(json);
}
