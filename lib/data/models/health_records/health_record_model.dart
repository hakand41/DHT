// lib/data/models/health_records/health_record_model.dart

class HealthRecord {
  final int id;
  final int userId;
  final int goalId;
  final DateTime recordDate;
  final String recordTime;    // JSON null → '' olarak işlenecek
  final int duration;         // JSON null → 0
  final bool isCompleted;     // JSON null → false
  final DateTime createdAt;   // JSON null → recordDate olarak işlenecek

  HealthRecord({
    required this.id,
    required this.userId,
    required this.goalId,
    required this.recordDate,
    required this.recordTime,
    required this.duration,
    required this.isCompleted,
    required this.createdAt,
  });

  factory HealthRecord.fromJson(Map<String, dynamic> json) {
    // JSON’dan gelen tarih stringleri
    final recordDateStr = json['recordDate'] as String? ?? '';
    final createdAtStr  = json['createdAt']  as String? ?? recordDateStr;

    return HealthRecord(
      id:           json['id']           as int,
      userId:       json['userId']       as int,
      goalId:       json['goalId']       as int,
      recordDate:   recordDateStr.isNotEmpty
          ? DateTime.parse(recordDateStr)
          : DateTime.now(),
      createdAt:    createdAtStr.isNotEmpty
          ? DateTime.parse(createdAtStr)
          : DateTime.now(),
      recordTime:   (json['recordTime']   as String?) ?? '',
      duration:     (json['duration']     as int?)    ?? 0,
      isCompleted:  (json['isCompleted']  as bool?)   ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'goalId':      goalId,
    'recordDate':  recordDate.toIso8601String().split('T').first,
    'recordTime':  recordTime,
    'duration':    duration,
    'isCompleted': isCompleted,
  };
}
