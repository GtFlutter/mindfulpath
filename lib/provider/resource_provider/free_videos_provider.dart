import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' show Response;
import '../../data/api/api_checker.dart';
import '../../data/model/body/resource_type.dart';
import '../../data/model/response/videos_response.dart';
import '../../data/repositories/dashboard_repo.dart';
import '../../database/database_model.dart';
import '../../ui/common/custom_snackbar.dart';
import '../../util/constants.dart';
import '../repo_provider/dashboard_repo_provider.dart';
import 'video_resource_notifier_model.dart';

final freeVideosProvider = ChangeNotifierProvider<FreeVideosNotifier>((ref) {
  final repo = ref.watch(dashboardRepoProvider);
  return FreeVideosNotifier(repo);
});

class FreeVideosNotifier extends VideoResourceNotifier {
  final DashboardRepo repo;
  FreeVideosNotifier(this.repo);

  VideosResponse? _videosResponse;
  VideosResponse? get videosResponse => _videosResponse;

  List<VideoModal> downloadedVideo=[];



  @override
  void toggleBookmark(int itemId, {bool notifier = true}) {
    if (_videosResponse == null || _videosResponse!.list == null) {
      return;
    }
    var itemIndex = _videosResponse!.list!.indexWhere((element) => element.id == itemId);
    if (itemIndex == -1) return;
    _videosResponse!.list![itemIndex].bookmarked = !(_videosResponse!.list![itemIndex].bookmarked ?? true);
    if (notifier) notifyListeners();
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
  Future<void> fetchVideos(int categoryId) async {
    startLoading();
    Response response = await repo.getVideos(categoryId: categoryId, offset: 1, resourceType: ResourceType.free);
    if (response.statusCode != 200) {
      stopLoading();
      ApiChecker.checkApi(response);
    } else {
      try {
        var json = jsonDecode(response.body);
        _videosResponse = VideosResponse.fromJson(json['data']);
        stopLoading();
      } catch (e) {
        showCustomSnackBar(AppConstants.WENT_WRONG, type: false);
        stopLoading();
      }
    }
  }
}
