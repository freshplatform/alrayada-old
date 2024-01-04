import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_alrayada/data/offer/m_offer.dart';

import '../utils/constants/routes.dart';
import '/services/networking/http_clients/dio/s_dio.dart';

class OffersNotififer extends StateNotifier<List<Offer>> {
  OffersNotififer() : super([]);

  static final offersProvider =
      StateNotifierProvider<OffersNotififer, List<Offer>>(
    (ref) => OffersNotififer(),
  );

  final _dio = DioService.getDio();

  Future<void> loadOffers() async {
    try {
      state.clear();
      final response =
          await _dio.get<List<dynamic>>(RoutesConstants.offersRoutes.getOffers);
      final offers =
          response.data?.map((e) => Offer.fromJson(e)).toList() ?? [];
      state.addAll(offers);
    } catch (e) {
      return;
    }
  }
}
