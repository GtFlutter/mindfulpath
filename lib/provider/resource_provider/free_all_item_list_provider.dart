import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' show Response;
import 'package:meditation_app/data/model/all_item_data_model.dart';

import '../../data/api/api_checker.dart';
import '../../data/model/body/resource_type.dart';
import '../../data/model/response/pdfs_response.dart';
import '../../data/model/response/videos_response.dart';
import '../../data/repositories/dashboard_repo.dart';
import '../../database/database_model.dart';
import '../../ui/common/custom_snackbar.dart';
import '../../util/constants.dart';
import '../repo_provider/dashboard_repo_provider.dart';
import 'audio_resource_notifier_model.dart';

final freeAllItemProvider = ChangeNotifierProvider<FreeAllItemNotifier>((ref) {
  final repo = ref.watch(dashboardRepoProvider);
  return FreeAllItemNotifier(repo);
});

class FreeAllItemNotifier extends ChangeNotifier {
  final DashboardRepo repo;
  FreeAllItemNotifier(this.repo);

  AllItemWidgetListResponse? _allItemResponse;
  AllItemWidgetListResponse? get allItemResponse => _allItemResponse;


  int? selectedIndex;
  List<VideoModal> downloadedAudio = [];
  List<VideoModal> downloadedVideo = [];
  List<PdfModel> downloadedPDF = [];

  @override
  void toggleBookmark(int itemId, {bool notifier = true}) {
    // TODO: implement toggleBookmark
  }

  bool _loading = false;
  bool get loading => _loading;
  @override
  void startLoading() {
    _loading = true;
    notifyListeners();
  }

  @override
  void stopLoading() {
    _loading = false;
    notifyListeners();
  }

  @override
  Future<void> fetchAllFreeItem(int categoryId) async {
    startLoading();
    Response response = await repo.getAllItem(categoryId: categoryId, offset: 1, resourceType: ResourceType.free);
    if (response.statusCode != 200) {
      stopLoading();
      ApiChecker.checkApi(response);
    } else {
      try {
        final jsonResponse = json.decode(response.body);
        final  allData = jsonResponse['data'];
        _allItemResponse = AllItemWidgetListResponse.fromJson(allData);
        log("all item list=======>${_allItemResponse?.toJson()}");
        stopLoading();
        notifyListeners();
      } catch (e) {
        showCustomSnackBar(AppConstants.WENT_WRONG, type: false);
        stopLoading();
      }
    }
  }

}

