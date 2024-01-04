import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/data/cart/m_cart.dart';
import 'package:shared_alrayada/data/product/m_product.dart';

import '../../extensions/build_context.dart';
import '/core/theme_data.dart';
import '/providers/p_cart.dart';

class AddUpdateProductToCart extends ConsumerStatefulWidget {
  const AddUpdateProductToCart(
    this.cart,
    this.product, {
    super.key,
  });

  /// For update
  final Cart? cart;
  final Product product;

  @override
  ConsumerState<AddUpdateProductToCart> createState() =>
      _AddUpdateProductToCartState();
}

class _AddUpdateProductToCartState
    extends ConsumerState<AddUpdateProductToCart> {
  var _quantity = 1;
  late final TextEditingController _notesController;

  static const _maxQuantity = 50;

  @override
  void initState() {
    super.initState();
    if (widget.cart != null) {
      _notesController = TextEditingController(text: widget.cart!.notes);
      _quantity = widget.cart!.quantity;
    } else {
      _notesController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  bool get inCart => widget.cart != null;

  Product get product => widget.product;
  Cart? get cart => widget.cart;

  void setQuantity(int value) {
    if (value < 1) {
      return;
    }
    if (value > _maxQuantity) {
      return;
    }
    setState(() => _quantity = value);
  }

  Future<void> _addUpdate() async {
    final cartProvider = ref.read(CartNotifier.cartProvider.notifier);
    if (inCart) {
      await cartProvider.updateCartItem(
        widget.cart!.copyWith(
          quantity: _quantity,
          notes: _notesController.text,
        ),
        product,
      );
    } else {
      cartProvider.addToCart(
        Cart(
          productId: product.id,
          quantity: _quantity,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          notes: _notesController.text,
        ),
        widget.product,
      );
    }
    Future.microtask(
      () => Navigator.of(context).pop(),
    );
  }

  Future<void> _remove() async {
    final cartProvider = ref.read(CartNotifier.cartProvider.notifier);
    await cartProvider.removeFromCart(
      CartItemData(cart: cart!, product: product),
    );
    Future.microtask(
      () => Navigator.of(context).pop(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cupertinoTheme = CupertinoTheme.of(context);
    final translations = context.loc;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Card(
        margin: EdgeInsets.zero,
        color: isCupertino(context) ? cupertinoTheme.barBackgroundColor : null,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            topLeft: Radius.circular(15),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              PlatformTextField(
                controller: _notesController,
                hintText: translations.notes,
                material: (context, platform) => MaterialTextFieldData(
                  decoration: InputDecoration(
                    labelText: translations.notes,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              Slider.adaptive(
                min: 1,
                max: _maxQuantity.toDouble(),
                value: _quantity.toDouble(),
                onChanged: (value) => setQuantity(value.toInt()),
              ),
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PlatformIconButton(
                      onPressed: () => setQuantity(_quantity - 1),
                      icon: Icon(PlatformIcons(context).remove),
                    ),
                    Text(
                      '${_quantity.toString()}\n\$${(_quantity * product.salePrice).toStringAsFixed(2).replaceFirst('0.00', '')}',
                      textAlign: TextAlign.center,
                      style: MyAppTheme.getNormalTextStyle(context),
                    ),
                    PlatformIconButton(
                      onPressed: () => setQuantity(_quantity + 1),
                      icon: Icon(PlatformIcons(context).add),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PlatformTextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(translations.cancel),
                  ),
                  if (inCart)
                    PlatformTextButton(
                      onPressed: _remove,
                      child: Text(translations.delete),
                    ),
                  PlatformElevatedButton(
                    onPressed: _addUpdate,
                    child: Text(inCart
                        ? translations.update
                        : translations.add_to_cart),
                  ),
                ],
              ),
              if (isCupertino(context)) const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
