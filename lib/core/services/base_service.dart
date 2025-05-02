// lib/core/services/base_service.dart

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BaseService {
  late final Dio dio;
  final _storage = const FlutterSecureStorage();

  BaseService(String baseUrl) {
    dio = Dio(BaseOptions(baseUrl: baseUrl))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            final token = await _storage.read(key: 'jwt_token');
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
            // Konsola tam URL’i yazdır
            print('➡️ ${options.method} ${options.uri}');
            handler.next(options);
          },
        ),
      );
  }
}
