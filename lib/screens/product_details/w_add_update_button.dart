import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/data/cart/m_cart.dart';
import 'package:shared_alrayada/data/product/m_product.dart';

import '../../extensions/build_context.dart';
import '../../providers/p_cart.dart';
import 'w_add_to_cart.dart';

class AddUpdateProductToCartButton extends ConsumerWidget {
  const AddUpdateProductToCartButton({required this.product, super.key});
  final Product product;

  static void showEditUpdate({
    required BuildContext context,
    required Product product,
    Cart? cart,
  }) =>
      showPlatformModalSheet(
        context: context,
        cupertino: CupertinoModalSheetData(
          barrierColor: Colors.black38,
        ),
        material: MaterialModalSheetData(
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(15),
              topLeft: Radius.circular(15),
            ),
          ),
          barrierColor: Colors.black38,
        ),
        builder: (context) => AddUpdateProductToCart(cart, product),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(
        CartNotifier.cartProvider); // watch changes for the cart and rebuilt
    final cartProvider = ref.read(CartNotifier.cartProvider.notifier);
    final translations = context.loc;
    return FutureBuilder<Cart?>(
      future: cartProvider.getCartItem(product.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        final cart = snapshot.data;
        final inCart = cart != null;
        return PlatformElevatedButton(
          padding: const EdgeInsets.all(8),
          onPressed: () {
            showEditUpdate(context: context, product: product);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(inCart
                  ? PlatformIcons(context).edit
                  : PlatformIcons(context).shoppingCart),
              const SizedBox(width: 5),
              Text(inCart ? translations.edit : translations.add_to_cart),
            ],
          ),
        );
      },
    );
  }
}
