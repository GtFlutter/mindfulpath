import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:meditation_app/data/api/api_checker.dart';
import 'package:meditation_app/data/model/response/category_list_reponse.dart';
import 'package:meditation_app/data/model/response/videos_response.dart';
import 'package:meditation_app/data/repositories/dashboard_repo.dart';
import 'package:meditation_app/helper/route/router.dart';
import 'package:meditation_app/provider/repo_provider/dashboard_repo_provider.dart';
import 'package:meditation_app/ui/common/custom_snackbar.dart';
import 'package:meditation_app/ui/screens/search/util/query_time.dart';
import 'package:meditation_app/util/constants.dart';

final dashboardProvider = ChangeNotifierProvider<DashboardNotifier>((ref) {
  final repo = ref.watch(dashboardRepoProvider);
  return DashboardNotifier(repo, ref);
});

class DashboardNotifier extends ChangeNotifier {
  final DashboardRepo repo;
  final ChangeNotifierProviderRef<DashboardNotifier> ref;

  DashboardNotifier(this.repo, this.ref);

  bool islandScap=false;
  int? selectedSearchIndex;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

// ///search screen parameters
//   List<CategoryListResponse> selectedCategories = [];
//   List<String> selectedCatTitle = [];
//   QueryTime? selectedQueryTime;
//   final TextEditingController controller = TextEditingController();

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

  VideosResponse? _data;
  VideosResponse? get data => _data;

  Future<void> init() async {
    await getCategoryList();
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

  Future<void> storeVideoWatchedTime(int videoId, Duration duration, bool isAudio) async {
    Response response = await repo.storeVideoWatchedTime(videoId, duration, isAudio);
    if (response.statusCode != 200) {
      ApiChecker.checkApi(response);
      return;
    } else {}
  }

  bool _isSearchLoading = false;
  bool get isSearchLoading => _isSearchLoading;

  void startSearchLoading() {
    if (!_isSearchLoading) {
      _isSearchLoading = true;
      notifyListeners();
    }
  }

  void stopSearchLoading() {
    if (_isSearchLoading) {
      _isSearchLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchVideo(String queryText, {required QueryTime queryTime, int offset = 1, List<int>? categoryId}) async {
    startSearchLoading();
    _data=null;
    Response response = await repo.searchVideos(queryText, queryTime: queryTime, offset: offset, categoryId: categoryId);
    if (response.statusCode != 200) {
      ApiChecker.checkApi(response);
    } else {
      var json = jsonDecode(response.body);
      _data = VideosResponse.fromJson(json['data'], false);

      notifyListeners();
      debugPrint('search Response Body :: ${response.body}');
    }
    stopSearchLoading();
  }

  bool _isPurchaseLoading = false;
  bool get isPurchaseLoading => _isPurchaseLoading;

  void startPurchaseLoading() {
    if (!_isPurchaseLoading) {
      _isPurchaseLoading = true;
      notifyListeners();
    }
  }

  void stopPurchaseLoading() {
    if (_isPurchaseLoading) {
      _isPurchaseLoading = false;
      notifyListeners();
    }
  }

  Future<bool> purchaseCategory(String categoryId, String transactionId) async {
    startPurchaseLoading();
    Response response = await repo.purchaseCategory(categoryId, transactionId);
    if (response.statusCode != 200) {
      stopPurchaseLoading();
      BuildContext? context = rootNavigator.currentContext;
      if (context != null && context.mounted) {
        context.pop();
      }
      ApiChecker.checkApi(response);
      return false;
    } else {
      BuildContext? context = rootNavigator.currentContext;
      if (context != null && context.mounted) {
        context.pop(true);
      }
      showCustomSnackBar('Category Purchase Successfully', type: true);
      stopPurchaseLoading();
      return true;
    }
  }
}
