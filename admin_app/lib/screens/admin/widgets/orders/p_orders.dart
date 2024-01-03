import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../providers/p_order.dart';
import 'w_order_item.dart';

class OrdersPage extends ConsumerStatefulWidget {
  const OrdersPage({super.key});

  @override
  ConsumerState<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends ConsumerState<OrdersPage> {
  late final ScrollController _scrollController;

  var _isLoadingMore = false;
  final _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  void setLoading(bool value) => setState(() {
        _isLoadingMore = value;
      });

  Future<void> _scrollListener() async {
    if (_scrollController.position.maxScrollExtent !=
        _scrollController.position.pixels) {
      return;
    }
    final orderProvider = ref.read(OrdersNotifier.provider.notifier);
    if (ref.read(OrdersNotifier.provider.notifier).isAllLoadded) {
      return;
    }
    setLoading(true);
    orderProvider.page++;
    await orderProvider.loadOrders();
    setLoading(false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget get content => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            Center(
              child: SizedBox(
                width: 300,
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Search...'),
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.text,
                  onChanged: (value) async {
                    if (value.isEmpty) {
                      final orderProvider =
                          ref.read(OrdersNotifier.provider.notifier);
                      setState(() {
                        orderProvider.reset();
                        _isLoadingMore = true;
                      });
                      await orderProvider.loadOrders();
                      setState(() {
                        _searchController.text = '';
                        _isLoadingMore = false;
                      });
                    }
                  },
                  onFieldSubmitted: (value) async {
                    final orderProvider =
                        ref.read(OrdersNotifier.provider.notifier);
                    setState(() {
                      orderProvider.reset();
                      _isLoadingMore = true;
                    });
                    await orderProvider.loadOrders(searchQuery: value);
                    setState(() {
                      _isLoadingMore = false;
                    });
                  },
                ),
              ),
            )
          ],
          leading: Tooltip(
            message: 'Refresh',
            child: Tooltip(
              message: 'Refresh',
              child: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  final orderProvider =
                      ref.read(OrdersNotifier.provider.notifier);
                  setState(() {
                    orderProvider.reset(isInitLoading: true);
                    _isLoadingMore = false;
                    _searchController.clear();
                  });
                },
              ),
            ),
          ),
        ),
        body: Consumer(
          builder: (context, ref, _) {
            final orders = ref.watch(OrdersNotifier.provider);
            return ListView.builder(
              controller: _scrollController,
              itemCount: _isLoadingMore ? orders.length + 1 : orders.length,
              padding: const EdgeInsets.all(15),
              itemBuilder: (context, index) {
                if (!(index < orders.length)) {
                  return const CircularProgressIndicator.adaptive();
                }
                final order = orders[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OrderItem(
                    index: index,
                    order: order,
                    key: ValueKey<int>(index),
                  ),
                );
              },
            );
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    final orderProvider = ref.read(OrdersNotifier.provider.notifier);
    if (!orderProvider.isInitLoading) return content;
    return FutureBuilder(
      future: orderProvider.loadOrders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        orderProvider.isInitLoading = false;
        return content;
      },
    );
  }
}
