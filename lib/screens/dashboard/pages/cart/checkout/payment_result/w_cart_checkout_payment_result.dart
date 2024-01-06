import 'package:flutter/widgets.dart';

import '../../../../../../data/order/m_order.dart';

class CartCheckoutPaymentResult extends StatelessWidget {
  const CartCheckoutPaymentResult({
    required this.order,
    required this.isOrderPaid,
    super.key,
  });

  final Order order;
  final bool isOrderPaid;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
