import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_fonts/google_fonts.dart';

/// I could make base theme which have all the shared things
/// Between light and dark theme, but I will make it simple for now
class MyAppTheme {
  MyAppTheme._();
  static ThemeData materialLightTheme() {
    final themeData = ThemeData(
      cupertinoOverrideTheme: cupertinoThemeData(),
      primarySwatch: Colors.green,
      useMaterial3: true,
      // scaffoldBackgroundColor: const Color(0XFFFCFEFD),
    );
    return themeData.copyWith(
      colorScheme: themeData.colorScheme.copyWith(secondary: Colors.green),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        // backgroundColor: const Color(0XFF3D425F),
        // backgroundColor: Colors.white,
        selectedItemColor: themeData.colorScheme.primary,
        unselectedItemColor: Colors.grey,
      ),
      textTheme: GoogleFonts.cairoTextTheme(themeData.textTheme),
    );
  }

  static ThemeData materialDarkTheme() {
    final themeData = ThemeData(
      cupertinoOverrideTheme: cupertinoThemeData(),
      primarySwatch: Colors.green,
      brightness: Brightness.dark,
      useMaterial3: true,
    );
    return themeData.copyWith(
      colorScheme: themeData.colorScheme.copyWith(secondary: Colors.green),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        // backgroundColor: const Color(0XFF3D425F),
        type: BottomNavigationBarType.shifting,
        selectedItemColor: themeData.colorScheme.primary,
        unselectedItemColor: Colors.grey,
      ),
      textTheme: GoogleFonts.cairoTextTheme(themeData.textTheme),
    );
  }

  static ThemeData getAppMaterialTheme(BuildContext context) {
    if (isDark(context)) {
      return materialDarkTheme();
    }
    return materialLightTheme();
  }

  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static CupertinoThemeData cupertinoThemeData(
      {ThemeMode themeMode = ThemeMode.system}) {
    const themeData = CupertinoThemeData();
    if (themeMode == ThemeMode.dark) {
      return themeData.copyWith(brightness: Brightness.dark);
    } else if (themeMode == ThemeMode.light) {
      return themeData.copyWith(brightness: Brightness.light);
    }
    return themeData;
  }

  static TextStyle getNormalTextStyle(BuildContext context) {
    if (isCupertino(context)) {
      return CupertinoTheme.of(context).textTheme.textStyle;
    }
    return Theme.of(context).textTheme.bodyMedium!;
  }
}
