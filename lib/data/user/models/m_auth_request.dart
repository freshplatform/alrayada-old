import 'package:freezed_annotation/freezed_annotation.dart';

import 'm_user.dart';

part 'm_auth_request.freezed.dart';
part 'm_auth_request.g.dart';

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
}
