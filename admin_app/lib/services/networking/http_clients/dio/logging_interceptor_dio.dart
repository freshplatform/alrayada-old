import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

class DioLoggingInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    printInformation(
        'RequestData: url = ${options.uri.toString()}, body = ${options.data}\n headers = ${options.headers}\n');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    printSuccess(
      'ResponseData: code = ${response.statusCode}, body = ${response.data}\n',
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    printError(
      'ResponseErrorData: url = ${err.requestOptions.uri}, code = ${err.response?.statusCode}, errorMessage = ${err.message}, body = ${err.response?.data} \n'
      'DioException = $err',
    );
    super.onError(err, handler);
  }

  void printInformation(String text) {
    if (kDebugMode) {
      print('❔❕: $text \n');
    }
  }

  void printSuccess(String text) {
    if (kDebugMode) {
      print('✅: $text');
    }
  }

  void printError(String text) {
    if (kDebugMode) {
      print('‼️️: $text');
    }
  }
}
