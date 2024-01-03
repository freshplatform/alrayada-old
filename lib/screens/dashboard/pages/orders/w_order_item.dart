import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_alrayada/data/order/m_order.dart';

import '../../../../providers/p_order.dart';
import '/core/locales.dart';
import '/core/theme_data.dart';
import '/screens/dashboard/pages/orders/w_cancel_order.dart';
import '/services/native/connectivity_checker/s_connectivity_checker.dart';
import '/services/native/url_launcher/s_url_launcher.dart';
import '/widgets/adaptive/messenger.dart';
import '/widgets/buttons/w_outlined_button.dart';
import '/widgets/errors/w_internet_error.dart';
import 'order_details/s_order_details.dart';
import 'w_order_items_table.dart';

class OrderItemWidget extends ConsumerStatefulWidget {
  const OrderItemWidget({
    required this.index, required this.order, super.key,
  });

  final int index;
  final Order order;

  @override
  ConsumerState<OrderItemWidget> createState() => _OrderItemState();
}

class _OrderItemState extends ConsumerState<OrderItemWidget> {
  var _expanded = false;
  var _loading = false;

  CupertinoThemeData get cupertinoTheme => CupertinoTheme.of(context);

  ThemeData get materialTheme => Theme.of(context);

  Color? getCircleAvatarBackgroundColor(Order order) {
    switch (order.status) {
      case OrderStatus.approved:
        return isCupertino(context)
            ? CupertinoColors.activeGreen
            : Colors.green;
      case OrderStatus.pending:
        return isCupertino(context) ? CupertinoColors.systemGrey : Colors.grey;
      case OrderStatus.rejected:
        return isCupertino(context)
            ? CupertinoColors.destructiveRed
            : Colors.redAccent;
      case OrderStatus.cancelled:
        return Colors.blueGrey;
      default:
        return null;
    }
  }

