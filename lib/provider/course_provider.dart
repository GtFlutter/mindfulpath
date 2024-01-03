import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:meditation_app/data/api/api_checker.dart';
import 'package:meditation_app/data/model/response/purchased_video_response.dart';
import 'package:meditation_app/data/repositories/course_repo.dart';
import 'package:meditation_app/provider/repo_provider/course_repo_provider.dart';
import 'package:meditation_app/ui/common/custom_snackbar.dart';
import 'package:meditation_app/util/constants.dart';

final courseProvider = ChangeNotifierProvider<CourseNotifier>((ref) {
  final repo = ref.watch(courseRepoProvider);
  return CourseNotifier(repo);
});

class CourseNotifier extends ChangeNotifier {

  final CourseRepo repo;
  CourseNotifier(this.repo);

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

}