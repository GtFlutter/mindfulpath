import 'dart:convert';
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

  bool islandScap=false;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isToggleLoading = false;
  bool get isToggleLoading => _isToggleLoading;

  List<BookmarkListResponse>? _bookmarkListResponse;
  List<BookmarkListResponse>? get bookmarkListResponse => _bookmarkListResponse;

  List<CategoryListResponse>? _category;
  List<CategoryListResponse>? get category => _category;


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
        _category = CategoryListResponse.listFromJson(json['data']['bookmark_video_list']);
        print('------------>>>>>${_category!.first.id}');
        stopLoading();
      } catch (e) {
        //showCustomSnackBar(AppConstants.WENT_WRONG, type: false);
        stopLoading();
      }
    }
  }

  Future<void> toggleBookmark(int itemId, {bool isRemove = false}) async {
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

    showCustomSnackBar(isRemove ? 'UnBookmarking...' : 'Bookmarking...');
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
        ref.read(featuredVideosProvider).toggleBookmark(itemId);
        showCustomSnackBar('${isRemove ? 'UnBookmarked' : 'Bookmarked'} Successful', type: true);
      } catch (e) {
        showCustomSnackBar(AppConstants.WENT_WRONG, type: false);
        stopToggleLoading();
      }
    }
  }
}
