import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/health_record_service.dart';
import '../../../data/models/health_records/health_record_model.dart';

final healthRecordServiceProvider = Provider((ref) => HealthRecordService());

final healthRecordsProvider = FutureProvider<List<HealthRecord>>(
      (ref) => ref.read(healthRecordServiceProvider).fetchMyRecords(),
);
