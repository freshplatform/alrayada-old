import 'package:flutter/foundation.dart' show immutable;

@immutable
class PatternsConstants {
  const PatternsConstants._privateConstructor();
  static const passwordPattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$';
}
