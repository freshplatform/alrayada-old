import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../cubits/p_product.dart';
import '../../data/product/m_product.dart';
import '../../utils/extensions/build_context.dart';

class WishlistProductButton extends ConsumerStatefulWidget {
  const WishlistProductButton({required this.product, super.key});

  final Product product;

  @override
  ConsumerState<WishlistProductButton> createState() =>
      _WishlistProductButtonState();
}

class _WishlistProductButtonState extends ConsumerState<WishlistProductButton> {
  @override
  Widget build(BuildContext context) {
    final translations = context.loc;
    final productProvider = ref.read(
      ProductItemNotifier.productItemProvider(widget.product).notifier,
    );
    return PlatformTextButton(
      padding: const EdgeInsets.all(8),
      onPressed: () async {
        await productProvider.toggleFavoriteItem();
        setState(() {});
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Consumer(
            builder: (context, ref, child) {
              final product = ref.watch(
                ProductItemNotifier.productItemProvider(widget.product),
              );
              return Icon(
                product.isFavorite
                    ? PlatformIcons(context).favoriteSolid
                    : PlatformIcons(context).favoriteOutline,
              );
            },
          ),
          const SizedBox(width: 5),
          Text(translations.add_to_wishlist),
        ],
      ),
    );
  }
}
