import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:meditation_app/data/api/api_checker.dart';
import 'package:meditation_app/ui/screens/analytics/data/model/body/analytics_body.dart';
import 'package:meditation_app/ui/screens/analytics/data/repo/analytics_repo.dart';
import 'package:meditation_app/ui/screens/analytics/data/provider/analytics_repo_provider.dart';

import '../model/response/category_and_video_name_model.dart';

final analyticsProvider = ChangeNotifierProvider<AnalyticsNotifier>((ref) {
  var repo = ref.watch(analyticsRepoProvider);
  return AnalyticsNotifier(repo: repo);
});

class AnalyticsNotifier extends ChangeNotifier {
  final AnalyticsRepo repo;

  AnalyticsNotifier({required this.repo});

  bool _loading = false;
  bool get loading => _loading;

  void startLoading({bool notifie = true}) {
    if (_loading) return;
    _loading = true;
    if (notifie) notifyListeners();
  }

  void stopLoading({bool notifie = true}) {
    if (!_loading) return;
    _loading = false;
    if (notifie) notifyListeners();
  }

  AnalyticsBody? _analyticsBody;
  List<ItemName>? _categories;
  List<ItemName>? _videos;
  AnalyticsBody? get analyticsBody => _analyticsBody;
  List<ItemName>? get categories => _categories;
  List<ItemName>? get videos => _videos;

  void initData({bool notifie = true}) {
    _analyticsBody = null;
    _categories = null;
    _videos = null;
    if (notifie) notifyListeners();
  }

  // category_list
  // video_list

  Future<void> getCategoryNamesList() async {
    startLoading(notifie: false);
    _categories = null;
    _videos = null;
    _analyticsBody = null;
    notifyListeners();
    Response response = await repo.getCategoryNamesList();
    stopLoading();
    if (response.statusCode != 200) {
      _categories = null;
      _videos = null;
      _analyticsBody = null;
      notifyListeners();
      ApiChecker.checkApi(response);
      return;
    }

    try {
      var json = jsonDecode(response.body);
      if (json['data'] != null && json['category_list'] != null) {
        CategoryNames names = CategoryNames.fromJson(json['data']);
        if (names.list.isNotEmpty) {
          _categories = [...names.list];
          notifyListeners();
          return;
        }
      }
    } catch (e) {
      debugPrint('${e}');
    }
    _categories = null;
    _videos = null;
    _analyticsBody = null;
    notifyListeners();
  }

  Future<void> getVideoNamesList(int categoryId) async {
    startLoading(notifie: false);
    _videos = null;
    _analyticsBody = null;
    notifyListeners();
    Response response = await repo.getVideoNamesList(categoryId);
    stopLoading();
    if (response.statusCode != 200) {
      _categories = null;
      _videos = null;
      _analyticsBody = null;
      notifyListeners();
      ApiChecker.checkApi(response);
      return;
    }

    try {
      var json = jsonDecode(response.body);
      if (json['data'] != null && json['video_list'] != null) {
        VideoNames names = VideoNames.fromJson(json['data']);
        if (names.list.isNotEmpty) {
          _videos = [...names.list];
          notifyListeners();
          return;
        }
      }
    } catch (e) {
      debugPrint('${e}');
    }
    _categories = null;
    _videos = null;
    _analyticsBody = null;
    notifyListeners();
  }
}
