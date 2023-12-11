import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/data/product/category/m_product_category.dart';
import 'package:shared_alrayada/utils/constants/routes.dart';

import '../services/networking/http_clients/dio/dio.dart';

class CategoryItemNotifier extends StateNotifier<ProductCategory> {
  CategoryItemNotifier(super.state);

  static final provider = StateNotifierProvider.family<CategoryItemNotifier,
      ProductCategory, ProductCategory>((ref, category) {
    return CategoryItemNotifier(category);
  });

  final _dio = DioService.getDio();

  Future<String?> updateSubCategory({
    String? newFilePath,
    required ProductCategoryRequest productCategoryRequest,
  }) async {
    try {
      final Map<String, dynamic> formDataMap = {
        'json': jsonEncode(productCategoryRequest.toJson()),
      };
      if (newFilePath != null) {
        formDataMap['file'] = await MultipartFile.fromFile(newFilePath);
      }
      final response = await _dio.put(
        RoutesConstants.productsCategoryRoutes.updateCategory(state.id),
        options: Options(contentType: Headers.multipartFormDataContentType),
        data: FormData.fromMap(formDataMap),
      );
      if (response.data != null) {
        final newProductcategory =
            ProductCategory.fromJson(jsonDecode(response.data));
        state = state.copyWith(
          name: newProductcategory.name,
          description: newProductcategory.description,
          shortDescription: newProductcategory.shortDescription,
          imageUrls: newProductcategory.imageUrls,
        );
      }
      return null;
    } on DioException catch (e) {
      return 'Error: ${e.response?.data}, ${e.message}';
    }
  }

  Future<String?> addSubCategory({
    String? filePath,
    required ProductCategoryRequest productCategoryRequest,
    required WidgetRef ref,
  }) async {
    if (productCategoryRequest.parent == null) {
      throw 'The parent of the request can not be null since this sub category';
    }
    try {
      final Map<String, dynamic> formDataMap = {
        'json': jsonEncode(productCategoryRequest.toJson()),
      };
      if (filePath != null) {
        formDataMap['file'] = await MultipartFile.fromFile(filePath);
      }
      final response = await _dio.post(
        RoutesConstants.productsCategoryRoutes.addCategory,
        options: Options(contentType: Headers.multipartFormDataContentType),
        data: FormData.fromMap(formDataMap),
      );
      if (response.data == null) {
        return 'Body is null';
      }
      final productCategory =
          ProductCategory.fromJson(jsonDecode(response.data));
      state = state.copyWith(
        children: [...state.children!]..insert(0, productCategory),
      );
      return null;
    } on DioException catch (e) {
      return 'Error: ${e.response?.data}, ${e.message}';
    }
  }

  Future<String?> deleteSubCategory(
    int index,
  ) async {
    try {
      final subCategory = state.children![index];
      await _dio.delete(
        RoutesConstants.productsCategoryRoutes.deleteCategory(subCategory.id),
      );
      state = state.copyWith(
        children: [...state.children!]..removeAt(index),
      );
      return null;
    } on DioException catch (e) {
      return 'Error: ${e.response?.data}, ${e.message}';
    }
  }
}

class CategoriesNotififer extends StateNotifier<List<ProductCategory>> {
  CategoriesNotififer() : super([]);

  static final provider =
      StateNotifierProvider<CategoriesNotififer, List<ProductCategory>>(
    (ref) => CategoriesNotififer(),
  );

  final _dio = DioService.getDio();

  Future<void> fetchProductCategories() async {
    try {
      final response = await _dio.get<List<dynamic>>(
          RoutesConstants.productsCategoryRoutes.getCategories);
      final categories =
          response.data?.map((e) => ProductCategory.fromJson(e)).toList() ?? [];
      state = [...categories];
    } on DioException {
      rethrow;
    }
  }

  Future<String?> deleteParentCategory(ProductCategory category) async {
    try {
      final index = state.indexWhere(
        (element) => element.id == category.id,
      );
      await _dio.delete(
        RoutesConstants.productsCategoryRoutes.deleteCategory(
          state[index].id,
        ),
      );
      state = [...state]..removeAt(index);
      return null;
    } on DioException catch (e) {
      return 'Error: ${e.response?.data}, ${e.message}';
    }
  }

  Future<String?> addCategory({
    String? filePath,
    required ProductCategoryRequest productCategoryRequest,
  }) async {
    if (productCategoryRequest.parent != null) {
      throw 'The parent of the request can not be not null since this parent category';
    }
    try {
      final Map<String, dynamic> formDataMap = {
        'json': jsonEncode(productCategoryRequest.toJson()),
      };
      if (filePath != null) {
        formDataMap['file'] = await MultipartFile.fromFile(filePath);
      }
      final response = await _dio.post(
        RoutesConstants.productsCategoryRoutes.addCategory,
        options: Options(contentType: Headers.multipartFormDataContentType),
        data: FormData.fromMap(formDataMap),
      );
      if (response.data == null) {
        return 'Body is null';
      }
      final productCategory =
          ProductCategory.fromJson(jsonDecode(response.data));
      final modifier = [...state];
      modifier.insert(0, productCategory);
      state = [...modifier];
      return null;
    } on DioException catch (e) {
      return 'Error: ${e.response?.data}, ${e.message}';
    }
  }
}