  /// First check if the order is paid, then pay
  Future<void> _payOrder(Order order) async {
    final translations = AppLocalizations.of(context)!;
    final hasConnection =
        await ConnectivityCheckerService.instance.hasConnection();
    if (!hasConnection) {
      Future.microtask(() => showPlatformDialog(
          context: context,
          builder: (context) => const InternetErrorWithoutTryAgainDialog()));
      return;
    }
    try {
      setState(() => _loading = true);
      final isOrderPaid = await ref
          .read(OrderItemNotifier.orderItemProvider(order).notifier)
          .isOrderPaid();
      if (!isOrderPaid) {
        Future.microtask(
          () => AdaptiveMessenger.showPlatformMessage(
            context: context,
            message: translations.transaction_of_order_not_paid_msg,
          ),
        );
        final payUrl = order.paymentMethodData['payUrl'];
        if (payUrl == null) {
          Future.microtask(() => AdaptiveMessenger.showPlatformMessage(
              context: context, message: translations.unknown_error));
          return;
        }
        await UrlLauncherService.instance.launchStringUrl(
          payUrl,
        );
        return;
      }
      Future.microtask(
        () => AdaptiveMessenger.showPlatformMessage(
          context: context,
          message: translations.order_has_paid_msg,
          title: translations.success,
        ),
      );
    } catch (e) {
      Future.microtask(
        () => AdaptiveMessenger.showPlatformMessage(
          context: context,
          message: translations.unknown_error_with_msg(e.toString()),
          title: translations.error,
          useSnackBarInMaterial: false,
        ),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context)!;
    final order = ref.watch(OrderItemNotifier.orderItemProvider(widget.order));
    final items = [
      Text(
        translations.last_update_in_with_date(
            DateFormat('yyyy/MM/dd h:mm a').format(order.updatedAt)),
        style: isCupertino(context)
            ? cupertinoTheme.textTheme.dateTimePickerTextStyle
            : materialTheme.textTheme.titleSmall,
        textAlign: TextAlign.center,
      ),
      if (order.deliveryDate != null)
        Text(
          translations.your_order_will_be_delivered_on_with_delivery_date(
              DateFormat.yMMMMEEEEd().format(order.deliveryDate!)),
          style: isCupertino(context)
              ? cupertinoTheme.textTheme.dateTimePickerTextStyle
              : materialTheme.textTheme.titleSmall,
          textAlign: TextAlign.center,
        ),
      Text(
        '${translations.order_items}:',
        style: isCupertino(context)
            ? cupertinoTheme.textTheme.navTitleTextStyle
            : materialTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w100,
              ),
        textAlign: TextAlign.center,
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: OrderItemsTable(order: order),
      ),
      if (order.adminNotes.trim().isNotEmpty) ...[
        Text(
          '${translations.admin_notes.trim()}:',
          textAlign: TextAlign.center,
          style: isCupertino(context)
              ? cupertinoTheme.textTheme.navTitleTextStyle
              : materialTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w100,
                ),
        ),
        Text(
          order.adminNotes,
          style: MyAppTheme.getNormalTextStyle(context),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 15)
      ],
      if (order.notes.trim().isNotEmpty) ...[
        Text(
          '${translations.notes.trim()}:',
          textAlign: TextAlign.center,
          style: isCupertino(context)
              ? cupertinoTheme.textTheme.navTitleTextStyle
              : materialTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w100,
                ),
        ),
        Text(
          order.notes,
          style: MyAppTheme.getNormalTextStyle(context),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 15)
      ],
      if (order.status == OrderStatus.pending)
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: AdaptiveOutlinedButton(
            child: Text(translations.cancel),
            onPressed: () async {
              final success = await showPlatformDialog<bool>(
                    context: context,
                    builder: (context) => CancelOrderDialog(order),
                  ) ??
                  false;
              if (!success) return;
            },
          ),
        ),
    ];
    // AdaptiveCard(
    //   child: AnimatedContainer(
    //     height: _expanded ? min(order.items.length * 20 + 180, 250) : 100,
    //     duration: const Duration(milliseconds: 100),
    //     curve: Curves.easeIn,
    //     child: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         PlatformListTile(
    //           onTap: () => Navigator.of(context)
    //               .pushNamed(OrderDetailsScreen.routeName, arguments: order),
    //           title: Text('${widget.index + 1} - #${order.orderNumber}'),
    //           subtitle: Text(
    //             translations.order_total_with_price(
    //                 '${order.totalSalePrice.toStringAsFixed(2).replaceFirst('.00', '')}\$'),
    //             overflow: TextOverflow.ellipsis,
    //           ),
    //           cupertino: (context, platform) => CupertinoListTileData(
    //             leadingSize: 50,
    //           ),
    //           leading: CircleAvatar(
    //             maxRadius: 30,
    //             backgroundColor: getCircleAvatarBackgroundColor(order),
    //             child: Text(
    //               order.status.name,
    //               style: (isCupertino(context)
    //                       ? cupertinoTheme.textTheme.tabLabelTextStyle
    //                       : materialTheme.textTheme.labelSmall)
    //                   ?.copyWith(
    //                 color: Colors.white,
    //               ),
    //             ),
    //           ),
    //           trailing: PlatformIconButton(
    //             onPressed: () {
    //               setState(() {
    //                 _expanded = !_expanded;
    //               });
    //             },
    //             icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
    //           ),
    //         ),
    //         if (_expanded)
    //           Expanded(
    //             child: ListView(
    //               children: items,
    //             ),
    //           )
    //       ],
    //     ),
    //   ),
    // );
    return ExpansionPanelList(
      expansionCallback: (index, isExpanded) =>
          setState(() => _expanded = !isExpanded),
      children: [
        ExpansionPanel(
          isExpanded: _expanded,
          headerBuilder: (context, isExpanded) => GestureDetector(
            onTap: () => Navigator.of(context)
                .pushNamed(OrderDetailsScreen.routeName, arguments: order),
            child: PlatformListTile(
              title: Text('${widget.index + 1} - #${order.orderNumber}'),
              subtitle: Text(
                translations.order_total_with_price(
                    '${order.totalSalePrice.toStringAsFixed(2).replaceFirst('.00', '')}\$'),
                overflow: TextOverflow.ellipsis,
              ),
              cupertino: (context, platform) => CupertinoListTileData(
                leadingSize: 50,
              ),
              leading: CircleAvatar(
                maxRadius: 30,
                backgroundColor: getCircleAvatarBackgroundColor(order),
                child: Text(
                  order.status.name,
                  style: (isCupertino(context)
                          ? cupertinoTheme.textTheme.tabLabelTextStyle
                          : materialTheme.textTheme.labelSmall)
                      ?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              trailing:
                  !order.isPaid && order.paymentMethod != PaymentMethod.cash
                      ? (_loading
                          ? const CircularProgressIndicator.adaptive()
                          : PlatformTextButton(
                              onPressed: () => _payOrder(order),
                              child: Text(translations.pay_order_msg),
                            ))
                      : const SizedBox.shrink(),
            ),
          ),
          body: SizedBox(
            height: min(order.items.length * 20 + 120, 250),
            child: ListView(
              children: items,
            ),
          ),
        ),
      ],
    );
  }
}
