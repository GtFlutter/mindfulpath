import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:meditation_app/data/api/api_checker.dart';
import 'package:meditation_app/data/model/response/purchased_video_response.dart';
import 'package:meditation_app/data/repositories/course_repo.dart';
import 'package:meditation_app/database/database_helper.dart';
import 'package:meditation_app/database/database_model.dart';
import 'package:meditation_app/provider/repo_provider/course_repo_provider.dart';
import 'package:meditation_app/ui/common/custom_snackbar.dart';
import 'package:meditation_app/util/constants.dart';

final courseProvider = ChangeNotifierProvider<CourseNotifier>((ref) {
  final repo = ref.watch(courseRepoProvider);
  return CourseNotifier(ref, repo);
});

class CourseNotifier extends ChangeNotifier {

  final CourseRepo repo;
  final ChangeNotifierProviderRef<CourseNotifier> ref;
  CourseNotifier(this.ref, this.repo);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<PurchasedVideoResponse> _purchasedVideoResponse = [];
  List<PurchasedVideoResponse> get purchasedVideoResponse => _purchasedVideoResponse;

  void _startLoading() {
    if (!_isLoading) {
      _isLoading = true;
      notifyListeners();
    }
  }

  void _stopLoading() {
    if (_isLoading) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getPurchasedList() async {
    _startLoading();
    Response response = await repo.getPurchasedList();
    debugPrint('RESPONSE CODE :: ${response.statusCode}');
    if (response.statusCode != 200) {
      _stopLoading();
      ApiChecker.checkApi(response);
    } else {
      try {
        var json = jsonDecode(response.body);
        _purchasedVideoResponse = PurchasedVideoResponse.listFromJson(json['data']['category_list']);
        _stopLoading();
      } catch (e) {
        showCustomSnackBar(AppConstants.WENT_WRONG, type: false);
        _stopLoading();
      }
    }
  }

  List<PurchasedVideoResponse> _cpVideoResponse = [];
  List<PurchasedVideoResponse> get cpVideoResponse => _cpVideoResponse;

  Future<void> getCurrentlyProgressList() async {
    _startLoading();
    Response response = await repo.getPurchasedList();
    debugPrint('RESPONSE CODE :: ${response.statusCode}');
    if (response.statusCode != 200) {
      _stopLoading();
      ApiChecker.checkApi(response);
    } else {
      try {
        var json = jsonDecode(response.body);
        _cpVideoResponse = PurchasedVideoResponse.listFromJson(json['data']['category_list']);
        _stopLoading();
      } catch (e) {
        showCustomSnackBar(AppConstants.WENT_WRONG, type: false);
        _stopLoading();
      }
    }
  }

  List<CategoryModal> _downloadResponse = [];
  List<CategoryModal> get downloadResponse => _downloadResponse;

  Future<void> getCategoryFromDatabase() async {
    _startLoading();

    List<CategoryModal> list = await ref.read(databaseProvider).getCategory();
    debugPrint('VIDEO CATEGORYIES :: ${list.length}');
    _downloadResponse = list;
    _stopLoading();
  }

  List<PdfModel> _downloadPdfResponses = [];
  List<PdfModel> get downloadPdfResponses => _downloadPdfResponses;
  int index = 0;


  Future<void> getCategoryPdfFromDatabase() async {
    _startLoading();
    List<PdfModel> list = await ref.read(databaseProvider).getPdfCategory();
    print(list.length);
    index=list.length;
    print(list);
    print("================123456=====================");
    _downloadPdfResponses=list;
    _stopLoading();
  }

  List<VideoModal> _downloadVideoResponse = [];
  List<VideoModal> get downloadVideoResponse => _downloadVideoResponse;

  Future<void> getVideoFromDatabase(int categoryId) async {
    _startLoading();
    List<VideoModal> list = await ref.read(databaseProvider).getVideo(categoryId);
    _downloadVideoResponse = list;
    _stopLoading();
  }

  final List<PdfModel> _downloadPdfResponse = [];
  List<PdfModel> get downloadPdfResponse => _downloadPdfResponse;


  Future<void> getPdfFromDatabase(int id) async {
    _startLoading();
    List<PdfModel> list = await ref.read(databaseProvider).getPdf(id);
    _downloadPdfResponse.addAll(list);
    debugPrint("Length ${list.length}");
    debugPrint("Length Of PDF : ${_downloadPdfResponse.length}");
    _stopLoading();
  }
}