import 'package:alrayada/utils/constants/routes.dart';
import 'package:dio/dio.dart' show DioException;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/data/product/m_product.dart';

import '../data/favorite/s_favorite.dart';
import '../services/networking/http_clients/dio/s_dio.dart';

class FavoritesNotifier extends StateNotifier<List<Product>> {
  FavoritesNotifier(List<Product> products) : super(products);

  static final favoritesProvider =
      StateNotifierProvider<FavoritesNotifier, List<Product>>(
    (ref) => FavoritesNotifier([]),
  );

  final _dio = DioService.getDio();

  Future<void> loadAllFavoritesProducts() async {
    try {
      final favorites = await FavoriteService.getFavorites();
      if (favorites.isEmpty) {
        state = []; // make sure the last is actually empty if not
        return;
      }

      final response = await _dio.get<List<dynamic>>(
        RoutesConstants.productsRoutes.getProducts,
        data: favorites.map((e) => e.productId).toList(),
      );
      final products = Product.toMappedProducts(
        dynamicList: response.data ?? [],
        favorites: favorites,
      );
      state = [...products];
    } on DioException {
      rethrow;
    }
  }
}
