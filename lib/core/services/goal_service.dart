// lib/core/services/goal_service.dart

import 'base_service.dart';
import '../../data/models/goals/goal_model.dart';

class GoalService extends BaseService {
  GoalService() : super('http://10.0.2.2:5288/api/goals');

  Future<List<Goal>> fetchMyGoals() async {
    final resp = await dio.get('/my-goals');
    return (resp.data as List)
        .map((j) => Goal.fromJson(j))
        .toList();
  }

  Future<Goal> addGoal(Goal g) async {
    final resp = await dio.post('/add', data: g.toJson());
    return Goal.fromJson(resp.data);
  }

  /// PUT  /api/goals/update/{id}
  Future<Goal> updateGoal(int id, Goal g) async {
    final resp = await dio.put('/update/$id', data: g.toJson());
    return Goal.fromJson(resp.data);
  }


  Future<bool> deleteGoal(int id, {bool force = false}) async {
    final resp = await dio.delete(
      '/delete/$id',
      // force her ne olursa olsun bu sorgu parametresini gönderiyoruz
      queryParameters: {'forceDelete': force},
    );
    return resp.statusCode == 200;
  }

}
