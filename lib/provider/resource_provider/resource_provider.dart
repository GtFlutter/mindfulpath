import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

import '../../data/api/api_checker.dart';
import '../../data/model/body/resource_type.dart';
import '../../data/model/response/videos_response.dart';
import '../../data/repositories/dashboard_repo.dart';
import '../../ui/common/custom_snackbar.dart';
import '../../util/constants.dart';
import '../repo_provider/dashboard_repo_provider.dart';

/// TODO::: Working From Here Start :Resource Provider
final videoResourceProvider = ChangeNotifierProvider<FreeVideoResourceNotifier>((ref) {
  final repo = ref.watch(dashboardRepoProvider);

  return FreeVideoResourceNotifier(repo);
});

/// TODO ::: First Start From Here ________|||||||++++++++++++++++++++|||||||||||__________
abstract class VideoResourceNotifier with ChangeNotifier {
  void toggleBookmark(int itemId, {bool notifier = true});
  void startFreeVideoLoading();
  void stopFreeVideoLoading();
  Future<void> getFreeVideoList(int id);
}

class FreeVideoResourceNotifier extends VideoResourceNotifier {
  final DashboardRepo repo;
  FreeVideoResourceNotifier(this.repo);

  VideosResponse? _freeVideosResponse;
  VideosResponse? get freeVideosResponse => _freeVideosResponse;

  @override
  void toggleBookmark(int itemId, {bool notifier = true}) {
    if (_freeVideosResponse == null || _freeVideosResponse!.list == null) {
      return;
    }
    var itemIndex = _freeVideosResponse!.list!.indexWhere((element) => element.id == itemId);
    if (itemIndex == -1) return;
    _freeVideosResponse!.list![itemIndex].bookmarked = !(_freeVideosResponse!.list![itemIndex].bookmarked ?? true);
    if (notifier) notifyListeners();
  }

  bool _isFreeVideoLoading = false;
  bool get isFreeVideoLoading => _isFreeVideoLoading;
  @override
  void startFreeVideoLoading() {
    _isFreeVideoLoading = true;
    notifyListeners();
  }

  @override
  void stopFreeVideoLoading() {
    _isFreeVideoLoading = false;
    notifyListeners();
  }

  @override
  Future<void> getFreeVideoList(int id) async {
    startFreeVideoLoading();
    Response response = await repo.getVideoList(categoryId: id, offset: 1, resourceType: ResourceType.free);
    if (response.statusCode != 200) {
      stopFreeVideoLoading();
      ApiChecker.checkApi(response);
    } else {
      try {
        var json = jsonDecode(response.body);
        _freeVideosResponse = VideosResponse.fromJson(json['data']);
        stopFreeVideoLoading();
      } catch (e) {
        showCustomSnackBar(AppConstants.WENT_WRONG, type: false);
        stopFreeVideoLoading();
      }
    }
  }
}
