import 'package:flutter/widgets.dart';
import 'package:shared_alrayada/data/order/m_order.dart';

class CartCheckoutPaymentResult extends StatelessWidget {
  const CartCheckoutPaymentResult({
    Key? key,
    required this.order,
    required this.isOrderPaid,
  }) : super(key: key);

  final Order order;
  final bool isOrderPaid;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
