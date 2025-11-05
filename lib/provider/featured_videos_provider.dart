import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:meditation_app/data/model/response/videos_response.dart';
import 'package:meditation_app/data/repositories/dashboard_repo.dart';
import 'package:meditation_app/provider/repo_provider/dashboard_repo_provider.dart';

import '../data/api/api_checker.dart';
import '../database/database_model.dart';
import '../ui/common/custom_snackbar.dart';

final featuredVideosProvider = ChangeNotifierProvider<FeaturedVideosNotifier>((ref) {
  final repo = ref.watch(dashboardRepoProvider);

  return FeaturedVideosNotifier(repo);
});

class FeaturedVideosNotifier extends ChangeNotifier {
  final DashboardRepo repo;

  FeaturedVideosNotifier(this.repo);

  VideosResponse? _data;
  VideosResponse? get data => _data;
  List<VideoModal> downloadedVideo = [];


  bool _loading = false;
  bool get loading => _loading;

  void startLoading({bool notifie = true}) {
    _loading = true;
    if (notifie) notifyListeners();
  }

  void stopLoading({bool notifie = true}) {
    _loading = false;
    if (notifie) notifyListeners();
  }
  Future<void> getFeatureVideoList(
      int offset,
      bool reload, {
        bool showProgress = true,
      }) async {
    try {
      // ✅ Always show loader on reload or first page
      if (reload || offset == 1) {
        _data = null;
        if (showProgress) startLoading(notifie: false);
        notifyListeners();
      }

      final response = await repo.getFeatureVideoList(offset);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['data'] == null) throw Exception('Unable to find data');

        final newData = VideosResponse.fromJson(json['data'], false);

        if (offset == 1 || reload || _data == null) {
          // ✅ Replace data on reload or first load
          _data = newData;
        } else {
          // ✅ Append data for pagination
          _data!.total = newData.total;
          _data!.currentPage = newData.currentPage;
          _data!.lastPage = newData.lastPage;
          _data!.limit = newData.limit;
          _data!.list?.addAll(newData.list ?? []);
        }

        if (showProgress) stopLoading(notifie: false);
        notifyListeners();
      } else {
        if (showProgress) stopLoading();
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      if (showProgress) stopLoading();
      showCustomSnackBar('Something went wrong');
    }
  }

  // Future<void> getFeatureVideoList(int offset, bool reload, {bool showProgress = true}) async {
  //   if (!reload && offset == 1) {
  //     _data = null;
  //     if (showProgress) {
  //       startLoading(notifie: false);
  //     }
  //     notifyListeners();
  //   }
  //
  //   Response response = await repo.getFeatureVideoList(offset);
  //
  //   try {
  //     if (response.statusCode == 200) {
  //       var json = jsonDecode(response.body);
  //       if (json['data'] == null) {
  //         throw Exception('Unable to find data');
  //       }
  //       if (offset == 1 || _data == null) {
  //         if (reload) _data = null;
  //         _data = VideosResponse.fromJson(json['data'], false);
  //         if (!reload && offset == 1 && showProgress) {
  //           stopLoading(notifie: false);
  //         }
  //         notifyListeners();
  //       } else if (_data != null) {
  //         var tempModel = VideosResponse.fromJson(json['data'], false);
  //         _data!.total = tempModel.total;
  //         _data!.currentPage = tempModel.currentPage;
  //         _data!.lastPage = tempModel.lastPage;
  //         _data!.limit = tempModel.limit;
  //         if (_data!.list != null) _data!.list!.addAll(tempModel.list ?? []);
  //         if (!reload && offset == 1 && showProgress) {
  //           stopLoading(notifie: false);
  //         }
  //         notifyListeners();
  //       }
  //     } else {
  //       if (!reload && offset == 1 && showProgress) {
  //         stopLoading();
  //       }
  //       ApiChecker.checkApi(response);
  //     }
  //   } catch (e) {
  //     if (!reload && offset == 1 && showProgress) {
  //       stopLoading();
  //     }
  //     showCustomSnackBar('Something went wrong');
  //   }
  // }

  void toggleBookmark(int itemId, {bool notifier = true}) {
    if (_data == null || _data!.list == null) {
      return;
    }
    var itemIndex = _data!.list!.indexWhere((element) => element.id == itemId);
    if (itemIndex == -1) return;
    _data!.list![itemIndex].bookmarked = !(_data!.list![itemIndex].bookmarked ?? true);
    if (notifier) notifyListeners();
  }
}
