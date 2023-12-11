import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/providers/p_theme_mode.dart';
import '/providers/p_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

@immutable
class SettingsData {
  final bool isAnimationsEnabled;
  final bool confirmDeleteCartItem;
  final bool clearCartAfterCheckout;
  final bool forceUseScrollableChart;
  final bool useMonthNumberInChart;
  final bool unFocusAfterSendMsg;
  final bool useClassicMsgBubble;
  final bool showOnBoardingScreen;
  final bool showOrderItemNotes;

  const SettingsData({
    this.isAnimationsEnabled = true,
    this.confirmDeleteCartItem = false,
    this.clearCartAfterCheckout = true,
    this.forceUseScrollableChart = false,
    this.useMonthNumberInChart = false,
    this.unFocusAfterSendMsg = true,
    this.useClassicMsgBubble = false,
    this.showOnBoardingScreen = true,
    this.showOrderItemNotes = true,
  });

  SettingsData copyWith({
    bool? isAnimationsEnabled,
    bool? confirmDeleteCartItem,
    bool? clearCartAfterCheckout,
    bool? forceUseScrollableChart,
    bool? useMonthNumberInChart,
    bool? unFocusAfterSendMsg,
    bool? useClassicMsgBubble,
    bool? showOnBoardingScreen,
    bool? showOrderItemNotes,
  }) =>
      SettingsData(
        isAnimationsEnabled: isAnimationsEnabled ?? this.isAnimationsEnabled,
        confirmDeleteCartItem:
            confirmDeleteCartItem ?? this.confirmDeleteCartItem,
        clearCartAfterCheckout:
            clearCartAfterCheckout ?? this.clearCartAfterCheckout,
        forceUseScrollableChart:
            forceUseScrollableChart ?? this.forceUseScrollableChart,
        useMonthNumberInChart:
            useMonthNumberInChart ?? this.useMonthNumberInChart,
        unFocusAfterSendMsg: unFocusAfterSendMsg ?? this.unFocusAfterSendMsg,
        useClassicMsgBubble: useClassicMsgBubble ?? this.useClassicMsgBubble,
        showOnBoardingScreen: showOnBoardingScreen ?? this.showOnBoardingScreen,
        showOrderItemNotes: showOrderItemNotes ?? this.showOrderItemNotes,
      );
}

class SettingsNotifier extends StateNotifier<SettingsData> {
  SettingsNotifier(this.themeModeProvider) : super(const SettingsData());

  static final settingsProvider =
      StateNotifierProvider<SettingsNotifier, SettingsData>(
    (ref) => SettingsNotifier(
      ref.read(ThemeModeNotifier.themeModeProvider.notifier),
    ),
  );

  static const animationsPrefKey = 'animations';
  static const confirmDeleteCartItemPrefKey = 'confirmDeleteCartItem';
  static const clearCartAfterCheckoutPrefKey = 'confirmDeleteCartItem';
  static const forceUseScrollableChartPrefKey = 'forceUseScrollableChart';
  static const useMonthNumberInChartPrefKey = 'useMonthNumberInChart';
  static const unFocusAfterSendMsgPrefKey = 'unFocusAfterSendMsg';
  static const useClassicMsgBubblePrefKey = 'useClassicMsgBubble';
  static const showOnBoardingScreenPrefKey = 'showOnBoardingScreen';

  /// In the order table
  static const showOrderItemNotesPrefKey = 'showOrderItemNotes';

  final ThemeModeNotifier themeModeProvider;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final isAnimationsEnabled = prefs.getBool(animationsPrefKey) ?? true;
    themeModeProvider.loadThemeMode(prefs);
    final confirmDeleteCartItem =
        prefs.getBool(confirmDeleteCartItemPrefKey) ?? false;
    final clearCartAfterCheckout =
        prefs.getBool(clearCartAfterCheckoutPrefKey) ?? true;
    final forceUseScrollableChart =
        prefs.getBool(forceUseScrollableChartPrefKey) ?? false;
    final useMonthNumberInChart =
        prefs.getBool(useMonthNumberInChartPrefKey) ?? false;
    final unFocusAfterSendMsg =
        prefs.getBool(unFocusAfterSendMsgPrefKey) ?? true;
    final useClassicMsgBubble =
        prefs.getBool(useClassicMsgBubblePrefKey) ?? false;
    final showOnBoardingScreen =
        prefs.getBool(showOnBoardingScreenPrefKey) ?? true;
    final showOrderItemNotes = prefs.getBool(showOrderItemNotesPrefKey) ?? true;

