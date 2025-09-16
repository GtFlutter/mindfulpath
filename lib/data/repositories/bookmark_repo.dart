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

  Future<Response> getAudioBookmarks({int page = 1}) async {
    return await apiClient.getData('${AppConfigs.getAudioBookmarks}?perPage=${AppConstants.kPerPage}&page=$page');
  }
  Future<Response> getPDFBookmarks({int page = 1}) async {
    return await apiClient.getData('${AppConfigs.getPDFBookmarks}?perPage=${AppConstants.kPerPage}&page=$page');
  }

  Future<Response> toggleBookmark(int videoId, bool isAudio,bool isPDFId) async {
    return await apiClient.postData(AppConfigs.toggleBookmark, {isAudio ? 'audio_id' :isPDFId?'pdf_id':'video_id': videoId});
  }
}