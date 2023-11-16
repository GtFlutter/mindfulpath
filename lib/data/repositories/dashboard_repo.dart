import 'package:http/http.dart';
import 'package:meditation_app/data/api/api_client.dart';
import 'package:meditation_app/util/app_config.dart';
import 'package:meditation_app/util/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  DashboardRepo(this.apiClient, this.sharedPreferences);

  Future<Response> getCategories(int offset) async {
    return await apiClient.getData('${AppConfigs.getCategoryList}?page=$offset&perPage=25');
  }

  Future<Response> getVideoList(int categoryId, {int offset = 1}) async {
    return await apiClient.postData(
      AppConfigs.getVideoList,
      {
        'perPage': AppConstants.kPerPage,
        'page': offset,
        'category_id': categoryId,
        'type': 0,
      },
    );
  }

  Future<Response> storeVideoWatchedTime(int videoId, Duration duration) async {
    return await apiClient.postData(
      AppConfigs.storeWatchedVideoDuration,
      {'video_id': videoId, 'duration': duration.inSeconds},
    );
  }

  Future<Response> getFeatureVideoList(int offset) async {
    return await apiClient.getData('${AppConfigs.getFeatureVideoList}?perPage=${AppConstants.kPerPage}&page=$offset');
  }
}
