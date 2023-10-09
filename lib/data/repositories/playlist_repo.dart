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
    return await apiClient.getData('${AppConfigs.getPlaylist}?perPage=${AppConstants.kPerPage}&page=$page');
  }
}