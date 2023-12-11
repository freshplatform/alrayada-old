// import 'package:dio/dio.dart';
// import '/providers/p_order.dart';
// import 'package:flutter/foundation.dart';
//
// import '../data/order/m_monthly_total.dart';
// import '../services/networking/http_clients/dio/s_dio.dart';
//
// class StatisticsProvider with ChangeNotifier {
//   final dio = DioService.getDio();
//   Future<List<MonthlyTotal>> getStatistics() async {
//     try {
//       final response = await dio.get<List<dynamic>>('${OrderProvider.route}statistics');
//       final result =
//           response.data?.map((e) => MonthlyTotal.fromJson(e)).toList() ?? [];
//       return result;
//     } on DioError {
//       rethrow;
//     }
//   }
// }
