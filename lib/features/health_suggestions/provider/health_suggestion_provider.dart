/// lib/features/health_suggestions/provider/health_suggestion_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/health_suggestion_service.dart';
import '../../../data/models/health_suggestions/health_suggestion_model.dart';

final healthSuggestionServiceProvider = Provider((ref) => HealthSuggestionService());

final randomSuggestionProvider = FutureProvider<HealthSuggestion>(
      (ref) => ref.read(healthSuggestionServiceProvider).fetchRandomSuggestion(),
);
