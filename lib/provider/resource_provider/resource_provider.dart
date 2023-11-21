import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

import '../../data/api/api_checker.dart';
import '../../data/model/body/resource_type.dart';
import '../../data/model/response/videos_response.dart';
import '../../data/repositories/dashboard_repo.dart';
import '../../ui/common/custom_snackbar.dart';
import '../../ui/screens/analytics/data/model/response/category_and_video_name_model.dart';
import '../../util/constants.dart';
import '../repo_provider/dashboard_repo_provider.dart';

/// TODO::: Working From Here Start :Resource Provider

enum CourseFilter {
  video(0),
  pdf(1);

  final int filterIndex;
  const CourseFilter(this.filterIndex);

  factory CourseFilter.fromInt(int id) {
    switch (id) {
      case 0:
        return video;
      case 1:
        return pdf;
      default:
        throw ArgumentError();
    }
  }

  static List<ItemName> filterList = [ItemName(id: 0, title: 'Video'), ItemName(id: 1, title: 'PDF')];
}

class ResourceBody {
  final ResourceType type;
  CourseFilter filter;
  ResourceBody.free(this.filter) : type = ResourceType.free;
  ResourceBody.thirtydays(this.filter) : type = ResourceType.paid;
}

final resourceProvider = ChangeNotifierProvider<ResourceNotifier>((ref) {
  final repo = ref.watch(dashboardRepoProvider);

  return ResourceNotifier(repo);
});

class ResourceNotifier extends ChangeNotifier {
  final DashboardRepo repo;
  ResourceNotifier(this.repo);

  final List<ItemName> _filters = [...CourseFilter.filterList];
  List<ItemName> get filters => _filters;

  ItemName filter(ResourceType currentSelectedType) {
    switch (currentSelectedType) {
      case ResourceType.free:
        return _filters[_freeBody.filter.filterIndex];
      case ResourceType.paid:
        return _filters[_paidBody.filter.filterIndex];
      default:
        throw ArgumentError();
    }
  }

  final ResourceBody _freeBody = ResourceBody.free(CourseFilter.video);
  ResourceBody get freeBody => _freeBody;

  final ResourceBody _paidBody = ResourceBody.free(CourseFilter.video);
  ResourceBody get paidBody => _paidBody;

  void chnageFilter(ResourceType type, CourseFilter filter) {
    switch (type) {
      case ResourceType.free:
        if (_freeBody.filter != filter) {
          debugPrint('changes');
          _freeBody.filter = filter;
          notifyListeners();
        }
        break;
      case ResourceType.paid:
        if (_paidBody.filter != filter) {
          debugPrint('changes2');
          _paidBody.filter = filter;
          notifyListeners();
        }
        break;
    }
  }

  /// [ResourceType.free] & [CourseFilter.video]
  /// [ResourceType.free] & [CourseFilter.pdf]
  /// [ResourceType.paid] & [CourseFilter.video]
  /// [ResourceType.paid] & [CourseFilter.pdf]
  ///
  ///
  ///
  ///

  VideosResponse? _videosResponse;
  VideosResponse? get videosResponse => _videosResponse;
  void toggleBookmark(int itemId, {bool notifier = true}) {
    if (_videosResponse == null || _videosResponse!.list == null) {
      return;
    }
    var itemIndex = _videosResponse!.list!.indexWhere((element) => element.id == itemId);
    if (itemIndex == -1) return;
    _videosResponse!.list![itemIndex].bookmarked = !(_videosResponse!.list![itemIndex].bookmarked ?? true);
    if (notifier) notifyListeners();
  }

  bool _isVideoLoading = false;
  bool get isVideoLoading => _isVideoLoading;

  void startVideoLoading() {
    _isVideoLoading = true;
    notifyListeners();
  }

  void stopVideoLoading() {
    _isVideoLoading = false;
    notifyListeners();
  }

  Future<void> getVideoList(int id) async {
    startVideoLoading();

    /// TODO :: Remove Below Line For Production

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
}
