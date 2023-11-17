import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:meditation_app/data/api/api_checker.dart';
import 'package:meditation_app/data/model/body/resource_type.dart';
import 'package:meditation_app/data/model/response/category_list_reponse.dart';
import 'package:meditation_app/data/model/response/video_list_response.dart';
import 'package:meditation_app/data/repositories/dashboard_repo.dart';
import 'package:meditation_app/provider/repo_provider/dashboard_repo_provider.dart';
import 'package:meditation_app/ui/common/custom_snackbar.dart';
import 'package:meditation_app/util/constants.dart';
import '../data/model/response/videos_response.dart';

final dashboardProvider = ChangeNotifierProvider<DashboardNotifier>((ref) {
  final repo = ref.watch(dashboardRepoProvider);
  return DashboardNotifier(repo, ref);
});

class DashboardNotifier extends ChangeNotifier {
  final DashboardRepo repo;
  final ChangeNotifierProviderRef<DashboardNotifier> ref;

  DashboardNotifier(this.repo, this.ref);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isVideoLoading = false;
  bool get isVideoLoading => _isVideoLoading;

  void startVideoLoading() {
    if (!_isVideoLoading) {
      _isVideoLoading = true;
      notifyListeners();
    }
  }

  void stopVideoLoading() {
    if (_isVideoLoading) {
      _isVideoLoading = false;
      notifyListeners();
    }
  }

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

  List<CategoryListResponse>? _categoryListResponse;
  List<CategoryListResponse>? get categoryListResponse => _categoryListResponse;

  VideosResponse? _videosResponse;
  VideosResponse? get videosResponse => _videosResponse;

  Future<void> init() async {
    await getCategoryList();

    /// TODO: Get Featured List Response
    // await getFeatureVideoList();
  }

  Future<void> getCategoryList() async {
    startLoading();
    Response response = await repo.getCategories(1);
    if (response.statusCode != 200) {
      stopLoading();
      ApiChecker.checkApi(response);
    } else {
      try {
        var json = jsonDecode(response.body);
        _categoryListResponse = CategoryListResponse.listFromJson(json['data']['category_list']);
        stopLoading();
      } catch (e) {
        showCustomSnackBar(AppConstants.WENT_WRONG, type: false);
        stopLoading();
      }
    }
  }

  Future<void> getVideoList(int id) async {
    startVideoLoading();

    /// TODO :: Remove Below Line For Production
    await Future.delayed(const Duration(seconds: 10));
    Response response = await repo.getVideoList(categoryId: id, offset: 1, resourceType: ResourceType.free);
    if (response.statusCode != 200) {
      stopVideoLoading();
      ApiChecker.checkApi(response);
    } else {
      try {
        var json = jsonDecode(response.body);
        _videosResponse = VideosResponse.fromJson(json['data']);
        stopVideoLoading();
      } catch (e) {
        showCustomSnackBar(AppConstants.WENT_WRONG, type: false);
        stopVideoLoading();
      }
    }
  }

  Future<void> storeVideoWatchedTime(int videoId, Duration duration) async {
    Response response = await repo.storeVideoWatchedTime(videoId, duration);
    if (response.statusCode != 200) {
      ApiChecker.checkApi(response);
      return;
    } else {}
  }

  void toggleBookmark(int itemId, {bool notifier = true}) {
    if (_videosResponse == null || _videosResponse!.list == null) {
      return;
    }
    var itemIndex = _videosResponse!.list!.indexWhere((element) => element.id == itemId);
    if (itemIndex == -1) return;
    _videosResponse!.list![itemIndex].bookmarked = !(_videosResponse!.list![itemIndex].bookmarked ?? true);
    if (notifier) notifyListeners();
  }
}
