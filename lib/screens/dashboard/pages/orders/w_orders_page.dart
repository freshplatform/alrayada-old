import 'package:dio/dio.dart' show DioException, DioExceptionType;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../cubits/auth/auth_cubit.dart';
import '../../../../cubits/p_order.dart';
import '../../../../data/user/models/m_auth_credential.dart';

import '../../../../widgets/errors/w_error.dart';
import '../../models/m_navigation_item.dart';
import '/widgets/errors/w_internet_error.dart';
import '/widgets/errors/w_not_authenticated.dart';
import '/widgets/no_data/w_no_data.dart';
import 'w_order_item.dart';

class OrdersPage extends ConsumerStatefulWidget implements NavigationData {
  const OrdersPage({super.key});

  @override
  ConsumerState<OrdersPage> createState() => _OrdersPageState();

  @override
  NavigationItemData Function(BuildContext context, WidgetRef ref)
      get navigationItemData => (context, ref) {
            return const NavigationItemData(actions: []);
          };
}

class _OrdersPageState extends ConsumerState<OrdersPage> {
  late final ScrollController _scrollController;
  Future<void>? _loadOrdersFuture;

  var _page = 1;
  var _isAllLoaded = false;
  var _isLoadingMore = false;
  var _isInitLoading = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    final userCredential = context.read<AuthCubit>();
    if (userCredential.state.userCredential != null) {
      _loadOrdersFuture = ref
          .read(OrdersNotifier.ordersProvider.notifier)
          .loadOrders(page: _page);
    }
  }

  void _onUserProviderUpdate(UserCredential? userContainer) {
    if (userContainer == null) {
      return;
    }
    _loadOrdersFuture = ref
        .read(OrdersNotifier.ordersProvider.notifier)
        .loadOrders(page: _page);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.maxScrollExtent !=
            _scrollController.position.pixels ||
        _isAllLoaded) {
      return;
    }
    _page++;
    loadOrders();
  }

  Future<void> loadOrders() async {
    if (_isAllLoaded) return; // double-check
    setState(() {
      _isLoadingMore = true;
    });

    final loadedOrders =
        await ref.read(OrdersNotifier.ordersProvider.notifier).loadOrders(
              page: _page,
            );
    setState(() {
      _isLoadingMore = false;
    });
    if (loadedOrders.isEmpty) {
      _isAllLoaded = true;
    }
  }

  Widget get list {
    return Consumer(builder: (context, ref, _) {
      final ordersProvider = ref.watch(OrdersNotifier.ordersProvider);
      if (ordersProvider.orders.isEmpty) return const NoDataWithoutTryAgain();
      return ListView.builder(
        controller: _scrollController,
        itemCount: _isLoadingMore
            ? ordersProvider.orders.length + 1
            : ordersProvider.orders.length,
        itemBuilder: (context, index) {
          if (!(index < ordersProvider.orders.length)) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          final order = ordersProvider.orders[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: OrderItemWidget(
              key: ValueKey('${order.orderNumber}$index'),
              index: index,
              order: order,
            ),
          );
        },
      );
    });
  }

  void _refresh() => setState(() {
        _isInitLoading = true;
        ref.read(OrdersNotifier.ordersProvider.notifier).clearOrders();
        _loadOrdersFuture = ref
            .read(OrdersNotifier.ordersProvider.notifier)
            .loadOrders(page: _page);
      });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        _onUserProviderUpdate(state.userCredential);
      },
      builder: (context, state) {
        if (state.userCredential == null) {
          return const NotAuthenticatedError();
        }
        if (!_isInitLoading) {
          return list;
        }
        return FutureBuilder(
          future: _loadOrdersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            if (snapshot.hasError) {
              if (snapshot.error is DioException) {
                final dioException = snapshot.error as DioException;
                if (dioException.type == DioExceptionType.connectionError) {
                  return InternetErrorWithTryAgain(onTryAgain: _refresh);
                }
              }
              return ErrorWithTryAgain(onTryAgain: _refresh);
            }
            if (!snapshot.hasData) {
              return ErrorWithTryAgain(onTryAgain: _refresh);
            }
            _isInitLoading = false;
            return list;
          },
        );
      },
    );
  }
}