    state = SettingsData(
      isAnimationsEnabled: isAnimationsEnabled,
      confirmDeleteCartItem: confirmDeleteCartItem,
      clearCartAfterCheckout: clearCartAfterCheckout,
      forceUseScrollableChart: forceUseScrollableChart,
      useMonthNumberInChart: useMonthNumberInChart,
      unFocusAfterSendMsg: unFocusAfterSendMsg,
      useClassicMsgBubble: useClassicMsgBubble,
      showOnBoardingScreen: showOnBoardingScreen,
      showOrderItemNotes: showOrderItemNotes,
    );
  }

  Future<void> toggleSetAnimationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    final isAnimationEnabled = !state.isAnimationsEnabled;
    state = state.copyWith(isAnimationsEnabled: isAnimationEnabled);
    await prefs.setBool(animationsPrefKey, isAnimationEnabled);
  }

  Future<void> toggleConfirmDeleteCartItem() async {
    final prefs = await SharedPreferences.getInstance();
    final confirmDeleteCartItem = !state.confirmDeleteCartItem;
    state = state.copyWith(confirmDeleteCartItem: confirmDeleteCartItem);
    await prefs.setBool(confirmDeleteCartItemPrefKey, confirmDeleteCartItem);
  }

  Future<void> toggleClearCartAfterCheckout() async {
    final prefs = await SharedPreferences.getInstance();
    final clearCartAfterCheckout = !state.clearCartAfterCheckout;
    state = state.copyWith(clearCartAfterCheckout: clearCartAfterCheckout);
    await prefs.setBool(clearCartAfterCheckoutPrefKey, clearCartAfterCheckout);
  }

  Future<void> toggleForceUseScrollableChart() async {
    final prefs = await SharedPreferences.getInstance();
    final forceUseScrollableChart = !state.forceUseScrollableChart;
    state = state.copyWith(forceUseScrollableChart: forceUseScrollableChart);
    await prefs.setBool(
        forceUseScrollableChartPrefKey, forceUseScrollableChart);
  }

  Future<void> toggleUseMonthNumberInChart() async {
    final prefs = await SharedPreferences.getInstance();
    final useMonthNumberInChart = !state.useMonthNumberInChart;
    state = state.copyWith(useMonthNumberInChart: useMonthNumberInChart);
    await prefs.setBool(useMonthNumberInChartPrefKey, useMonthNumberInChart);
  }

  Future<void> toggleUnFocusAfterSendMsg() async {
    final prefs = await SharedPreferences.getInstance();
    final unFocusAfterSendMsg = !state.unFocusAfterSendMsg;
    state = state.copyWith(unFocusAfterSendMsg: unFocusAfterSendMsg);
    await prefs.setBool(unFocusAfterSendMsgPrefKey, unFocusAfterSendMsg);
  }

  Future<void> toggleUseClassicMsgBubble() async {
    final prefs = await SharedPreferences.getInstance();
    final useClassicMsgBubble = !state.useClassicMsgBubble;
    state = state.copyWith(useClassicMsgBubble: useClassicMsgBubble);
    await prefs.setBool(useClassicMsgBubblePrefKey, useClassicMsgBubble);
  }

  Future<void> dontShowOnBoardingScreen() async {
    final prefs = await SharedPreferences.getInstance();
    const showOnBoardingScreen = false;
    state = state.copyWith(showOnBoardingScreen: showOnBoardingScreen);
    await prefs.setBool(showOnBoardingScreenPrefKey, showOnBoardingScreen);
  }

  Future<void> toggleShowOrderItemNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final showOrderItemNotes = !state.showOrderItemNotes;
    state = state.copyWith(showOrderItemNotes: showOrderItemNotes);
    await prefs.setBool(showOrderItemNotesPrefKey, showOrderItemNotes);
  }

  Future<void> clearAllPrefs(BuildContext context, WidgetRef ref) async {
    await ref.read(UserNotifier.provider.notifier).logout(byUser: true);
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await loadSettings();
    // Don't show the on-boarding screen on next app launch
    state = state.copyWith(showOnBoardingScreen: false);
    themeModeProvider.setDefaultTheme();
  }
}
