import 'package:dio/dio.dart' show DioException;
import 'package:flutter/services.dart' show MethodChannel;
import 'package:flutter/widgets.dart' show immutable, BuildContext;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/data/monthly_total/m_monthly_total.dart';
import 'package:shared_alrayada/data/order/m_order.dart';

import '../services/native/url_launcher/s_url_launcher.dart';
import '../utils/constants/constants.dart';
import '../utils/constants/routes.dart';
import '../utils/platform_checker.dart';
import '/providers/p_settings.dart';
import '/services/networking/http_clients/dio/s_dio.dart';
import 'p_cart.dart';

class OrderItemNotifier extends StateNotifier<Order> {
  OrderItemNotifier(super.order);

  static final orderItemProvider =
      StateNotifierProvider.autoDispose.family<OrderItemNotifier, Order, Order>(
    (ref, order) => OrderItemNotifier(order),
  );

  Future<bool> cancelOrder() async {
    try {
      await DioService.getDio().patch(
        RoutesConstants.ordersRoutes.cancelOrder,
        data: {
          'orderId': state.id,
        },
      );
      state = state.copyWith(status: OrderStatus.cancelled);
      return true;
    } on DioException {
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> isOrderPaid() async {
    try {
      final dio = DioService.getDio();
      final response = await dio.get<String>(
        RoutesConstants.ordersRoutes.isOrderPaid,
        queryParameters: {
          'orderNumber': state.orderNumber,
        },
      );
      final isOrderPaid = response.data == 'true';
      if (isOrderPaid && !state.isPaid) {
        state = state.copyWith(isPaid: true);
      }
      return isOrderPaid;
    } catch (e) {
      rethrow;
    }
  }

  void setOrderToPaid() {
    state = state.copyWith(isPaid: true);
  }
}

@immutable
class OrdersNotifierState {
  const OrdersNotifierState({
    this.monthlyTotals = const [],
    this.orders = const [],
  });
  final List<MonthlyTotal> monthlyTotals;
  final List<Order> orders;

  OrdersNotifierState copyWith({
    List<MonthlyTotal>? monthlyTotals,
    List<Order>? orders,
  }) =>
      OrdersNotifierState(
        monthlyTotals: monthlyTotals ?? this.monthlyTotals,
        orders: orders ?? this.orders,
      );
}

class OrdersNotifier extends StateNotifier<OrdersNotifierState> {
  OrdersNotifier() : super(const OrdersNotifierState());

  static final ordersProvider =
      StateNotifierProvider<OrdersNotifier, OrdersNotifierState>(
    (ref) => OrdersNotifier(),
  );

  final _dio = DioService.getDio();

  List<MonthlyTotal> get monthlyTotals => [...state.monthlyTotals];

  var isInitLoading = true;

  Future<List<Order>> loadOrders({int limit = 20, int page = 1}) async {
    try {
      if (isInitLoading) {
        // Clear the orders
        await Future.delayed(Duration.zero);
        state = state.copyWith(orders: List.empty());
        isInitLoading = false;
      }
      final response = await _dio.get<List<dynamic>>(
        RoutesConstants.ordersRoutes.getOrders,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
      final orders =
          response.data?.map((e) => Order.fromJson(e)).toList() ?? [];
      if (orders.isNotEmpty) {
        state = state.copyWith(orders: [...orders]);
      }
      return orders;
    } on DioException {
      rethrow;
    }
  }

  /// Create new order
  Future<void> checkout(BuildContext context, WidgetRef ref, String orderNotes,
      PaymentMethod paymentMethod) async {
    final cartItems = ref.read(CartNotifier.cartProvider);
    final cartProvider = ref.read(CartNotifier.cartProvider.notifier);
    final settingsProvider = ref.read(SettingsNotifier.settingsProvider);

    final items = cartItems.map((e) => e.cart).toList();
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        RoutesConstants.ordersRoutes.checkout,
        data: OrderRequest(
          items: items,
          notes: orderNotes,
          paymentMethod: paymentMethod,
        ).toJson(),
      );
      if (response.data == null) throw 'Response data is null';
      final order = Order.fromJson(response.data!);

      state = state.copyWith(orders: [...state.orders]..insert(0, order));

      // _orders.insert(0, order);
      if (settingsProvider.clearCartAfterCheckout) {
        await cartProvider.clearCart();
      }
      final currentMonth = DateTime.now().month;
      final index = state.monthlyTotals
          .indexWhere((element) => currentMonth == element.month);
      if (index != -1) {
        final data = state.monthlyTotals[index];
        final modifiedMonthlyTotals = [...state.monthlyTotals];
        monthlyTotals.removeAt(index);
        monthlyTotals.insert(
            index,
            MonthlyTotal(
                month: data.month, total: data.total + order.totalSalePrice));
        state = state.copyWith(monthlyTotals: modifiedMonthlyTotals);
      } else {
        final modifiedMonthlyTotals = [...state.monthlyTotals];
        modifiedMonthlyTotals.add(
            MonthlyTotal(month: currentMonth, total: order.totalSalePrice));
        state = state.copyWith(monthlyTotals: modifiedMonthlyTotals);
      }

      switch (paymentMethod) {
        case PaymentMethod.zainCash:
          final payUrl = order.paymentMethodData['payUrl'];
          if (payUrl == null) {
            return;
          }
          UrlLauncherService.instance.launchStringUrl(
            payUrl,
          );
          break;
        case PaymentMethod.cash:
          break;
        case PaymentMethod.creditCard:
          break;
      }
      if (PlatformChecker.isAndroidProduct()) {
        const appChannel = MethodChannel('${Constants.androidPackageName}/app');
        appChannel.invokeMethod('showAndroidAppFeedbackDialogByGooglePlay');
      }
    } on DioException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loadStatistics() async {
    try {
      final response = await _dio.get<List<dynamic>>(
        RoutesConstants.ordersRoutes.getStatistics,
      );
      final result =
          response.data?.map((e) => MonthlyTotal.fromJson(e)).toList() ?? [];
      final List<MonthlyTotal> newMonthlyTotals = [];
      newMonthlyTotals.addAll(result);
      state = state.copyWith(monthlyTotals: newMonthlyTotals);
    } on DioException {
      rethrow;
    }
  }

  void clearOrders() {
    state = state.copyWith(orders: List.empty());
  }
}
