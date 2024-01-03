import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system);

  static const themeModePrefKey = 'themeMode';

  static final themeModeProvider =
      StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
    (ref) => ThemeModeNotifier(),
  );

  Future<void> setThemeMode(ThemeMode newThemeMode) async {
    final prefs = await SharedPreferences.getInstance();
    state = newThemeMode;
    await prefs.setString(themeModePrefKey, state.name);
  }

  void setDefaultTheme() {
    state = ThemeMode.system;
  }

  void loadThemeMode(SharedPreferences prefs) {
    final loadedThemeMode = prefs.getString(themeModePrefKey);
    if (loadedThemeMode == null) return;
    for (final element in ThemeMode.values) {
      if (element.name == loadedThemeMode) {
        if (element == ThemeMode.system) return;
        state = element;
      }
    }
  }
}
