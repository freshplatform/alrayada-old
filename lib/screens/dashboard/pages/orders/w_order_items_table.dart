import 'package:flutter/material.dart' show Colors;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/data/order/m_order.dart';

import '../../../../core/theme_data.dart';
import '../../../../widgets/w_price.dart';
import '/core/locales.dart';

class OrderItemsTable extends ConsumerWidget {
  const OrderItemsTable({required this.order, super.key});

  final Order order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final translations = AppLocalizations.of(context)!;
    return Table(
      border: TableBorder.all(color: Colors.grey, width: 0.2),
      children: [
        TableRow(
          decoration: BoxDecoration(
            color:
                MyAppTheme.isDark(context, ref) ? Colors.red : Colors.white54,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                translations.name,
                textAlign: TextAlign.center,
                style: MyAppTheme.getNormalTextStyle(context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                translations.price,
                textAlign: TextAlign.center,
                style: MyAppTheme.getNormalTextStyle(context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                translations.quantity,
                textAlign: TextAlign.center,
                style: MyAppTheme.getNormalTextStyle(context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                translations.notes,
                textAlign: TextAlign.center,
                style: MyAppTheme.getNormalTextStyle(context),
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
                  style: MyAppTheme.getNormalTextStyle(context),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: ProductPrice(
                  originalPrice: orderItem.product.originalPrice,
                  discountPercentage: orderItem.product.discountPercentage,
                  haveGradient: false,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  orderItem.quantity.toString(),
                  textAlign: TextAlign.center,
                  style: MyAppTheme.getNormalTextStyle(context),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  orderItem.notes.trim().isEmpty
                      ? translations.empty
                      : orderItem.notes,
                  textAlign: TextAlign.center,
                  style: orderItem.notes.trim().isEmpty
                      ? MyAppTheme.getNormalTextStyle(context)
                          .copyWith(color: Colors.grey)
                      : MyAppTheme.getNormalTextStyle(context),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}
