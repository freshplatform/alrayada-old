import 'package:alrayada/utils/constants/routes.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/data/cart/m_cart.dart';
import 'package:shared_alrayada/data/product/m_product.dart';

import '/data/cart/s_cart.dart';
import '/services/networking/http_clients/dio/s_dio.dart';

@immutable
class CartItemData {
  final Product product;
  final Cart cart;

  const CartItemData({
    required this.cart,
    required this.product,
  });
}

class CartNotifier extends StateNotifier<List<CartItemData>> {
  CartNotifier() : super([]);

  static final cartProvider =
      StateNotifierProvider<CartNotifier, List<CartItemData>>(
          (ref) => CartNotifier());

  final _dio = DioService.getDio();

  Future<void> loadAllCartItems() async {
    try {
      final List<CartItemData> modified = [];
      final cartItems = await CartService.getItems();
      if (cartItems.isEmpty) {
        return;
      }
      final response = await _dio.get<List<dynamic>>(
        RoutesConstants.productsRoutes.getProducts,
        // queryParameters: {
        //   'ids': cartItems.map((e) => e.productId).join(","),
        // },
        data: cartItems.map((e) => e.productId).toList(),
      );

      final products =
          response.data?.map((e) => Product.fromJson(e)).toList() ?? [];
      products.asMap().forEach(
            (index, value) async => modified.add(
              CartItemData(cart: cartItems[index], product: value),
            ),
          );
      // remove items that are no longer available in the database
      for (var (cartItem) in cartItems) {
        try {
          modified.firstWhere(
            (element) => cartItem.productId == element.cart.productId,
          );
        } on StateError {
          cartItems.remove(cartItem);
          await CartService.removeFromCart(cartItem.productId);
        }
      }
      state = [...modified];
    } on DioException {
      rethrow;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addToCart(Cart cart, Product product) async {
    await CartService.addToCart(cart);
    state = [...state, CartItemData(cart: cart, product: product)];
  }

  Future<void> updateCartItem(Cart cart, Product product) async {
    final index = state.indexWhere(
      (e) => e.cart.productId == cart.productId,
    ); // TODO("There is a bug here where -1 returned")
    if (index == -1) return;
    final modified = [...state]..removeAt(index);
    await CartService.updateCartItem(cart);
    modified.add(CartItemData(cart: cart, product: product));
    state = [...modified];
  }

  Future<void> removeFromCart(CartItemData cartItemData) async {
    await CartService.removeFromCart(cartItemData.cart.productId);
    final index = state
        .indexWhere((e) => e.cart.productId == cartItemData.cart.productId);
    final modified = [...state];
    modified.removeAt(index);
    state = [...modified];
  }

  Future<void> clearCart() async {
    await CartService.clearCart();
    state = [];
  }

  Future<Cart?> getCartItem(String productId) async {
    return await CartService.getCartItem(productId);
  }
}
