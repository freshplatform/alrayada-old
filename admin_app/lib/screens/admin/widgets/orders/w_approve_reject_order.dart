import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/data/order/m_order.dart';

import '../../../../providers/p_order.dart';
import '../../../../widgets/w_date_picker.dart';

class ApproveRejectOrderDialog extends ConsumerStatefulWidget {
  const ApproveRejectOrderDialog(
      {required this.order, required this.approve, super.key});

  final Order order;
  final bool approve;

  @override
  ConsumerState<ApproveRejectOrderDialog> createState() =>
      _ApproveRejectOrderDialogState();
}

class _ApproveRejectOrderDialogState
    extends ConsumerState<ApproveRejectOrderDialog> {
  final _orderController = TextEditingController(text: '');
  var _isLoading = false;
  DateTime? _deliveryDate; // for approve order only

  void setLoading(bool newValue) => setState(() {
        _isLoading = newValue;
      });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          onPressed: _isLoading
              ? null
              : () async {
                  if (_deliveryDate == null && widget.approve) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Enter a delivery date')));
                    return;
                  }
                  setLoading(true);
                  final orderProvider = ref
                      .read(OrderItemNotififer.provider(widget.order).notifier);
                  final error = (widget.approve
                      ? await orderProvider.approveOrder(
                          _orderController.text, _deliveryDate!)
                      : await orderProvider.rejectOrder(_orderController.text));
                  if (error != null) {
                    Future.microtask(() {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(error)));
                    });
                    setLoading(false);
                    return;
                  }
                  Future.microtask(() => Navigator.of(context).pop());
                },
          child: _isLoading
              ? const Center(child: CircularProgressIndicator.adaptive())
              : Text(widget.approve ? 'Accept' : 'Reject'),
        ),
      ],
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _orderController,
              decoration: const InputDecoration(labelText: 'Admin notes'),
            ),
            if (widget.approve) ...[
              const SizedBox(height: 6),
              DatePickerWidget(
                onPickupDate: (date) => _deliveryDate = date,
                label: 'Delivery Date',
              )
            ]
          ],
        ),
      ),
      title: Text(
          '${widget.approve ? 'Accept' : 'Reject'} order #${widget.order.orderNumber}'),
    );
  }
}
