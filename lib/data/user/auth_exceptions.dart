import 'package:meta/meta.dart';

@immutable
sealed class AuthException implements Exception {
  const AuthException({
    required this.message,
  });
  final String? message;
}

class UserNotFoundAuthException extends AuthException {
  const UserNotFoundAuthException({required super.message});
}

class InvalidCredentialsAuthException extends AuthException {
  const InvalidCredentialsAuthException({required super.message});
}

class VerificationLinkAlreadySentException extends AuthException {
  const VerificationLinkAlreadySentException({
    required super.message,
    required this.minutesToExpire,
  });

  final bool minutesToExpire;
}
