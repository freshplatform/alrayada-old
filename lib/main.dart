import 'package:flutter/material.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/shared_alrayada.dart';

import '/providers/p_settings.dart';
import '/providers/p_theme_mode.dart';
import '/providers/p_user.dart';
import '/screens/auth/s_auth.dart';
import '/screens/category_details/s_category_details.dart';
import '/screens/dashboard/s_dashboard.dart';
import '/screens/favorites/s_favorites.dart';
import '/screens/notification/s_notification_list.dart';
import '/screens/on_boarding/s_on_boarding.dart';
import '/screens/product_details/s_product_details.dart';
import '/screens/settings/s_settings.dart';
import '/screens/view_products/s_products.dart';
import 'core/app_initializer/s_app_initializer.dart';
import 'core/app_router.dart';
import 'core/theme_data.dart';
import 'core/url_app_configurations/configure_nonweb.dart'
    if (dart.library.html) 'core/url_app_configurations/configure_web.dart';
import 'l10n/app_localizations.dart';
import 'screens/account_data/s_account_data.dart';
import 'screens/dashboard/pages/orders/order_details/s_order_details.dart';
import 'screens/privacy_policy/s_privacy_policy.dart';
import 'screens/support/s_support.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureAppUrlStrategy(); // for web
  await AppInitializerService.instance.initialize();

  final providerContainer = ProviderContainer();
  await providerContainer
      .read(SettingsNotifier.settingsProvider.notifier)
      .loadSettings();
  await providerContainer.read(UserNotifier.provider.notifier).loadSavedUser();
  runApp(UncontrolledProviderScope(
    container: providerContainer,
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PlatformProvider(
      builder: (context) => Consumer(
        builder: (context, ref, __) {
          final themeMode = ref.watch(ThemeModeNotifier.themeModeProvider);
          return PlatformTheme(
            builder: (context) => PlatformApp(
              debugShowCheckedModeBanner: false,
              title: ServerConfigurations.appName,
              cupertino: (context, platform) => CupertinoAppData(
                theme: MyAppTheme.cupertinoThemeData(
                  themeMode: themeMode,
                ),
              ),
              material: (context, platform) => MaterialAppData(
                themeMode: themeMode,
                theme: MyAppTheme.materialLightTheme(),
                darkTheme: MyAppTheme.materialDarkTheme(),
              ),
              navigatorKey: AppRouter.navigatorKey,
              onUnknownRoute: AppRouter.onUnknownRoute,
              onGenerateRoute: (settings) =>
                  AppRouter.onGenerateRoute(settings, ref),
              home: ref
                      .read(SettingsNotifier.settingsProvider)
                      .showOnBoardingScreen
                  ? const OnBoardingScreen()
                  : const DashboardScreen(),
              routes: {
                AuthScreen.routeName: (context) => const AuthScreen(),
                CategoryDetailsScreen.routeName: (context) =>
                    const CategoryDetailsScreen(),
                ProductsScreen.routeName: (context) => const ProductsScreen(),
                ProductDetailsScreen.routeName: (context) =>
                    const ProductDetailsScreen(),
                AccountDataScreen.routeName: (context) =>
                    const AccountDataScreen(),
                OrderDetailsScreen.routeName: (context) =>
                    const OrderDetailsScreen(null),
                SettingsScreen.routeName: (context) => const SettingsScreen(),
                SupportScreen.routeName: (context) => const SupportScreen(),
                FavoritesScreen.routeName: (context) => const FavoritesScreen(),
                OnBoardingScreen.routeName: (context) =>
                    const OnBoardingScreen(),
                DashboardScreen.routeName: (context) => const DashboardScreen(),
                NotificationListScreen.routeName: (context) =>
                    const NotificationListScreen(),
                PrivacyPolicyScreen.routeName: (context) =>
                    const PrivacyPolicyScreen()
              },
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
            ),
            themeMode: themeMode,
            materialDarkTheme: MyAppTheme.materialDarkTheme(),
            materialLightTheme: MyAppTheme.materialLightTheme(),
            cupertinoDarkTheme: MyAppTheme.cupertinoThemeData(
              themeMode: themeMode,
            ),
            cupertinoLightTheme: MyAppTheme.cupertinoThemeData(
              themeMode: themeMode,
            ),
          );
        },
      ),
    );
  }
}
