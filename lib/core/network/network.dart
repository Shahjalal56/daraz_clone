import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../app/config/app_config.dart';
import '../services/storage/token_storage.dart';

class Network {
  static final Network _instance = Network._internal();
  factory Network() => _instance;
  late Dio dio;

  Network._internal() {
    final options = BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    dio = Dio(options);

    // Token injection interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenStorage().getToken();
          debugPrint('Injected Token: $token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) {
          debugPrint('Dio Error: ${error.message}');
          return handler.next(error);
        },
      ),
    );

    // Debug logging
    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }
}
