import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:meditation_app/data/api/api_checker.dart';
import 'package:meditation_app/data/model/response/bookmark_list_response.dart';
import 'package:meditation_app/data/model/response/category_list_reponse.dart';
import 'package:meditation_app/data/repositories/bookmark_repo.dart';
import 'package:meditation_app/helper/route/router.dart';
import 'package:meditation_app/provider/auth_provider.dart';
import 'package:meditation_app/provider/featured_videos_provider.dart';
import 'package:meditation_app/provider/repo_provider/bookmark_repo_provider.dart';
import 'package:meditation_app/provider/resource_provider/free_all_item_list_provider.dart';
import 'package:meditation_app/provider/resource_provider/free_audios_provider.dart';
import 'package:meditation_app/provider/resource_provider/free_pdfs_provider.dart';
import 'package:meditation_app/provider/resource_provider/paid_all_item_list_provider.dart';
import 'package:meditation_app/provider/resource_provider/paid_audios_provider.dart';
import 'package:meditation_app/provider/resource_provider/paid_pdfs_provider.dart';
import 'package:meditation_app/theme/colors.dart';
import 'package:meditation_app/ui/common/custom_snackbar.dart';
import 'package:meditation_app/util/constants.dart';

import '../helper/route/route_paths.dart';
import 'resource_provider/free_videos_provider.dart';
import 'resource_provider/paid_videos_provider.dart';

final bookmarkProvider = ChangeNotifierProvider<BookmarkNotifier>((ref) {
  final repo = ref.watch(bookmarkRepoProvider);
  return BookmarkNotifier(repo, ref);
});

class BookmarkNotifier extends ChangeNotifier {
  BookmarkRepo repo;
  ChangeNotifierProviderRef<BookmarkNotifier> ref;

  BookmarkNotifier(this.repo, this.ref);

  int? isSelected;

  bool islandScap = false;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool _isToggleLoading = false;

  bool get isToggleLoading => _isToggleLoading;

  List<BookmarkListResponse>? _bookmarkListResponse;

  List<BookmarkListResponse>? get bookmarkListResponse => _bookmarkListResponse;

  List<BookmarkListResponse>? _bookmarkAudioListResponse;

  List<BookmarkListResponse>? get bookmarkAudioListResponse => _bookmarkAudioListResponse;

  List<BookmarkPDFListResponse>? _bookmarkPDFListResponse;

  List<BookmarkPDFListResponse>? get bookmarkPDFListResponse => _bookmarkPDFListResponse;

  List<CategoryListResponse>? _category;

  List<CategoryListResponse>? get category => _category;

  List<CategoryListResponse>? _audioCategory;

  List<CategoryListResponse>? get audioCategory => _audioCategory;

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

  void startToggleLoading() {
    if (!_isToggleLoading) {
      _isToggleLoading = true;
      notifyListeners();
    }
  }

  void stopToggleLoading() {
    if (_isToggleLoading) {
      _isToggleLoading = false;
      notifyListeners();
    }
  }

  Future<void> getBookmarkList() async {
    startLoading();
    Response response = await repo.getBookmarks();
    debugPrint('RESPONSE CODE :: ${response.statusCode}');
    if (response.statusCode != 200) {
      stopLoading();
      ApiChecker.checkApi(response);
    } else {
      try {
        var json = jsonDecode(response.body);
        _bookmarkListResponse?.clear();
        _bookmarkListResponse = BookmarkListResponse.listFromJson(json['data']['bookmark_video_list'], false);
        log("video list---->-----${_bookmarkListResponse?.length}");
        for (int i = 0; i <= (_bookmarkListResponse?.length ?? 0); i++) {
          if (_bookmarkListResponse?[i].bookmarkVideoResponse == null) {
            log("vedio deleted");
            _bookmarkListResponse?.removeAt(i);
          } else {
            log("else part");
          }
        }
        notifyListeners();
        _category = CategoryListResponse.listFromJson(json['data']['bookmark_video_list']);
        print('-----video category in bookmark------->>>>>${_category!.first.id}');
        stopLoading();
      } catch (e) {
        //showCustomSnackBar(AppConstants.WENT_WRONG, type: false);
        stopLoading();
      }
    }
  }

