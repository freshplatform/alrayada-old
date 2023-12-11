import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/widgets.dart' show FlutterError, immutable;

import '../../firebase_options.dart';
import 's_app_initializer.dart';

@immutable
class FirebaseInitializer extends AppInitializer {
  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FlutterError.onError = FirebaseCrashlytics.instance
        .recordFlutterFatalError; // TODO("Consider change this in production")
  }
}
