import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:meditation_app/data/api/api_checker.dart';
import 'package:meditation_app/data/model/response/playlist_details_response.dart';
import 'package:meditation_app/data/model/response/playlist_list_response.dart';
import 'package:meditation_app/data/model/response/videos_response.dart';
import 'package:meditation_app/data/repositories/playlist_repo.dart';
import 'package:meditation_app/provider/repo_provider/playlist_repo_provider.dart';
import 'package:meditation_app/ui/common/custom_snackbar.dart';
import 'package:meditation_app/util/constants.dart';

final playListProvider = ChangeNotifierProvider<PlaylistNotifier>((ref) {
  final repo = ref.watch(playlistRepoProvider);
  return PlaylistNotifier(repo);
});

class PlaylistNotifier extends ChangeNotifier {
  PlaylistRepo repo;

  PlaylistNotifier(this.repo);

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<PlaylistVideoList>? playlistVideoListResponse;
  List<PlaylistVideoList>? playlistAudioListResponse;
  List<PlaylistListResponse>? _playlistListResponse;

  List<PlaylistListResponse>? get playlistListResponse => _playlistListResponse;

  PlaylistDetailResponse? _playlistDetailResponse;

  PlaylistDetailResponse? get playlistDetailResponse => _playlistDetailResponse;

  void startLoading() {
    if (!_isLoading) {
      _isLoading = true;
      notifyListeners();
    }
  }

  void stopLoading() {
    if (_isLoading) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getPlaylistList({bool showProgress = false}) async {
    if (showProgress) startLoading();
    Response response = await repo.getPlaylist();
    debugPrint('RESPONSE CODE :: ${response.statusCode}');
    if (response.statusCode != 200) {
      if (showProgress) stopLoading();
      ApiChecker.checkApi(response);
    } else {
      try {
        var json = jsonDecode(response.body);
        _playlistListResponse = PlaylistListResponse.listFromJson(json['data']['palylist']);
        if (showProgress) {
          stopLoading();
        } else {
          notifyListeners();
        }
      } catch (e) {
        showCustomSnackBar(AppConstants.WENT_WRONG, type: false);
        if (showProgress) stopLoading();
      }
    }
  }

  Future<void> getPlaylistDetails(int playListId, {bool showProgress = false}) async {
    if (showProgress) startLoading();

    Response response = await repo.getPlaylistDetail(playListId);
    debugPrint('RESPONSE CODE :: ${response.statusCode}');
    if (response.statusCode != 200) {
      if (showProgress) stopLoading();
      ApiChecker.checkApi(response);
    } else {
      _playlistDetailResponse = PlaylistDetailResponse.fromJson(jsonDecode(response.body));
      playlistVideoListResponse = playlistVideoListResponse ?? [];
      playlistAudioListResponse = playlistAudioListResponse ?? [];
      playlistVideoListResponse?.clear();
      playlistAudioListResponse?.clear();
      if (_playlistDetailResponse != null) {
        _playlistDetailResponse?.data?.playlistVideoList?.map(
          (e) {
            if (e.videoId != null) {
              playlistVideoListResponse?.add(e);
            } else {
              playlistAudioListResponse?.add(e);
            }
          },

        ).toList();
        notifyListeners();
      }
      if (showProgress) {
        stopLoading();
      } else {
        notifyListeners();
      }
    }
  }

  bool _isCreatePlaylistLoading = false;

  bool get isCreatePlaylistLoading => _isCreatePlaylistLoading;

  void startCreatePlaylistLoading() {
    if (!_isCreatePlaylistLoading) {
      _isCreatePlaylistLoading = true;
      notifyListeners();
    }
  }

  void stopCreatePlaylistLoading() {
    if (_isCreatePlaylistLoading) {
      _isCreatePlaylistLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createPlaylist(String title, {String? videoId}) async {
    startCreatePlaylistLoading();
    Response response = await repo.createPlaylist(title, videoId: videoId);
    debugPrint('RESPONSE CODE :: ${response.statusCode}');
    if (response.statusCode != 200) {
      stopCreatePlaylistLoading();
      ApiChecker.checkApi(response);
    } else {
      stopCreatePlaylistLoading();
      getPlaylistList();
      showCustomSnackBar('Playlist Created Successfully', type: true);
      return true;
    }
    stopCreatePlaylistLoading();
    return false;
  }

  Future<bool> deletePlaylist(String id) async {
    Response response = await repo.deletePlaylist(id);
    debugPrint('RESPONSE CODE :: ${response.statusCode}');
    if (response.statusCode != 200) {
      ApiChecker.checkApi(response);
    } else {
      getPlaylistList();
      showCustomSnackBar('Playlist Deleted Successfully', type: true);
      return true;
    }
    return false;
  }

  Future<bool> addToPlaylist(String playlistId, String videoId, bool isAudio) async {
    Response response = await repo.addToPlaylist(playlistId, videoId, isAudio);
    debugPrint('RESPONSE CODE :: ${response.statusCode}');
    var json = jsonDecode(response.body);
    if (response.statusCode != 200) {
      ApiChecker.checkApi(response);
    } else {
      // showCustomSnackBar('Added In Playlist Successfully  ', type: true);
      showCustomSnackBar(json["message"], type: true);
      return true;
    }
    return false;
  }

  Future<bool> removeFromPlaylist(String playlistId, String videoId, bool isAudio) async {
    startLoading();
    Response response = await repo.removeFromPlaylist(playlistId, videoId, isAudio);

    debugPrint('RESPONSE CODE :: ${response.statusCode}');
    var json = jsonDecode(response.body);
    if (response.statusCode != 200) {
      stopLoading();
      ApiChecker.checkApi(response);
    } else {
      stopLoading();
      // showCustomSnackBar('Added In Playlist Successfully  ', type: true);
      showCustomSnackBar(json["message"], type: true);
      return true;
    }
    stopLoading();
    return false;
  }
}
