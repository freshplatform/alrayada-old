import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/core/theme_data.dart';

class ProductPrice extends ConsumerWidget {
  const ProductPrice({
    required this.originalPrice,
    required this.discountPercentage,
    super.key,
    this.textAlign = TextAlign.center,
    this.textScaleFactor = 1.0,
    this.haveGradient = true,
  });
  final double originalPrice;
  final double discountPercentage;
  final TextAlign textAlign;
  final double textScaleFactor;
  final bool haveGradient;

  bool get isDiscount => discountPercentage > 0;

  double get salePrice {
    return originalPrice - (originalPrice * (discountPercentage / 100));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return isDiscount
        ? RichText(
            textAlign: textAlign,
            // overflow: TextOverflow.ellipsis,
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: [
                TextSpan(
                  text:
                      '\$${salePrice.toStringAsFixed(1).replaceFirst('.0', '')}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: (haveGradient ||
                            (!haveGradient && MyAppTheme.isDark(context)))
                        ? Colors.white
                        : null,
                  ),
                ),
                const TextSpan(text: ' '),
                TextSpan(
                  text:
                      '\$${originalPrice.toStringAsFixed(1).replaceFirst('.0', '')}',
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    fontWeight: FontWeight.w100,
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            textScaler: TextScaler.linear(textScaleFactor),
          )
        : Text(
            '${salePrice.toStringAsFixed(1).replaceFirst('.0', '')}\$',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: (haveGradient ||
                      (!haveGradient && MyAppTheme.isDark(context)))
                  ? Colors.white
                  : null,
            ),
          );
  }
}
