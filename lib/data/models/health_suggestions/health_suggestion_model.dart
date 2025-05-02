/// lib/data/models/health_suggestions/health_suggestion_model.dart
class HealthSuggestion {
  final int id;
  final String content;
  final bool isActive;
  final DateTime createdAt;

  HealthSuggestion({
    required this.id,
    required this.content,
    required this.isActive,
    required this.createdAt,
  });

  factory HealthSuggestion.fromJson(Map<String, dynamic> json) => HealthSuggestion(
    id: json['id'],
    content: json['content'],
    isActive: json['isActive'],
    createdAt: DateTime.parse(json['createdAt']),
  );

  Map<String, dynamic> toJson() => {
    'content': content,
    'isActive': isActive,
  };
}
