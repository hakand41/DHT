// lib/core/services/health_record_service.dart

import 'base_service.dart';
import '../../data/models/health_records/health_record_model.dart';

class HealthRecordService extends BaseService {
  HealthRecordService() : super('http://10.0.2.2:5288/api/healthrecords');

  Future<List<HealthRecord>> fetchMyRecords() async {
    final resp = await dio.get('/my-records');
    return (resp.data as List)
        .map((j) => HealthRecord.fromJson(j))
        .toList();
  }

  Future<HealthRecord> addRecord(HealthRecord r) async {
    final resp = await dio.post('/add', data: r.toJson());
    return HealthRecord.fromJson(resp.data);
  }
}
