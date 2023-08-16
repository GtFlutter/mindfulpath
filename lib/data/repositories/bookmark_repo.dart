import 'package:http/http.dart';
import 'package:meditation_app/data/api/api_client.dart';
import 'package:meditation_app/util/app_config.dart';
import 'package:meditation_app/util/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  BookmarkRepo(this.apiClient, this.sharedPreferences);

  Future<Response> getBookmarks({int page = 1}) async {
    return await apiClient.getData('${AppConfigs.getBookmarks}?perPage=${AppConstants.kPerPage}&page=$page');
  }

  Future<Response> toggleBookmark(int videoId) async {
    return await apiClient.postData(AppConfigs.toggleBookmark, {'video_id': videoId});
  }
}