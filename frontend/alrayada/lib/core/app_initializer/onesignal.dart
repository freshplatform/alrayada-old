import 'package:alrayada/core/app_initializer/s_app_initializer.dart';
import 'package:alrayada/utils/platform_checker.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_alrayada/server/server.dart';

class OneSignalInitializer extends AppInitializer {
  @override
  Future<void> initialize() async {
    if (!PlatformChecker.isMobileDevice()) {
      return;
    }
    if (kDebugMode) {
      await OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    }
    OneSignal.initialize(ServerConfigurations.oneSignalAppId);
  }
}
