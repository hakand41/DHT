// lib/data/models/auth/user_model.dart

class UserModel {
  final int id;
  final String email;
  final String fullName;
  final DateTime birthDate;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.birthDate,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    email: json['email'],
    fullName: json['fullName'],
    birthDate: DateTime.parse(json['birthDate']),
  );

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'birthDate': birthDate.toIso8601String().split('T').first,
  };
}
