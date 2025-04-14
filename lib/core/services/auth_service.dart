import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:5288/api/auth"));
  String? lastErrorMessage;

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

  Future<bool> register(Map<String, dynamic> userData) async {
    try {
      print("API'ye gönderilen veri: $userData");

      final response = await _dio.post('/register', data: userData);
      print("API yanıtı: ${response.data}");
      return true;
    } catch (e) {
      print("Kayıt hatası: $e");
      if (e is DioException && e.response != null) {
        print("Hata yanıt kodu: ${e.response!.statusCode}");
        print("Hata yanıt verisi: ${e.response!.data}");
        lastErrorMessage = e.response!.data.toString();
      } else {
        lastErrorMessage = e.toString();
      }
      return false;
    }
  }

  Future<bool> forgotPassword(String email, String newPassword) async {
    try {
      final response = await _dio.post("/forgot-password", data: {
        "email": email,
        "newPassword": newPassword,
      });
      return response.statusCode == 200;
    } catch (e) {
      print("Forgot password error: $e");
      if (e is DioException && e.response != null) {
        lastErrorMessage = e.response!.data.toString();
      } else {
        lastErrorMessage = e.toString();
      }
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
