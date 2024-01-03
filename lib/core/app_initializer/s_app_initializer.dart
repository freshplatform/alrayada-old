import 'package:flutter/foundation.dart' show immutable;

import '/core/app_initializer/firebase.dart';
import 'onesignal.dart';

@immutable
abstract class AppInitializer {
  Future<void> initialize();
}

@immutable
class AppInitializerService implements AppInitializer {
  const AppInitializerService._();
  static const instance = AppInitializerService._();

  static final List<AppInitializer> _items = [
    FirebaseInitializer(),
    OneSignalInitializer()
  ];

  @override
  Future<void> initialize() async {
    // await SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    for (final item in _items) {
      await item.initialize();
    }
  }
}
