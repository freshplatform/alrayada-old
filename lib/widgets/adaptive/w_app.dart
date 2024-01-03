import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/platform_checker.dart';

class AppAndroidOptions {

  AppAndroidOptions({
    required this.materialLightThemeData,
    required this.materialDarkThemeData,
    required this.themeMode,
  });
  final ThemeData materialLightThemeData;
  final ThemeData materialDarkThemeData;
  final ThemeMode themeMode;
}

class AppIosOptions {

  AppIosOptions({
    required this.cupertinoThemeData,
  });
  final CupertinoThemeData cupertinoThemeData;
}

class AdaptiveApp extends StatelessWidget {
  const AdaptiveApp({
    required this.title, required this.routes, required this.androidOptions, required this.iosOptions, super.key,
    this.debugShowCheckedModeBanner = false,
    this.home,
  });
  final bool debugShowCheckedModeBanner;
  final String title;
  final Widget? home;
  final Map<String, Widget Function(BuildContext)> routes;
  final AppAndroidOptions androidOptions;
  final AppIosOptions iosOptions;

  @override
  Widget build(BuildContext context) {
    return PlatformChecker.isAppleProduct()
        ? CupertinoApp(
            debugShowCheckedModeBanner: debugShowCheckedModeBanner,
            title: title,
            home: home,
            routes: routes,
            theme: iosOptions.cupertinoThemeData,
          )
        : MaterialApp(
            debugShowCheckedModeBanner: debugShowCheckedModeBanner,
            title: title,
            home: home,
            routes: routes,
            theme: androidOptions.materialLightThemeData,
            darkTheme: androidOptions.materialDarkThemeData,
            themeMode: androidOptions.themeMode,
          );
  }
}
