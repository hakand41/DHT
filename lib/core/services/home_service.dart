// lib/core/services/home_service.dart

import 'base_service.dart';
import '../../data/models/home/home_data_model.dart';

class HomeService extends BaseService {
  HomeService() : super('http://10.0.2.2:5288/api/home');

  Future<HomeData> fetchHomeData() async {
    final resp = await dio.get('/');
    return HomeData.fromJson(resp.data);
  }
}
