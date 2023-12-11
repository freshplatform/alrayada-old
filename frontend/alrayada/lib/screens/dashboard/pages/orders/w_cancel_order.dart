import 'package:alrayada/providers/p_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/data/order/m_order.dart';

import '/core/locales.dart';

class CancelOrderDialog extends ConsumerStatefulWidget {
  const CancelOrderDialog(this.order, {Key? key}) : super(key: key);

  final Order order;

  @override
  ConsumerState<CancelOrderDialog> createState() => _CancelOrderDialogState();
}

class _CancelOrderDialogState extends ConsumerState<CancelOrderDialog> {
  var _isLoading = false;

  Order get order => widget.order;

  void setLoading(bool value) => setState(() {
        _isLoading = value;
      });

  Future<void> _submit() async {
    setLoading(true);
    final success = await ref
        .read(OrderItemNotifier.orderItemProvider(order).notifier)
        .cancelOrder();
    if (success) {
      Future.microtask(() => Navigator.of(context).pop(true));
      return;
    }
    setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context)!;
    return PlatformAlertDialog(
      material: (context, platform) => MaterialAlertDialogData(
          icon: const Icon(
        Icons.cancel,
      )),
      title:
          Text(translations.cancel_order_with_order_number(order.orderNumber)),
      content: Text(translations.are_you_sure_want_to_cancel_order),
      actions: [
        PlatformDialogAction(
          child: Text(translations.no),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        PlatformDialogAction(
          onPressed: _isLoading ? null : _submit,
          child: Text(translations.yes),
        ),
      ],
    );
  }
}
