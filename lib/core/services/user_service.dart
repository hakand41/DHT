import 'base_service.dart';
import '../../data/models/auth/user_model.dart';

/// API base: http://10.0.2.2:5288/api/users
class UserService extends BaseService {
  UserService() : super('http://10.0.2.2:5288/api/users');

  /// GET  /api/users/profile
  Future<UserModel> getProfile() async {
    final resp = await dio.get('/profile');
    return UserModel.fromJson(resp.data);
  }

  /// PUT  /api/users/update-profile
  Future<UserModel> updateProfile(UserModel user) async {
    final resp = await dio.put(
      '/update-profile',
      data: user.toJson(),
    );
    return UserModel.fromJson(resp.data);
  }

  /// PUT  /api/users/update-password
  Future<void> updatePassword(String oldPassword, String newPassword) async {
    await dio.put(
      '/update-password',
      data: {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      },
    );
  }
}
