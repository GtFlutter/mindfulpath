import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:meditation_app/data/api/api_checker.dart';
import 'package:meditation_app/data/model/response/category_list_reponse.dart';
import 'package:meditation_app/data/model/response/video_list_response.dart';
import 'package:meditation_app/data/repositories/dashboard_repo.dart';
import 'package:meditation_app/provider/repo_provider/dashboard_repo_provider.dart';
import 'package:meditation_app/ui/common/custom_snackbar.dart';
import 'package:meditation_app/util/constants.dart';

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

  List<VideoListResponse>? _videoListResponse;
  List<VideoListResponse>? get videoListResponse => _videoListResponse;

  Future<void> getCategoryList() async {
    startLoading();
    Response response = await repo.getCategories();
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
    startLoading();
    Response response = await repo.getVideoList(id);
    if (response.statusCode != 200) {
      stopLoading();
      ApiChecker.checkApi(response);
    } else {
      try {
        var json = jsonDecode(response.body);
        _videoListResponse = VideoListResponse.listFromJson(json['data']['video_list']);
        stopLoading();
      } catch (e) {
        showCustomSnackBar(AppConstants.WENT_WRONG, type: false);
        stopLoading();
      }
    }
  }
}