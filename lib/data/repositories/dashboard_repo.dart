import 'package:http/http.dart';
import 'package:meditation_app/data/api/api_client.dart';
import 'package:meditation_app/data/model/body/resource_type.dart';
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

  Future<Response> getVideos({
    required int categoryId,
    required int offset,
    required ResourceType resourceType,
  }) async {
    return await apiClient.postData(AppConfigs.getVideos, _toBody(categoryId, resourceType, offset));
  }

  Future<Response> getPdfs({
    required int categoryId,
    required int offset,
    required ResourceType resourceType,
  }) async {
    return await apiClient.postData(AppConfigs.getPdfs, _toBody(categoryId, resourceType, offset));
  }

  Map<String, int> _toBody(int categoryId, ResourceType resourceType, int offset) => {
        'category_id': categoryId,
        'type': resourceType.toInt(),
        'page': offset,
        'perPage': AppConstants.kPerPage * 10,
      };

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
