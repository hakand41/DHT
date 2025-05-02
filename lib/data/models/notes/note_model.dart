// lib/data/models/notes/note_model.dart

class Note {
  final int id;
  final int userId;
  final String description;
  final String? imagePath;
  final DateTime createdAt;

  Note({
    required this.id,
    required this.userId,
    required this.description,
    this.imagePath,
    required this.createdAt,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as int,
      userId: json['userId'] as int,
      // Eğer backend description alanını null dönerse boş string kullan
      description: (json['description'] as String?) ?? '',
      // imagePath null olabiliyor
      imagePath: json['imagePath'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // Backend bu iki alanı bekliyor
      'description': description,
      'imagePath': imagePath,
    };
  }
}
