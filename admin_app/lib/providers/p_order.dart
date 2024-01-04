import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_alrayada/data/order/m_order.dart';
import 'package:shared_alrayada/services/networking/dio/dio.dart';
import 'package:shared_alrayada/utils/constants/routes.dart';

class OrderItemNotififer extends StateNotifier<Order> {
  OrderItemNotififer(super.state);

  static final provider = StateNotifierProvider.autoDispose
      .family<OrderItemNotififer, Order, Order>(
    (ref, order) => OrderItemNotififer(order),
  );

  Future<String?> approveOrder(
      String enterdAdminNotes, DateTime pickedDeliveryDate) async {
    try {
      await DioService.getDio()
          .patch(RoutesConstants.ordersRoutes.adminRoutes.approveOrder, data: {
        'orderId': state.id,
        'adminNotes': enterdAdminNotes,
        'deliveryDate': pickedDeliveryDate.toIso8601String(),
      });
      state = state.copyWith(
        adminNotes: enterdAdminNotes,
        deliveryDate: pickedDeliveryDate,
        status: OrderStatus.approved,
      );
      return null;
    } on DioException catch (e) {
      return 'Error: ${e.message}, ${e.response?.data}';
    }
  }

  Future<String?> rejectOrder(String adminNotes) async {
    try {
      await DioService.getDio()
          .patch(RoutesConstants.ordersRoutes.adminRoutes.rejectOrder, data: {
        'orderId': state.id,
        'adminNotes': adminNotes,
      });
      state =
          state.copyWith(adminNotes: adminNotes, status: OrderStatus.rejected);
      return null;
    } on DioException catch (e) {
      return 'Error: ${e.message}, ${e.response?.data}';
    }
  }
}

class OrdersNotifier extends StateNotifier<List<Order>> {
  OrdersNotifier() : super([]);

  static final provider = StateNotifierProvider<OrdersNotifier, List<Order>>(
    (ref) => OrdersNotifier(),
  );

  final _dio = DioService.getDio();

  // List<Order> get orders => [...state];

  var page = 1;
  var isInitLoading = true;
  var isAllLoadded = false;

  void clearOrders() {
    state = [];
  }

  void resetPage() {
    page = 1;
    isAllLoadded = false;
  }

  void reset({bool isInitLoading = false}) {
    clearOrders();
    resetPage();
    this.isInitLoading = isInitLoading;
  }

  Future<void> loadOrders({int limit = 20, String searchQuery = ''}) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        RoutesConstants.ordersRoutes.getOrders,
        queryParameters: {
          'page': page,
          'limit': limit,
          'searchQuery': searchQuery,
        },
      );
      final orders =
          response.data?.map((e) => Order.fromJson(e)).toList() ?? [];
      if (orders.isEmpty) {
        isAllLoadded = true;
        return;
      }
      state = [...state, ...orders];
    } on DioException {
      rethrow;
    }
  }

  Future<String?> deleteOrder(int index) async {
    try {
      await _dio
          .delete(RoutesConstants.ordersRoutes.adminRoutes.deleteOrder, data: {
        'orderId': state[index].id,
      });
      state = [...state]..removeAt(index);
      return null;
    } on DioException catch (e) {
      return 'Error: ${e.response?.data}, ${e.error}';
    }
  }
}
