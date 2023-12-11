import 'dart:convert' show jsonDecode;
import 'dart:io' show HttpStatus;

import 'package:dio/dio.dart'
    show
        Dio,
        DioException,
        Headers,
        Interceptor,
        InterceptorsWrapper,
        ResponseType;
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/widgets.dart' show VoidCallback;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_alrayada/server/server.dart';

import '../../../../utils/platform_checker.dart';
import '../../native/connectivity_checker/s_connectivity_checker.dart';

class DioService {
  static Dio? _dio;
  static Interceptor? _authInterceptor;

  DioService._privateConstructor();

  static Dio getDio() {
    _dio ??= _createDio();
    return _dio ?? _createDio();
  }

  static void addAuthorizationHeader(
      String value, VoidCallback onShouldLogout) {
    if (_dio == null) {
      getDio();
    }
    if (_dio == null) {
      if (kDebugMode) {
        print('Dio is still null after calling getDio()');
      }
      return;
    }
    _dio!.interceptors.remove(_authInterceptor);
    _authInterceptor = InterceptorsWrapper(onRequest: (options, handler) {
      if (options.uri.host ==
          Uri.parse(ServerConfigurations.getBaseUrl()).host) {
        options.headers.addAll({'Authorization': value});
      }
      handler.next(options);
    }, onError: (options, handler) {
      if (options.requestOptions.uri.host ==
          Uri.parse(ServerConfigurations.getBaseUrl()).host) {
        final msg = options.response!.data.toString();
        if (options.response?.statusCode == 401 ||
            msg.contains('You must be authenticated to continue.') ||
            msg.contains("You don't have access to this route!")) {
          onShouldLogout();
        }
      }
      handler.next(options);
    });
    _dio!.interceptors.add(_authInterceptor!);
  }

  static void removeAuthorizationHeader() {
    if (_dio == null) {
      getDio();
    }
    if (_dio == null) {
      if (kDebugMode) {
        print('Dio is still null after calling getDio()');
      }
      return;
    }
    if (_authInterceptor == null) {
      if (kDebugMode) {
        print(
          'Could not remove authorization header, because _authInterceptor is null',
        );
        return;
      }
      return;
    }
    _dio!.interceptors.remove(_authInterceptor);
    _authInterceptor = null;
  }

  static void removeLastHeader() {
    if (_dio == null) {
      getDio();
    }
    _dio!.interceptors.removeLast();
  }

  /// Create dio for the first time
  static Dio _createDio() {
    Dio dio = Dio();
    dio.options.contentType = Headers.jsonContentType;
    dio.options.responseType =
        ResponseType.plain; // json will always make the return type of string
    dio.interceptors.add(
      InterceptorsWrapper(onRequest: (options, handler) async {
        // Add 'Api' on each request
        if (options.uri.host ==
            Uri.parse(ServerConfigurations.getBaseUrl()).host) {
          options.headers['Api'] = ServerConfigurations.serverApiKey;
        }
        // Throw connection error if there is no connection to internet
        if (PlatformChecker.isMobileDevice()) {
          final connectivityResult =
              await ConnectivityCheckerService.instance.checkConnectivity();
          if (connectivityResult == ConnectivityCheckerResult.none) {
            handler.reject(
              DioException.connectionError(
                requestOptions: options,
                reason: connectivityResult.name,
              ),
            );
            return;
          }
        }
        handler.next(options);
      }, onError: (options, handler) {
        if (kDebugMode) {
          if (options.response!.statusCode == 401) {
            print('Over here!!');
            print(options.requestOptions.path);
            print(options.requestOptions.uri);
          }
        }
        handler.next(options);
      }),
    );
    dio.interceptors.add(InterceptorsWrapper(
      onError: (options, handler) {
        if (options.response != null && options.response?.data != null) {
          try {
            options.response!.data = jsonDecode(options.response!.data);
          } on FormatException catch (e) {
            if (kDebugMode) {
              print('Invalid json: $e');
            }
          }
        }
        handler.next(options);
      },
    ));
    if (kDebugMode) {
      // dio.interceptors.add(DioLoggingInterceptor());
      dio.interceptors.add(PrettyDioLogger(
        requestBody: true,
        responseBody: true,
        // requestHeader: true,
        // responseHeader: true,
        maxWidth: 100,
        error: true,
        request: true,
        // logPrint: (object) => devtools.log(object.toString()),
      ));
    }
    // final cachingOptions = CacheOptions(
    //   store: MemCacheStore(),
    //   policy: CachePolicy.request,
    //   hitCacheOnErrorExcept: [401, 403],
    //   maxStale: const Duration(days: 7),
    //   priority: CachePriority.normal,
    //   cipher: null,
    //   keyBuilder: CacheOptions.defaultCacheKeyBuilder,
    //   allowPostMethod: false,
    // );
    // dio.interceptors.add(DioCacheInterceptor(options: cachingOptions));
    return dio;
  }

  static void handleServerLimitError(VoidCallback onLimitError) {
    _dio?.interceptors.add(InterceptorsWrapper(
      onError: (options, handler) {
        if (options.response?.statusCode == HttpStatus.tooManyRequests &&
            options.requestOptions.uri ==
                Uri.parse(ServerConfigurations.getBaseUrl())) {
          onLimitError();
        }
        handler.next(options);
      },
    ));
  }

  static void closeDio() => _dio?.close();
}
