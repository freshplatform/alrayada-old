import 'package:flutter/material.dart';

class ProductPrice extends StatelessWidget {
  const ProductPrice({
    Key? key,
    required this.originalPrice,
    required this.discountPercentage,
    this.textAlign = TextAlign.center,
    this.haveGradient = true,
  }) : super(key: key);
  final double originalPrice;
  final double discountPercentage;
  final TextAlign textAlign;
  final bool haveGradient;

  bool get isDiscount => discountPercentage > 0;

  double get salePrice {
    return originalPrice - (originalPrice * (discountPercentage / 100));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return isDiscount
        ? RichText(
            textAlign: textAlign,
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: [
                TextSpan(
                  text: '\$${salePrice.toStringAsFixed(1)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: (haveGradient || (!haveGradient && isDark))
                        ? Colors.white
                        : null,
                  ),
                ),
                const TextSpan(text: ' '),
                TextSpan(
                  text: '\$${originalPrice.toStringAsFixed(1)}',
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    fontWeight: FontWeight.w100,
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          )
        : Text(
            '${salePrice.toStringAsFixed(1)}\$',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: (haveGradient || (!haveGradient && isDark))
                  ? Colors.white
                  : null,
            ),
          );
  }
}
