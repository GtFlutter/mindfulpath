import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:meditation_app/data/api/api_checker.dart';
import 'package:meditation_app/data/model/body/resource_type.dart';
import 'package:meditation_app/data/model/response/error_res_model.dart';
import 'package:meditation_app/data/model/response/videos_response.dart';

import '../../data/repositories/dashboard_repo.dart';
import '../../ui/common/custom_snackbar.dart';
import '../repo_provider/dashboard_repo_provider.dart';

//// TODO ::::::::: Start From Here
final freeVideosProvider = ChangeNotifierProvider<FreeVideosNotifier>((ref) {
  final repo = ref.watch(dashboardRepoProvider);

  return FreeVideosNotifier(repo);
});

abstract class VideosNotifier with ChangeNotifier {
  void startLoading({bool notifie = true});
  void stopLoading({bool notifie = true});
  void featchingComplete(bool reload, int offset, bool showProgress, {bool notifie = true});
  Future<void> fetchData(
    int offset, {
    required int categoryId,
    required bool reload,
    bool showProgress = true,
  });
}

class FreeVideosNotifier extends VideosNotifier {
  final DashboardRepo repo;
  FreeVideosNotifier(this.repo);

  VideosResponse? _data;
  VideosResponse? get data => _data;

  bool _loading = false;
  bool get loading => _loading;

  @override
  void startLoading({bool notifie = true}) {
    _loading = true;
    if (notifie) notifyListeners();
  }

  @override
  void stopLoading({bool notifie = true}) {
    _loading = false;
    if (notifie) notifyListeners();
  }

  @override
  Future<void> fetchData(int offset, {required int categoryId, required bool reload, bool showProgress = true}) async {
    _initFeatching(reload, offset, showProgress);

    Response response = await repo.getVideoList(
      offset: offset,
      categoryId: categoryId,
      resourceType: ResourceType.free,
    );

    if (response.statusCode != 200) {
      featchingComplete(reload, offset, showProgress);
      ApiChecker.checkApi(response);
      return;
    }
    try {
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body)['data'];
        if (json == null) {
          throw ErrorResponse(message: 'Unable to find data');
        }

        if (offset == 1 || _data == null) {
          /// Featched Intial Page
          if (reload) _data = null;
          _data = VideosResponse.fromJson(json);
          featchingComplete(reload, offset, showProgress, notifie: false);
          notifyListeners();
        } else if (_data != null) {
          /// Featched Next Page
          var tempModel = VideosResponse.fromJson(json);
          _data!
            ..total = tempModel.total
            ..currentPage = tempModel.currentPage
            ..lastPage = tempModel.lastPage
            ..limit = tempModel.limit;
          if (_data!.list != null) {
            _data!.list!.addAll(tempModel.list ?? []);
          }
          featchingComplete(reload, offset, showProgress, notifie: false);
          notifyListeners();
        }
      }
    } catch (e) {
      featchingComplete(reload, offset, showProgress);
      showCustomSnackBar('Something went wrong');
    }
  }

  void _initFeatching(bool reload, int offset, bool showProgress) {
    if (!reload && offset == 1) {
      _data = null;
      if (showProgress) {
        startLoading(notifie: false);
      }
      notifyListeners();
    }
  }

  @override
  void featchingComplete(bool reload, int offset, bool showProgress, {bool notifie = true}) {
    if (!reload && offset == 1 && showProgress) {
      stopLoading(notifie: notifie);
    }
  }
}
