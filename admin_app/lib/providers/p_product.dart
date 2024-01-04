import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/data/product/m_product.dart';
import 'package:shared_alrayada/services/networking/dio/dio.dart';
import 'package:shared_alrayada/utils/constants/routes.dart';

class ProductItemNotifier extends StateNotifier<Product> {
  ProductItemNotifier(super.product);

  static final provider = StateNotifierProvider.autoDispose
      .family<ProductItemNotifier, Product, Product>((ref, product) {
    return ProductItemNotifier(product);
  });

  Future<String?> updateProduct({
    required ProductRequest productRequest,
    required String productId,
    String? newFilePath,
  }) async {
    try {
      final Map<String, dynamic> map = {
        'json': jsonEncode(productRequest.toJson()),
      };
      if (newFilePath != null) {
        map['file'] = await MultipartFile.fromFile(newFilePath);
      }
      final formData = FormData.fromMap(map);
      final response = await DioService.getDio().put(
        RoutesConstants.productsRoutes.updateProduct(productId),
        data: formData,
        options: Options(contentType: Headers.multipartFormDataContentType),
      );
      if (response.data == null) {
        return 'Body is null';
      }
      final newProduct = Product.fromJson(jsonDecode(response.data));
      state = state.copyWith(
          name: newProduct.name,
          description: newProduct.description,
          shortDescription: newProduct.shortDescription,
          originalPrice: newProduct.originalPrice,
          discountPercentage: newProduct.discountPercentage,
          imageUrls: newProduct.imageUrls);
      return null;
    } on DioException catch (e) {
      return 'Error: ${e.response?.data}, ${e.message}';
    }
  }
}

class ProductsNotifier extends StateNotifier<List<Product>> {
  ProductsNotifier() : super([]);

  static final provider =
      StateNotifierProvider<ProductsNotifier, List<Product>>(
    (ref) => ProductsNotifier(),
  );

  final _dio = DioService.getDio();

  // List<Product> get products => [...state];

  Future<void> getProductsByCategory(String id) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        RoutesConstants.productsRoutes.getProductsByCategory(id),
      );
      final products = response.data?.map((e) {
            final product = Product.fromJson(e);
            return product;
          }).toList() ??
          [];
      if (products.isNotEmpty) {
        state = [...products];
      }
    } on DioException {
      rethrow;
    }
  }

  Future<String?> deleteProduct(String productId, int index) async {
    try {
      await _dio.delete(
        RoutesConstants.productsRoutes.deleteProduct(productId),
      );
      final modifier = [...state];
      modifier.removeAt(index);
      state = [...modifier];
      return null;
    } on DioException catch (e) {
      return 'Error: ${e.response?.data}, ${e.message}';
    }
  }

  Future<String?> addProduct({
    required ProductRequest productRequest,
    String? filePath,
  }) async {
    try {
      final Map<String, dynamic> map = {
        'json': jsonEncode(productRequest.toJson()),
      };
      if (filePath != null) {
        map['file'] = await MultipartFile.fromFile(filePath);
      }
      final response = await _dio.post(
        RoutesConstants.productsRoutes.addProduct,
        data: FormData.fromMap(map),
        options: Options(contentType: Headers.multipartFormDataContentType),
      );
      if (response.data == null) {
        return 'Body is null';
      }
      final product = Product.fromJson(jsonDecode(response.data));
      final modifier = [...state];
      modifier.insert(0, product);
      state = [...modifier];
      return null;
    } on DioException catch (e) {
      return 'Error: ${e.response?.data}, ${e.message}';
    }
  }
}
