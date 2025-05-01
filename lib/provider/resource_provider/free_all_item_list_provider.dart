import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' show Response;

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

class FreeAllItemNotifier extends AllResourceNotifier {
  final DashboardRepo repo;
  FreeAllItemNotifier(this.repo);

  // Separate lists for audio, video, and PDF responses
  List<VideoResponse>? _audioItemResponse;
  List<VideoResponse>? get audioItemResponse => _audioItemResponse;

  List<VideoResponse>? _videoItemResponse;
  List<VideoResponse>? get videoItemResponse => _videoItemResponse;

  List<PdfResponse>? _pdfItemResponse;
  List<PdfResponse>? get pdfItemResponse => _pdfItemResponse;

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
  Future<void> fetchAudios(int categoryId) async {
    startLoading();
    Response response = await repo.getAudios(categoryId: categoryId, offset: 1, resourceType: ResourceType.free);
    if (response.statusCode != 200) {
      stopLoading();
      ApiChecker.checkApi(response);
    } else {
      try {
        final jsonResponse = json.decode(response.body);
        final List<dynamic> audioList = jsonResponse['data']["list"];
        _audioItemResponse = audioList.map((json) => VideoResponse.fromJson(json, true)).toList();
        log("audio list=======>${audioItemResponse?.length}");
        stopLoading();
        notifyListeners();
      } catch (e) {
        showCustomSnackBar(AppConstants.WENT_WRONG, type: false);
        stopLoading();
      }
    }
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
        final jsonResponse = json.decode(response.body);
        final List<dynamic> videoList = jsonResponse['data']["list"];
        _videoItemResponse = videoList.map((json) => VideoResponse.fromJson(json, false)).toList();
        log("video list=======>${videoItemResponse?.length}");
        stopLoading();
        notifyListeners();
      } catch (e) {
        showCustomSnackBar(AppConstants.WENT_WRONG, type: false);
        stopLoading();
      }
    }
  }

  @override
  Future<void> fetchPDFs(int categoryId) async {
    startLoading();
    Response response = await repo.getPdfs(categoryId: categoryId, offset: 1, resourceType: ResourceType.free);
    if (response.statusCode != 200) {
      stopLoading();
      ApiChecker.checkApi(response);
    } else {
      try {
        final jsonResponse = json.decode(response.body);
        final List<dynamic> pdfList = jsonResponse['data']["list"];
        _pdfItemResponse = pdfList.map((json) => PdfResponse.fromJson(json)).toList();
        log("pdf list=======>${pdfItemResponse?.length}");
        stopLoading();
        notifyListeners();
      } catch (e) {
        showCustomSnackBar(AppConstants.WENT_WRONG, type: false);
        stopLoading();
      }
    }
  }
}
// final freeAllItemProvider = ChangeNotifierProvider<FreeAllItemNotifier>((ref) {
//   final repo = ref.watch(dashboardRepoProvider);
//   return FreeAllItemNotifier(repo);
// });
//
// class FreeAllItemNotifier extends AllResourceNotifier {
//   final DashboardRepo repo;
//   FreeAllItemNotifier(this.repo);
//
//   AllItem? _allItemResponse;
//   AllItem? get allItemResponse => _allItemResponse;
//   int? selectedIndex;
//   List<VideoModal> downloadedAudio = [];
//   List<VideoModal> downloadedVideo = [];
//   List<PdfModel> downloadedPDF = [];
//
//   @override
//   void toggleBookmark(int itemId, {bool notifier = true}) {
//     if (_allItemResponse == null || _allItemResponse!.list == null) {
//       return;
//     }
//     var itemIndex = _allItemResponse!.list!.indexWhere((element) => element.id == itemId);
//     if (itemIndex == -1) return;
//     _allItemResponse!.list![itemIndex].bookmarked = !(_allItemResponse!.list![itemIndex].bookmarked ?? true);
//     if (notifier) notifyListeners();
//   }
//
//   bool _loading = false;
//   bool get loading => _loading;
//   @override
//   void startLoading() {
//     _loading = true;
//     notifyListeners();
//   }
//
//   @override
//   void stopLoading() {
//     _loading = false;
//     notifyListeners();
//   }
//
//   @override
//   Future<void> fetchAudios(int categoryId) async {
//     startLoading();
//     Response response = await repo.getAudios(categoryId: categoryId, offset: 1, resourceType: ResourceType.free);
//     if (response.statusCode != 200) {
//       stopLoading();
//       ApiChecker.checkApi(response);
//     } else {
//       try {
//         var json = jsonDecode(response.body);
//         _allItemResponse = AllItem.fromJson(json['data'], true);
//         stopLoading();
//       } catch (e) {
//         showCustomSnackBar(AppConstants.WENT_WRONG, type: false);
//         stopLoading();
//       }
//     }
//   }
//
//   @override
//   Future<void> fetchVideos(int categoryId) async {
//     startLoading();
//     Response response = await repo.getVideos(categoryId: categoryId, offset: 1, resourceType: ResourceType.free);
//     if (response.statusCode != 200) {
//       stopLoading();
//       ApiChecker.checkApi(response);
//     } else {
//       try {
//         var json = jsonDecode(response.body);
//         _allItemResponse = AllItem.fromJson(json['data'], false);
//         stopLoading();
//       } catch (e) {
//         showCustomSnackBar(AppConstants.WENT_WRONG, type: false);
//         stopLoading();
//       }
//     }
//   }
//
//   @override
//   Future<void> fetchPDFs(int categoryId) async {
//     startLoading();
//     Response response = await repo.getPdfs(categoryId: categoryId, offset: 1, resourceType: ResourceType.free);
//     if (response.statusCode != 200) {
//       stopLoading();
//       ApiChecker.checkApi(response);
//     } else {
//       try {
//         var json = jsonDecode(response.body);
//         _allItemResponse = AllItem.fromJson(json['data'], false);
//         stopLoading();
//       } catch (e) {
//         showCustomSnackBar(AppConstants.WENT_WRONG, type: false);
//         stopLoading();
//       }
//     }
//   }
// }
