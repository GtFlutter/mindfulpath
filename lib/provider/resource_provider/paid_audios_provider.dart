import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' show Response;
import 'package:meditation_app/provider/resource_provider/audio_resource_notifier_model.dart';

import '../../data/api/api_checker.dart';
import '../../data/model/body/resource_type.dart';
import '../../data/model/response/videos_response.dart';
import '../../data/repositories/dashboard_repo.dart';
import '../../database/database_model.dart';
import '../../ui/common/custom_snackbar.dart';
import '../../util/constants.dart';
import '../repo_provider/dashboard_repo_provider.dart';

final paidAudiosProvider = ChangeNotifierProvider<PaidAudioNotifier>((ref) {
  final repo = ref.watch(dashboardRepoProvider);
  return PaidAudioNotifier(repo);
});

class PaidAudioNotifier extends AudioResourceNotifier {
  final DashboardRepo repo;
  PaidAudioNotifier(this.repo);

  VideosResponse? _videosResponse;
  VideosResponse? get videosResponse => _videosResponse;
  List<VideoModal> downloadedAudio=[];


  @override
  void toggleBookmark(int itemId, {bool notifier = true}) {
    if (_videosResponse == null || _videosResponse!.list == null) {
      return;
    }
    var itemIndex = _videosResponse!.list!.indexWhere((element) => element.id == itemId);
    if (itemIndex == -1) return;
    _videosResponse!.list![itemIndex].bookmarked = !(_videosResponse!.list![itemIndex].bookmarked ?? true);
    if (notifier) notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  @override
  void startLoading({bool? isLoading}) {
    if(isLoading==false)return;
    _loading = true;
    notifyListeners();
  }

  @override
  void stopLoading({bool? isLoading}) {
    if(isLoading==false)return;
    _loading = false;
    notifyListeners();
  }

  @override
  Future<void> fetchAudios(int categoryId, {bool? isLoading}) async {
    startLoading(isLoading:isLoading ?? true);
    Response response = await repo.getAudios(categoryId: categoryId, offset: 1, resourceType: ResourceType.paid);
    if (response.statusCode != 200) {
      stopLoading(isLoading:isLoading ?? true);
      ApiChecker.checkApi(response);
    } else {
      try {
        var json = jsonDecode(response.body);
        _videosResponse = VideosResponse.fromJson(json['data'], true);
        stopLoading(isLoading:isLoading ?? true);
      } catch (e) {
        showCustomSnackBar(AppConstants.WENT_WRONG, type: false);
        stopLoading(isLoading:isLoading ?? true);
      }
    }
  }
}
