import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(baseUrl: "http://<API_URL>/api/auth"));

  Future<String?> login(String email, String password) async {
    try {
      final response = await _dio.post("/login", data: {
        "email": email,
        "passwordHash": password,
      });
      return response.data["token"];
    } catch (e) {
      print("Login error: $e");
      return null;
    }
  }

  Future<bool> register(Map<String, dynamic> user) async {
    try {
      final response = await _dio.post("/register", data: user);
      return response.statusCode == 200;
    } catch (e) {
      print("Register error: $e");
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    try {
      final response = await _dio.post("/forgot-password", data: {"email": email});
      return response.statusCode == 200;
    } catch (e) {
      print("Forgot password error: $e");
      return false;
    }
  }

  Future<bool> resetPassword(String email, String newPassword, String token) async {
    try {
      final response = await _dio.post("/reset-password", data: {
        "email": email,
        "newPassword": newPassword,
        "token": token,
      });
      return response.statusCode == 200;
    } catch (e) {
      print("Reset password error: $e");
      return false;
    }
  }
}