  Future<void> getAudioBookmarks() async {
    startLoading();
    Response response = await repo.getAudioBookmarks();
    debugPrint('RESPONSE CODE :: ${response.statusCode}');
    if (response.statusCode != 200) {
      stopLoading();
      ApiChecker.checkApi(response);
    } else {
      try {
        var json = jsonDecode(response.body);
        // _bookmarkListResponse = BookmarkListResponse.listFromJson(json['data']['bookmark_audio_list'], false);
        _bookmarkAudioListResponse?.clear();
        _bookmarkAudioListResponse = BookmarkListResponse.listFromJson(json['data']['bookmark_audio_list'], false);
        for (int i = 0; i <= (bookmarkAudioListResponse?.length ?? 0); i++) {
          if (bookmarkAudioListResponse?[i].bookmarkVideoResponse == null) {
            log("audio deleted");
            bookmarkAudioListResponse?.removeAt(i);
          } else {
            log("-else");
          }
        }
        notifyListeners();
        _audioCategory = CategoryListResponse.listFromJson(json['data']['bookmark_audio_list']["audio"]["category"]);
        print('--------audio category in bookmark---->>>>>${_audioCategory!.first.id}');
        stopLoading();
      } catch (e) {
        //showCustomSnackBar(AppConstants.WENT_WRONG, type: false);
        stopLoading();
      }
    }
  }

  Future<void> getPDFBookmarks() async {
    startLoading();
    Response response = await repo.getPDFBookmarks();
    debugPrint('RESPONSE CODE :: ${response.statusCode}');
    if (response.statusCode != 200) {
      stopLoading();
      ApiChecker.checkApi(response);
    } else {
      try {
        var json = jsonDecode(response.body);
        _bookmarkPDFListResponse?.clear();
        _bookmarkPDFListResponse = BookmarkPDFListResponse.listFromJson(json['data']['bookmark_pdf_list'], false);
        for (int i = 0; i <= (_bookmarkPDFListResponse?.length ?? 0); i++) {
          if (_bookmarkPDFListResponse?[i].bookmarkPdfResponse == null) {
            log("audio deleted");
            _bookmarkPDFListResponse?.removeAt(i);
          } else {
            log("-else");
          }
        }
        notifyListeners();
        stopLoading();
      } catch (e) {
        //showCustomSnackBar(AppConstants.WENT_WRONG, type: false);
        stopLoading();
      }
    }
  }

  Future<void> toggleBookmark(int itemId, {bool isRemove = false, bool isAudio = false, bool isPDF = false}) async {
    if (!ref.read(authProvider).isUserLoggedIn) {
      showCustomSnackBar(
        'Please login to bookmark.',
        action: SnackBarAction(
          label: 'Log In',
          backgroundColor: AppColors.primaryColor.withOpacity(0.8),
          textColor: Colors.brown.shade800,
          onPressed: () => appRouter.go(RoutePath.signIn),
        ),
        duration: const Duration(seconds: 5),
      );
      return;
    }

    log("-------->bookmark params---itemid-->$itemId--isAudio--->$isAudio---->isRemove--->$isRemove");

    showCustomSnackBar(isRemove ? 'UnBookmarking...' : 'Bookmarking...');
    startToggleLoading();

    Response response = await repo.toggleBookmark(itemId, isAudio, isPDF);
    if (response.statusCode != 200) {
      stopToggleLoading();
      ApiChecker.checkApi(response);
    } else {
      try {
        stopToggleLoading();
        if (isAudio) {
          ref.read(freeAudiosProvider).toggleBookmark(itemId);
          ref.read(paidAudiosProvider).toggleBookmark(itemId);
        } else if (isPDF) {
          ref.read(freePdfsProvider).toggleBookmark(itemId);
          ref.read(paidPdfsProvider).toggleBookmark(itemId);
        } else {
          ref.read(freeVideosProvider).toggleBookmark(itemId);
          ref.read(paidVideosProvider).toggleBookmark(itemId);
          ref.read(featuredVideosProvider).toggleBookmark(itemId);
        }
        ref.read(freeAllItemProvider).toggleBookmark(itemId);
        ref.read(paidAllItemProvider).toggleBookmark(itemId);
        // showCustomSnackBar('${isRemove ? 'UnBookmarked' : 'Bookmarked'} Successful', type: true);
        final json = jsonDecode(response.body);
        showCustomSnackBar(json["message"], type: true);
      } catch (e) {
        showCustomSnackBar(AppConstants.WENT_WRONG, type: false);
        stopToggleLoading();
      }
    }
  }
}
