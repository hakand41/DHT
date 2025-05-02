// lib/features/profile/provider/profile_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/user_service.dart';
import '../../../data/models/auth/user_model.dart';

final userServiceProvider = Provider((ref) => UserService());

final userProfileProvider = FutureProvider<UserModel>(
      (ref) => ref.read(userServiceProvider).getProfile(),
);
