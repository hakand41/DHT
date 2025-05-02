/*
lib/data/models/goals/goal_model.dart
*/
class Goal {
  final int id;
  final String title;
  final String description;
  final String period;
  final String importance;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Goal({
    required this.id,
    required this.title,
    required this.description,
    required this.period,
    required this.importance,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Goal.fromJson(Map<String, dynamic> json) => Goal(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    period: json['period'],
    importance: json['importance'],
    isActive: json['isActive'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'period': period,
    'importance': importance,
    'isActive': isActive,
  };
}