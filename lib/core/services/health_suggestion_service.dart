// lib/core/services/health_suggestion_service.dart

import 'base_service.dart';
import '../../data/models/health_suggestions/health_suggestion_model.dart';

class HealthSuggestionService extends BaseService {
  HealthSuggestionService()
      : super('http://10.0.2.2:5288/api/health-suggestions');

  Future<HealthSuggestion> fetchRandomSuggestion() async {
    final resp = await dio.get('/random');
    return HealthSuggestion.fromJson(resp.data);
  }

  Future<HealthSuggestion> addSuggestion(HealthSuggestion s) async {
    final resp = await dio.post('/add', data: s.toJson());
    return HealthSuggestion.fromJson(resp.data);
  }
}
