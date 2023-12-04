import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:meditation_app/data/api/api_checker.dart';
import 'package:meditation_app/data/model/response/bookmark_list_response.dart';
import 'package:meditation_app/data/repositories/bookmark_repo.dart';
import 'package:meditation_app/provider/repo_provider/bookmark_repo_provider.dart';
import 'package:meditation_app/ui/common/custom_snackbar.dart';
import 'package:meditation_app/util/constants.dart';

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

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isToggleLoading = false;
  bool get isToggleLoading => _isToggleLoading;

  List<BookmarkListResponse>? _bookmarkListResponse;
  List<BookmarkListResponse>? get bookmarkListResponse => _bookmarkListResponse;

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
        _bookmarkListResponse = BookmarkListResponse.listFromJson(json['data']['bookmark_video_list']);
        stopLoading();
      } catch (e) {
        showCustomSnackBar(AppConstants.WENT_WRONG, type: false);
        stopLoading();
      }
    }
  }

  Future<void> toggleBookmark(int itemId, {bool isRemove = false}) async {
    showCustomSnackBar(isRemove ? 'Removing...' : 'Bookmarking...');
    startToggleLoading();
    Response response = await repo.toggleBookmark(itemId);
    if (response.statusCode != 200) {
      stopToggleLoading();
      ApiChecker.checkApi(response);
    } else {
      try {
        stopToggleLoading();
        ref.read(freeVideosProvider).toggleBookmark(itemId);
        ref.read(paidVideosProvider).toggleBookmark(itemId);
        showCustomSnackBar('${isRemove ? 'Removed' : 'Bookmarked'} Successful', type: true);
      } catch (e) {
        showCustomSnackBar(AppConstants.WENT_WRONG, type: false);
        stopToggleLoading();
      }
    }
  }
}
