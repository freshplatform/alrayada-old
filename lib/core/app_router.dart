import 'package:flutter/material.dart' show CircularProgressIndicator;
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/p_order.dart';
import '../providers/p_product.dart';
import '../screens/dashboard/pages/orders/order_details/s_order_details.dart';
import '../screens/not_found/s_not_found.dart';
import '../screens/product_details/s_product_details.dart';
import '../widgets/adaptive/messenger.dart';
import '../widgets/errors/w_error.dart';
import '../widgets/no_data/w_no_data.dart';
import 'locales.dart';

@immutable
class AppRouter {
  const AppRouter._();

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Route<dynamic>? onUnknownRoute(RouteSettings settings) =>
      platformPageRoute(
        context: navigatorKey.currentContext!,
        builder: (context) => const NotFoundScreen(),
      );

  static Route<dynamic>? onGenerateRoute(
      RouteSettings settings, WidgetRef ref) {
    final context = navigatorKey.currentContext!;
    final translations = AppLocalizations.of(context)!;

    final uri = Uri.parse(settings.name ?? '');
    if (uri.pathSegments.length == 2 && uri.pathSegments.first == 'products') {
      final id = uri.pathSegments[1];
      if (id.trim().isEmpty) {
        return _buildError(
            context: context,
            translations: translations,
            error: translations.unknown_error_with_msg('Product id is blank'));
      }
      final productProvider =
          ref.read(ProductsNotifier.productsProvider.notifier);
      final widget = FutureBuilder(
        future: productProvider.getProductById(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return const ErrorWithoutTryAgain();
          }
          if (snapshot.data == null) {
            return const NoDataWithoutTryAgain();
          }
          return ProductDetailsScreen(
            productData: snapshot.data,
          );
        },
      );
      return platformPageRoute(
        context: context,
        builder: (context) => widget,
      );
    }
    if (uri.pathSegments.length == 4 &&
        uri.pathSegments.first == 'orders' &&
        uri.pathSegments[1] == 'paymentGateways' &&
        uri.pathSegments[2] == 'zainCash' &&
        uri.pathSegments.last == 'afterPaymentRedirect') {
      final orderNumber = uri.queryParameters['orderNumber'] ?? '';
      final isOrderPaid =
          bool.tryParse(uri.queryParameters['isOrderPaid'] ?? '');
      if (orderNumber.trim().isEmpty) {
        return _buildError(
          context: context,
          translations: translations,
          error: translations.unknown_error_with_msg(
            'orderNumber parameter is missing.',
          ),
        );
      }
      if (isOrderPaid == null) {
        return _buildError(
          context: context,
          translations: translations,
          error: translations.unknown_error_with_msg(
            'isOrderPaid parameter is missing.',
          ),
        );
      }
      if (!isOrderPaid) {
        return _buildError(
          context: context,
          translations: translations,
          error: translations.unknown_error_with_msg(
            translations.transaction_of_order_not_paid_msg,
          ),
        );
      }
      final order = ref
          .read(OrdersNotifier.ordersProvider)
          .orders
          .where((element) => element.orderNumber == orderNumber)
          .firstOrNull;
      if (order == null) {
        return _buildError(
          context: context,
          translations: translations,
          error: translations.no_data,
        );
      }
      ref
          .read(OrderItemNotifier.orderItemProvider(order).notifier)
          .setOrderToPaid();
      AdaptiveMessenger.showPlatformMessage(
        context: context,
        message: translations.order_has_paid_msg,
      );
      return platformPageRoute(
        context: context,
        builder: (context) => OrderDetailsScreen(order),
      );
    }
    // return platformPageRoute(
    //   context: context,
    //   builder: (context) => const NotFoundScreen(),
    // );
    return null;
  }

  static PageRoute _buildError({
    required BuildContext context,
    required AppLocalizations translations,
    required String error,
  }) =>
      platformPageRoute(
        context: context,
        builder: (context) => PlatformScaffold(
          appBar: PlatformAppBar(
            title: Text(translations.error),
          ),
          body: SafeArea(
            child: Center(
              child: Text(
                error,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );
}
