import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;

class PlatformChecker {
  const PlatformChecker._();

  static bool isAppleProduct() {
    if (kIsWeb) {
      return false;
    }
    if (Platform.isIOS || Platform.isMacOS) {
      return true;
    }
    return false;
  }

  static bool isAndroidProduct() {
    if (kIsWeb) {
      return false;
    }
    if (Platform.isAndroid) {
      return true;
    }
    return false;
  }

  static bool isMobileDevice() {
    if (kIsWeb) {
      return false;
    }
    if (Platform.isAndroid || Platform.isIOS) {
      return true;
    }
    return false;
  }

  static bool isWeb() {
    return kIsWeb;
  }
}
