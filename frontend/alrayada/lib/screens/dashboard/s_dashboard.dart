import 'package:alrayada/screens/dashboard/cupertino/w_cupertio_scaffold.dart';
import 'package:alrayada/screens/dashboard/material/w_material_scaffold.dart';
import 'package:alrayada/services/native/notifications/s_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/locales.dart';
import '/providers/p_cart.dart';
import '/services/native/connectivity_checker/s_connectivity_checker.dart';
import '/utils/platform_checker.dart';
import '/widgets/adaptive/messenger.dart';
import '../../services/networking/http_clients/dio/s_dio.dart';
import '../../utils/constants/constants.dart';
import '../../widgets/adaptive/w_icon.dart';
import 'models/m_navigation_item.dart';
import 'pages/account/w_account_page.dart';
import 'pages/cart/w_cart_page.dart';
import 'pages/categories/w_categories_page.dart';
import 'pages/home/w_home_page.dart';
import 'pages/orders/w_orders_page.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  static const routeName = '/dashboard';

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final GlobalKey<MaterialScaffoldDashbardState> _materialScaffoldKey =
      GlobalKey();
  final GlobalKey<CupertinoScaffoldDashboardState> _cupertinoScaffoldKey =
      GlobalKey();

  @override
  void initState() {
    super.initState();
    NotificationsService.instanse.registerNotificationsHandlers(context, ref);
    // FirebaseMessaging.instance.onTokenRefresh.listen((newFcmToken) =>
    //     Provider.of<UserProvider>(context, listen: false)
    //         .updateDeviceToken(fcmToken: newFcmToken));
    if (PlatformChecker.isMobileDevice()) {
      // OneSignal.shared.setNotificationOpenedHandler((openedResult) {
      //   ref
      //       .read(NotificationNotififer.notificationsProvider.notifier)
      //       .addNotificationFromPushNotification(
      //         MyAppNotification.fromOneSignal(openedResult.notification),
      //       );
      // });
      // OneSignal.shared.setNotificationWillShowInForegroundHandler(
      //     (OSNotificationReceivedEvent event) {
      //   // Will be called whenever a notification is received in foreground
      //   // Display Notification, pass null param for not displaying the notification
      //   ref
      //       .read(NotificationNotififer.notificationsProvider.notifier)
      //       .addNotificationFromPushNotification(
      //         MyAppNotification.fromOneSignal(event.notification),
      //       );
      //   event.complete(event.notification);
      // });
    }
    // FirebaseMessaging.onMessage.listen((message) async {
    //   await Provider.of<NotificationProvider>(context, listen: false)
    //       .addNotificationFromPushNotification(
    //     MyAppNotification.fromFcm(message),
    //   );
    //   displayNotification(message.notification!);
    // });
    // FirebaseMessaging.onBackgroundMessage((message) async {
    //   await Provider.of<NotificationProvider>(context, listen: false)
    //       .addNotificationFromPushNotification(MyAppNotification.fromFcm(message));
    // });
    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //   if (message.notification == null) return;
    //   displayNotification(message.notification!);
    // });
    handleLimitError();
    updateAndroidAppByGooglePlay();
  }

  // void displayNotification(RemoteNotification notification) =>
  //     AdaptiveMessenger.showPlatformMessage(
  //       context: context,
  //       useSnackBarInMaterial: false,
  //       message: notification.body ?? 'There is no any message',
  //       title: notification.title ?? 'There is no any title',
  //     );

  Future<void> updateAndroidAppByGooglePlay() async {
    if (PlatformChecker.isAndroidProduct()) {
      final hasConnection =
          await ConnectivityCheckerService.instance.hasConnection();
      if (!hasConnection) return;
      const channel = MethodChannel("${Constants.androidPackageName}/app");
      channel.invokeMethod("updateAndroidAppByGooglePlay");
    }
  }

  Future<void> handleLimitError() async {
    await Future.delayed(Duration.zero);
    final translations =
        await Future.microtask(() => AppLocalizations.of(context)!);
    DioService.handleServerLimitError(
      () => AdaptiveMessenger.showPlatformMessage(
        context: context,
        message: translations.server_limit_error_msg,
        title: translations.server_limit_error_title,
        useSnackBarInMaterial: false,
      ),
    );
  }

  List<NavigationItem> get _screens {
    final translations = AppLocalizations.of(context)!;
    return [
      NavigationItem(
        body: HomePage(
          key: const PageStorageKey('HomePage'),
          navigate: navigateToNewItem,
        ),
        label: translations.home,
        icon: const PlatformAdaptiveIcon(
          iconData: Icons.dashboard_outlined,
          cupertinoIconData: CupertinoIcons.home,
        ),
      ),
      NavigationItem(
        body: const CategoriesPage(
          key: PageStorageKey('Categories'),
        ),
        label: translations.categories,
        icon: const PlatformAdaptiveIcon(
          iconData: Icons.category_outlined,
          cupertinoIconData: CupertinoIcons.list_bullet,
        ),
      ),
      NavigationItem(
        body: const CartPage(
          key: PageStorageKey('Cart'),
        ),
        label: translations.shopping_cart,
        icon: Consumer(
          builder: (context, ref, _) {
            final cartItems = ref.watch(CartNotifier.cartProvider);
            return Badge(
              label: Text(
                cartItems.length.toString(),
                textScaleFactor: 1,
              ),
              // value: provider.itemCount.toString(),
              backgroundColor:
                  isCupertino(context) ? CupertinoColors.systemRed : null,
              child: const PlatformAdaptiveIcon(
                iconData: Icons.shopping_bag_outlined,
                cupertinoIconData: CupertinoIcons.shopping_cart,
              ),
              // context: context,
            );
          },
        ),
      ),
      NavigationItem(
        body: const OrdersPage(
          key: PageStorageKey('OrdersPage'),
        ),
        label: translations.orders,
        icon: const PlatformAdaptiveIcon(
          iconData: Icons.shopping_basket,
          cupertinoIconData: CupertinoIcons.square_stack_3d_down_right,
        ),
      ),
      NavigationItem(
        body: AccountPage(
          key: const PageStorageKey('Account'),
          navigate: navigateToNewItem,
        ),
        label: translations.account,
        icon: Icon(PlatformChecker.isAppleProduct()
            ? CupertinoIcons.person_alt_circle_fill
            : Icons.account_box_rounded),
      ),
    ];
  }

  void navigateToNewItem(int newIndex) {
    if (isCupertino(context)) {
      _cupertinoScaffoldKey.currentState!.navigateToNewItem(newIndex);
      return;
    }
    _materialScaffoldKey.currentState!.navigateToNewItem(newIndex);
  }

  @override
  Widget build(BuildContext context) {
    if (isCupertino(context)) {
      return CupertinoScaffoldDashboard(
        screens: _screens,
        key: _cupertinoScaffoldKey,
      );
    }
    return MaterialScaffoldDashbard(
      screens: _screens,
      key: _materialScaffoldKey,
    );
  }
}
