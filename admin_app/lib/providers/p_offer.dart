import 'dart:convert';
import 'dart:developer' as developer show log;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/data/offer/m_offer.dart';
import 'package:shared_alrayada/services/networking/dio/dio.dart';
import 'package:shared_alrayada/utils/constants/routes.dart';

class OffersNotififer extends StateNotifier<List<Offer>> {
  OffersNotififer() : super([]);

  static final provider = StateNotifierProvider<OffersNotififer, List<Offer>>(
    (ref) => OffersNotififer(),
  );

  final _dio = DioService.getDio();

  // List<Offer> get offers => [...state];

  var isInitLoading = true;

  void reset() {
    isInitLoading = true;
    state = [];
  }

  Future<void> loadOffers() async {
    try {
      final response = await _dio.get<List<dynamic>>(
        RoutesConstants.offersRoutes.getOffers,
      );
      final offers = response.data?.map((e) => Offer.fromJson(e)) ?? [];
      state = [...state, ...offers];
    } on DioException {
      rethrow;
    }
  }

  Future<String?> addOffer(String filePath) async {
    try {
      developer.log(filePath);
      final response = await _dio.post(
        RoutesConstants.offersRoutes.addOffer,
        options: Options(contentType: Headers.multipartFormDataContentType),
        data: FormData.fromMap({
          'file': await MultipartFile.fromFile(filePath),
        }),
      );
      if (response.data == null) {
        return 'Error, The data body is null';
      }
      final offer = Offer.fromJson(jsonDecode(response.data));
      state = [...state, offer];
      return null;
    } on DioException catch (e) {
      return 'Error: ${e.response?.data}';
    } catch (e) {
      return 'Unexpected error: $e';
    }
  }

  Future<String?> deleteOffer(String id, int index) async {
    try {
      await _dio.delete(
        RoutesConstants.offersRoutes.deleteOffer(id),
      );
      state = [...state]..removeAt(index);
      return null;
    } on DioException catch (e) {
      return 'Error: ${e.response?.data}';
    } catch (e) {
      return 'Unexpected error: $e';
    }
  }
}
