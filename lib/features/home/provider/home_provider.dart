// lib/features/home/provider/home_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/home_service.dart';
import '../../../data/models/home/home_data_model.dart';

final homeServiceProvider = Provider((ref) => HomeService());

final homeDataProvider = FutureProvider<HomeData>(
      (ref) => ref.read(homeServiceProvider).fetchHomeData(),
);
