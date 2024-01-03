import 'package:http/http.dart';
import 'package:meditation_app/data/api/api_client.dart';
import 'package:meditation_app/util/app_config.dart';
import 'package:meditation_app/util/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  CourseRepo(this.apiClient, this.sharedPreferences);
  
  Future<Response> getPurchasedList({int page = 1}) async {
    return await apiClient.getData('${AppConfigs.getPurchaseList}?perPage=${AppConstants.kPerPage}&page=$page');
  }

  Future<Response> getCurrentlyProgressList({int page = 1}) async {
    return await apiClient.getData('${AppConfigs.getCurrentlyProgressList}?perPage=${AppConstants.kPerPage}&page=$page');
  }
}