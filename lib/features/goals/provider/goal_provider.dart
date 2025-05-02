// lib/features/goals/provider/goal_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/goal_service.dart';
import '../../../data/models/goals/goal_model.dart';

final goalServiceProvider = Provider((ref) => GoalService());

/// Kullanıcının hedeflerini çeker
final goalsListProvider = FutureProvider<List<Goal>>(
      (ref) => ref.read(goalServiceProvider).fetchMyGoals(),
);