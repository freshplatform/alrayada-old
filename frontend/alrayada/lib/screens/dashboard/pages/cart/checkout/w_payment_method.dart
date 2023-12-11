import 'package:alrayada/core/locales.dart';
import 'package:enough_platform_widgets/enough_platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_alrayada/data/order/m_order.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../../widgets/adaptive/w_card.dart';

class PaymentMethodsSelector extends StatefulWidget {
  const PaymentMethodsSelector({Key? key, required this.onChanged})
      : super(key: key);
  final Function(PaymentMethod paymentMethod) onChanged;

  @override
  State<PaymentMethodsSelector> createState() => _PaymentMethodsSelectorState();
}

class _PaymentMethodsSelectorState extends State<PaymentMethodsSelector> {
  var _selectedPayment = PaymentMethod.cash;

  String _getPaymentMethodImage(PaymentMethod paymentMethod) {
    switch (paymentMethod) {
      case PaymentMethod.cash:
        return Assets.images.paymentMethods.cod.path;
      case PaymentMethod.zainCash:
        return Assets.images.paymentMethods.zainCash.path;
      case PaymentMethod.creditCard:
        return Assets.svg.paymentMethods.creditCard.path;
      default:
        return Assets.images.unknownData.path;
    }
  }

  Widget _loadAsset(String imagePath) {
    if (imagePath.endsWith('.svg')) {
      return SvgPicture.asset(
        imagePath,
        width: 50,
      );
    }
    return Image.asset(
      imagePath,
      width: 50,
    );
  }

  String _getPaymentMethodLabel(PaymentMethod paymentMethod) {
    final translations = AppLocalizations.of(context)!;
    switch (paymentMethod) {
      case PaymentMethod.creditCard:
        return translations.credit_card;
      case PaymentMethod.zainCash:
        return translations.zain_cash;
      case PaymentMethod.cash:
        return translations.cash;
      default:
        return translations.unknown;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveCard(
      child: Column(
        children: PaymentMethod.values
            .map(
              (e) => PlatformRadioListTile<PaymentMethod>(
                groupValue: _selectedPayment,
                value: e,
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _selectedPayment = e);
                  widget.onChanged(value);
                },
                title: Row(
                  children: [
                    Text(
                      _getPaymentMethodLabel(e),
                    ),
                    const Spacer(),
                    _loadAsset(_getPaymentMethodImage(e))
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
