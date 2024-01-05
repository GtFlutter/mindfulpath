import 'package:http/http.dart';
import 'package:meditation_app/data/api/api_client.dart';
import 'package:meditation_app/data/model/body/resource_type.dart';
import 'package:meditation_app/util/app_config.dart';
import 'package:meditation_app/util/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ui/screens/search/util/query_time.dart';

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

  Future<Response> searchVideos(
    String queryText, {
    required QueryTime queryTime,
    required int offset,
    int? categoryId,
  }) async {
    ///   Time in min  start_time - end_time
    ///      <30m          0      - 1800
    ///      30m-45m       1800   - 2700
    ///      45m-60m       2700   - 3600
    ///         >60m       null   - 3600
    return await apiClient.postData(AppConfigs.searchVideos, {
      if (categoryId != null) 'category_id': categoryId,
      'searched_title': queryText,
      if (queryTime.startTimeInMinutes != null) 'start_time': queryTime.startTimeInMinutes! * 60,
      'end_time': queryTime.endTimeInMinutes * 60,
      'page': offset,
      'perPage': AppConstants.kPerPage * 5,
    });
  }

  Future<Response> purchaseCategory(String categoryId) async {
    return await apiClient.postData(AppConfigs.purchaseSubscription, {'category_id': categoryId});
  }
}
