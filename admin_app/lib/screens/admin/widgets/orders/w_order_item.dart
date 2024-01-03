import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_alrayada/data/order/m_order.dart';

import '../../../../providers/p_order.dart';
import '../../../../widgets/w_product_price.dart';
import '../../../chat/s_chat.dart';
import '../users/w_user_item.dart';
import 'w_approve_reject_order.dart';
import 'w_print_order.dart';

class OrderItem extends ConsumerStatefulWidget {
  const OrderItem({
    required this.index, required this.order, super.key,
  });

  final int index;
  final Order order;

  @override
  ConsumerState<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends ConsumerState<OrderItem> {
  var _expanded = false;

  Color? getCircleAvatarBackgroundColor(Order order) {
    switch (order.status) {
      case OrderStatus.approved:
        return Colors.green;
      case OrderStatus.rejected:
        return Colors.red;
      case OrderStatus.cancelled:
        return Colors.blue;
      case OrderStatus.pending:
        return Colors.grey;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final order = ref.watch(OrderItemNotififer.provider(widget.order));
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: ExpansionPanelList(
        expandedHeaderPadding: const EdgeInsets.all(15),
        expansionCallback: (panelIndex, isExpanded) {
          setState(() {
            _expanded = !isExpanded;
          });
        },
        children: [
          ExpansionPanel(
            headerBuilder: (context, isExpanded) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                    '${widget.index + 1} - #${order.orderNumber} from ${order.userData?.labName}'),
                subtitle: Text(
                  'Order total: ${order.totalSalePrice.toStringAsFixed(2)}\$',
                ),
                leading: CircleAvatar(
                  maxRadius: 40,
                  backgroundColor: getCircleAvatarBackgroundColor(order),
                  foregroundColor:
                      order.status != OrderStatus.pending ? Colors.white : null,
                  child: Text(order.status.name),
                ),
                trailing: PopupMenuButton(
                  itemBuilder: (context) => <PopupMenuEntry<String>>[
                    PopupMenuItem(
                      child: const Text('Approve'),
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => ApproveRejectOrderDialog(
                          order: order,
                          approve: true,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      child: const Text('Reject'),
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => ApproveRejectOrderDialog(
                          order: order,
                          approve: false,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      child: const Text('Print'),
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => PrintOrder(order),
                      ),
                    ),
                    PopupMenuItem(
                      child: const Text('Chat'),
                      onTap: () => Navigator.of(context).pushNamed(
                        ChatScreen.routeName,
                        arguments: order.userId,
                      ),
                    ),
                    PopupMenuItem(
                      child: const Text('User data'),
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) =>
                            UserItemDataDialog(order.userData!),
                      ),
                    ),
                    PopupMenuItem(
                      child: const Text('Delete'),
                      onTap: () async {
                        final error = await ref
                            .read(OrdersNotifier.provider.notifier)
                            .deleteOrder(widget.index);
                        if (error != null) {
                          Future.microtask(() {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                error.toString(),
                              ),
                            ));
                          });
                        }
                      },
                    ),
                    PopupMenuItem(
                      child: const Text('Approve'),
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => ApproveRejectOrderDialog(
                          order: order,
                          approve: true,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      child: const Text('Reject'),
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => ApproveRejectOrderDialog(
                          order: order,
                          approve: false,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      child: const Text('Print'),
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => PrintOrder(order),
                      ),
                    ),
                    PopupMenuItem(
                      child: const Text('Chat'),
                      onTap: () => Navigator.of(context).pushNamed(
                        ChatScreen.routeName,
                        arguments: order.userId,
                      ),
                    ),
                    PopupMenuItem(
                      child: const Text('User data'),
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) =>
                            UserItemDataDialog(order.userData!),
                      ),
                    ),
                    PopupMenuItem(
                      child: const Text('Delete'),
                      onTap: () async {
                        final error = await ref
                            .read(OrdersNotifier.provider.notifier)
                            .deleteOrder(widget.index);
                        if (error != null) {
                          Future.microtask(() {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(error.toString()),
                            ));
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            body: Column(
              children: [
                Text(
                  'Last update in ${DateFormat().format(order.updatedAt)}',
                ),
                Text(
                  'Order items:',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Table(
                    border: TableBorder.all(color: Colors.grey, width: 1),
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          color: isDark ? Colors.red : Colors.white54,
                        ),
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Name',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Price',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Quantity',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      ...order.items.map((orderItem) {
                        return TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                orderItem.product.name,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ProductPrice(
                                originalPrice: orderItem.product.originalPrice,
                                discountPercentage:
                                    orderItem.product.discountPercentage,
                                haveGradient: false,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                orderItem.quantity.toString(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        );
                      }).toList()
                    ],
                  ),
                ),
                if (order.notes.trim().isNotEmpty) ...[
                  Text(
                    'Notes:',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium,
                  ),
                  Text(
                    order.notes,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15)
                ],
                if (/*(order.status == OrderStatus.Approved ||
                        order.status == OrderStatus.Rejected) &&*/
                    order.adminNotes.trim().isNotEmpty) ...[
                  Text(
                    'Admin notes:',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleSmall,
                  ),
                  Text(
                    order.adminNotes,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15)
                ],
              ],
            ),
            canTapOnHeader: false,
            isExpanded: _expanded,
          ),
        ],
      ),
    );
  }
}
