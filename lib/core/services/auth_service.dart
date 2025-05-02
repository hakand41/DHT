// lib/core/services/auth_service.dart

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:5288/api/auth"));
  String? lastErrorMessage;
  final _storage = const FlutterSecureStorage();

  /// Login: sunucudan token al, sakla
  Future<String?> login(String email, String password) async {
    try {
      final resp = await _dio.post(
        '/login',
        data: {'email': email, 'passwordHash': password},
      );
      final token = resp.data['token'] as String?;
      if (token != null) {
        await _storage.write(key: 'jwt_token', value: token);
      }
      return token;
    } on DioError catch (e) {
      lastErrorMessage = e.response?.data?.toString() ?? e.message;
      return null;
    }
  }

  /// Register: yeni kullanıcı oluştur
  Future<bool> register(Map<String, dynamic> userData) async {
    try {
      final resp = await _dio.post('/register', data: userData);
      return resp.statusCode == 200;
    } on DioError catch (e) {
      lastErrorMessage = e.response?.data?.toString() ?? e.message;
      return false;
    }
  }

  /// Forgot password: email ve yeni şifreyle talepte bulun
  Future<bool> forgotPassword(String email, String newPassword) async {
    try {
      final resp = await _dio.post('/forgot-password', data: {
        'email': email,
        'newPassword': newPassword,
      });
      return resp.statusCode == 200;
    } on DioError catch (e) {
      lastErrorMessage = e.response?.data?.toString() ?? e.message;
      return false;
    }
  }

  /// Reset password (token ile):
  Future<bool> resetPassword(String email, String newPassword, String token) async {
    try {
      final resp = await _dio.post('/reset-password', data: {
        'email': email,
        'newPassword': newPassword,
        'token': token,
      });
      return resp.statusCode == 200;
    } on DioError catch (e) {
      lastErrorMessage = e.response?.data?.toString() ?? e.message;
      return false;
    }
  }

  /// Logout: server’a çıkış isteği, ardından yerel token’ı sil
  Future<void> logout() async {
    try {
      final token = await _storage.read(key: 'jwt_token');
      if (token != null) {
        await _dio.post(
          '/logout',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );
      }
    } catch (_) {
      // Eğer server hatası olsa bile token silinsin
    } finally {
      await _storage.delete(key: 'jwt_token');
    }
  }

  /// Saklı token’ı oku
  Future<String?> getToken() => _storage.read(key: 'jwt_token');
}
