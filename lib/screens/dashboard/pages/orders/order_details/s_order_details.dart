import 'package:flutter/cupertino.dart' show CupertinoColors, CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/data/order/m_order.dart';

import '../../../../../extensions/build_context.dart';
import '../../../../../widgets/adaptive/w_icon.dart';
import '../w_order_items_table.dart';
import '/core/theme_data.dart';
import '/widgets/adaptive/w_card.dart';
import 'w_order_steps.dart';

class OrderDetailsScreen extends ConsumerWidget {
  const OrderDetailsScreen(this._order, {super.key});

  static const routeName = '/orderDetails';

  final Order? _order;

  // IconData _getOrderStatus(Order order) {
  //   final orderStatus = order.status;
  //   final paymentMethod = order.paymentMethod;
  //
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order =
        ModalRoute.of(context)?.settings.arguments as Order? ?? _order!;
    final translations = context.loc;

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(translations.order_with_other_number(order.orderNumber)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: AdaptiveCard(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.green.shade100,
                            child: Icon(
                              PlatformAdaptiveIcon.getPlatformIconData(
                                iconData: Icons.check_circle,
                                cupertinoIconData:
                                    CupertinoIcons.checkmark_alt_circle_fill,
                              ),
                              size: 45,
                              color: CupertinoColors.activeGreen,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Payment success',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 12),
                          const Divider(),
                          Text(
                            'Order payment method ${order.paymentMethod.name}',
                          ),
                          Text(
                            translations.order_total_with_price(
                              '${order.totalSalePrice.toStringAsFixed(2).replaceFirst('.00', '')}'
                              '\$',
                            ),
                          ),
                          if (order.totalOriginalPrice !=
                              order.totalSalePrice) ...[
                            Text(translations
                                .order_total_before_discounts_with_price(
                              '${order.totalOriginalPrice.toStringAsFixed(2).replaceFirst('.00', '')}'
                              '\$',
                            )),
                            Text(
                              translations
                                  .congratulations_you_have_saved_with_price(
                                (order.totalOriginalPrice -
                                        order.totalSalePrice)
                                    .toStringAsFixed(2)
                                    .replaceFirst('.00', ''),
                              ),
                            )
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: double.infinity,
                  child: AdaptiveCard(
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        children: [],
                      ),
                    ),
                  ),
                ),
                OrderDetailsSteps(order: order),
                Theme(
                  data: MyAppTheme.getAppMaterialTheme(context, ref),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: OrderItemsTable(order: order),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
