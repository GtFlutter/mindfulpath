import 'package:http/http.dart';
import 'package:meditation_app/data/api/api_client.dart';
import 'package:meditation_app/util/app_config.dart';
import 'package:meditation_app/util/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  DashboardRepo(this.apiClient, this.sharedPreferences);

  Future<Response> getCategories() async {
    return await apiClient.getData(AppConfigs.getCategoryList);
  }

  Future<Response> getVideoList(int id, {int page = 1}) async {
    return await apiClient.getData('${AppConfigs.getVideoList}/$id?perPage=${AppConstants.kPerPage}&page=$page');
  }

  Future<Response> getFeatureVideoList({int page = 1}) async {
    return await apiClient.getData('${AppConfigs.getFeatureVideoList}?perPage=${AppConstants.kPerPage}&page=$page');
  }
}