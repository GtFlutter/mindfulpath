import 'package:http/http.dart';
import 'package:meditation_app/data/api/api_client.dart';
import 'package:meditation_app/util/app_config.dart';
import 'package:meditation_app/util/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaylistRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  PlaylistRepo(this.apiClient, this.sharedPreferences);

  Future<Response> getPlaylist({int page = 1}) async {
    return await apiClient.getData('${AppConfigs.getPlaylist}?perPage=10&page=$page');
    return await apiClient.getData('${AppConfigs.getPlaylist}?perPage=${AppConstants.kPerPage}&page=$page');
  }

  Future<Response> getPlaylistDetail(int playListId) async {
    var body = {
      'playlist_id': playListId,
      'perPage': AppConstants.kPerPage,
      'page': 1,

    };
    return await apiClient.postData(AppConfigs.getPlaylistDetail,body);
  }

  Future<Response> createPlaylist(String title, {String? videoId}) async {
    var body = {'title': title};
    if (videoId != null) body.addAll({'video_id': videoId});
    return await apiClient.postData(AppConfigs.createPlaylist, body);
  }

  Future<Response> deletePlaylist(String id) async {
    return await apiClient.postData(AppConfigs.deletePlaylist, {'playlist_id': id});
  }

  Future<Response> addToPlaylist(String playlistId, String videoId) async {
    var body = {'playlist_id': playlistId, 'video_id': videoId};
    return await apiClient.postData(AppConfigs.addToPlaylist, body);
  }
}
