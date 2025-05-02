// lib/data/models/home/home_data_model.dart

import '../health_records/health_record_model.dart';
import '../health_suggestions/health_suggestion_model.dart';

class HomeData {
  final List<HealthRecord> recentHealthRecords;
  final HealthSuggestion randomSuggestion;

  HomeData({
    required this.recentHealthRecords,
    required this.randomSuggestion,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
    recentHealthRecords: (json['recentHealthRecords'] as List)
        .map((e) => HealthRecord.fromJson(e))
        .toList(),
    randomSuggestion:
    HealthSuggestion.fromJson(json['randomSuggestion']),
  );
}
