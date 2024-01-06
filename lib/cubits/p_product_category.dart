import 'dart:io' show SocketException;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/product/category/m_product_category.dart';
import '../utils/constants/routes.dart';
import '/services/networking/http_clients/dio/s_dio.dart';

class ProductCategoriesNotififer extends StateNotifier<List<ProductCategory>> {
  ProductCategoriesNotififer() : super([]);

  static final productCategoriesProvider =
      StateNotifierProvider<ProductCategoriesNotififer, List<ProductCategory>>(
    (ref) => ProductCategoriesNotififer(),
  );

  final _dio = DioService.getDio();

  Future<void> getProductCategories() async {
    try {
      final response = await _dio.get<List<dynamic>>(
        RoutesConstants.productsCategoryRoutes.getCategories,
      );
      final categories =
          response.data?.map((e) => ProductCategory.fromJson(e)).toList() ?? [];
      state = [...categories];
    } on DioException {
      rethrow;
    } on SocketException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
