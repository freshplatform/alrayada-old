import 'package:alrayada/utils/constants/routes.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/data/favorite/m_favorite.dart';
import 'package:shared_alrayada/data/product/m_product.dart';
import '/data/favorite/s_favorite.dart';
import '/services/networking/http_clients/dio/s_dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductItemNotifier extends StateNotifier<Product> {
  ProductItemNotifier(Product product) : super(product);

  // TODO: Test
  static final productItemProvider = StateNotifierProvider.autoDispose
      .family<ProductItemNotifier, Product, Product>((ref, product) {
    return ProductItemNotifier(product);
  });

  Future<void> toggleFavoriteItem() async {
    final product = state;
    if (product.isFavorite) {
      await FavoriteService.removeFromFavorites(product.id);
      state = product.copyWith(isFavorite: false);
      return;
    }

    await FavoriteService.addToFavorites(
      Favorite(
        productId: product.id,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ),
    );
    state = state.copyWith(isFavorite: true);
  }
}

@immutable
class ProductsNotifierState {
  final bool showOnlyFavoritesProducts;

  const ProductsNotifierState({this.showOnlyFavoritesProducts = false});
}

class ProductsNotifier extends StateNotifier<ProductsNotifierState> {
  ProductsNotifier() : super(const ProductsNotifierState()) {
    _loadSavedData();
  }

  final _dio = DioService.getDio();

  static const showOnlyFavoritesProductsKey = "shouldShowOnlyFavoritesProducts";

  static final productsProvider =
      StateNotifierProvider<ProductsNotifier, ProductsNotifierState>(
    (ref) => ProductsNotifier(),
  );

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
      showOnlyFavoritesProductsKey,
      state.showOnlyFavoritesProducts,
    );
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    state = ProductsNotifierState(
        showOnlyFavoritesProducts:
            prefs.getBool(showOnlyFavoritesProductsKey) ?? false);
  }

  void toggleShowOnlyFavorites() {
    state = ProductsNotifierState(
        showOnlyFavoritesProducts: !state.showOnlyFavoritesProducts);
    _saveData();
  }

  Future<List<Product>> getNewestProducts() async {
    try {
      final favorites = await FavoriteService.getFavorites();
      final response = await _dio
          .get<List<dynamic>>(RoutesConstants.productsRoutes.getProducts);
      final products = Product.toMappedProducts(
        dynamicList: response.data ?? [],
        favorites: favorites,
      );
      return products;
    } on DioException {
      return [];
    }
  }

  Future<List<Product>> getProductsByCategory(String id) async {
    try {
      final favorites = await FavoriteService.getFavorites();
      final response = await _dio.get<List<dynamic>>(
          '${RoutesConstants.productsRoutes.getProducts}byCategory/$id');
      final products = Product.toMappedProducts(
        dynamicList: response.data ?? [],
        favorites: favorites,
      );
      return products;
    } on DioException {
      rethrow;
    }
  }

  Future<Product?> getProductById(String id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
          RoutesConstants.productsRoutes.getProducts + id);
      if (response.data == null) return null;
      var product = Product.fromJson(response.data!);
      product = product.copyWith(
          isFavorite: await FavoriteService.isFavorite(product.id));
      return product;
    } on DioException {
      return null;
    }
  }

  Future<List<Product>> getBestSelling() async {
    try {
      final favorites = await FavoriteService.getFavorites();
      final response = await _dio.get<List<dynamic>>(
          '${RoutesConstants.productsRoutes.getProducts}bestSelling');
      final products = Product.toMappedProducts(
        dynamicList: response.data ?? [],
        favorites: favorites,
      );
      return products;
    } on DioException {
      return [];
    }
  }
}
