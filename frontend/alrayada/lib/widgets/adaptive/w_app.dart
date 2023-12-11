import 'package:alrayada/utils/platform_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppAndroidOptions {
  final ThemeData materialLightThemeData;
  final ThemeData materialDarkThemeData;
  final ThemeMode themeMode;

  AppAndroidOptions({
    required this.materialLightThemeData,
    required this.materialDarkThemeData,
    required this.themeMode,
  });
}

class AppIosOptions {
  final CupertinoThemeData cupertinoThemeData;

  AppIosOptions({
    required this.cupertinoThemeData,
  });
}

class AdaptiveApp extends StatelessWidget {
  const AdaptiveApp({
    Key? key,
    this.debugShowCheckedModeBanner = false,
    required this.title,
    this.home,
    required this.routes,
    required this.androidOptions,
    required this.iosOptions,
  }) : super(key: key);
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
