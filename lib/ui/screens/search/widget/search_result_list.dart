import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/data/model/response/videos_response.dart';
import 'package:meditation_app/provider/bookmark_provider.dart';
import 'package:meditation_app/provider/dashboard_provider.dart';
import 'package:meditation_app/ui/screens/category/widget/detail_item.dart';

import '../../../../data/model/body/resource_type.dart';
import '../../../../data/model/response/category_list_reponse.dart';
import '../../../../helper/route/route_paths.dart';
import '../../../../helper/route/router.dart';
import '../../../../provider/auth_provider.dart';
import '../../../../provider/recent_videos_provider.dart';
import '../../../../provider/video_provider.dart';
import '../../../../theme/colors.dart';
import '../../../../theme/styles.dart';
import '../../../common/custom_snackbar.dart';
import '../../settings/widget/logout_dialog.dart';

class SearchResultsList extends ConsumerWidget {
  const SearchResultsList({super.key, required AppStyle style, required VideosResponse model,required this.onRefreshSearch})
      : _style = style,
        _model = model;

  final AppStyle _style;
  final VideosResponse _model;
  final Future<void> Function() onRefreshSearch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if(_model.list?.isEmpty ?? true){
return const Center(child: Text("Search Result Not Found"));    }
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.only(
        bottom: _style.scale * 100,
        top: _style.scale * 20,
      ),
      // itemCount: TempData.listDiModel.length,
      itemCount: _model.list?.length ?? 0,
      itemBuilder: (context, index) {
        // return const SizedBox.shrink();

        /// TODO : Workign On it
        return GestureDetector(
          onTap: () {
            ref.read(videoProvider.notifier).isSelected = index;
            playVideo(_model.list![index], _model.list?[index].category ?? CategoryListResponse(), ref, context);
            ref.read(dashboardProvider.notifier).selectedSearchIndex = index;
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: DetailItem.video(
              appStyle: _style,
              model: _model.list![index],
              index: '$index',
              onToggleBookmark: () => toggleItemBookmark(ref, _model.list?[index].id,
                  isRemove: _model.list?[index].bookmarked ?? false),
              isDownloaded: false,
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => SizedBox(
        height: _style.scaleX(25),
      ),
    );
  }

  Future<void> playVideo(
      VideoResponse videoResponse, CategoryListResponse category, WidgetRef ref, BuildContext context) async {
    final detailedVideoModel = DetailedVideoModel(
      category: category,
      video: DIModel(
        thumbnailUrl: videoResponse.imgUrl ?? '',
        videoUrl: videoResponse.videoUrl!,
        duration: videoResponse.duration ?? '',
        title: videoResponse.title ?? '',
        categoryName: videoResponse.title ?? '',
        videoId: videoResponse.id!,
        videoType: videoResponse.videoType ?? ResourceType.paid,
      ),
    );
    bool isLoggedIn = ref.read(authProvider).isUserLoggedIn;
    log("featureed vedio free or not --->${detailedVideoModel.video.videoType}");
    if (detailedVideoModel.video.videoType == ResourceType.paid && !isLoggedIn) {
      showCustomSnackBar('Sign In to access Plus Content', type: false);
      // appRouter.push(RoutePath.signIn);
      return;
    } else if (!(category.isPurchased ?? false) && videoResponse.videoType==ResourceType.paid) {
      buyNow(context, categoryId: category.id.toString(), isFromSearch: true);
    } else {
      ref.read(videoProvider.notifier).isVideoChanged=true;
      ref.read(videoProvider).playVideo(detailedVideoModel);
    }
  }

  Future<void> toggleItemBookmark(WidgetRef ref, int? itemId, {bool isRemove = false}) async {
    bool isLoggedIn = ref.read(authProvider).isUserLoggedIn;
    if(!isLoggedIn){
      showCustomSnackBar(
        'Please Sign in to Bookmark',
        action: SnackBarAction(
          label: 'Sign in',
          backgroundColor: AppColors.primaryColor.withOpacity(0.8),
          textColor: Colors.brown.shade800,
          onPressed: () => appRouter.go(RoutePath.signIn),
        ),
        duration: const Duration(seconds: 5),
      );
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    if (itemId == null) return;
   await ref.read(bookmarkProvider).toggleBookmark(itemId, isRemove: isRemove);
    // 🔹 Refresh search list after bookmark change
    log("======bookmmmaarkkkk");
    await onRefreshSearch();

  }
}
