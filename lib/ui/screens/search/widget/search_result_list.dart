import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/data/model/response/videos_response.dart';
import 'package:meditation_app/provider/bookmark_provider.dart';
import 'package:meditation_app/provider/dashboard_provider.dart';
import 'package:meditation_app/ui/screens/category/widget/detail_item.dart';

import '../../../../data/model/body/resource_type.dart';
import '../../../../data/model/response/category_list_reponse.dart';
import '../../../../provider/auth_provider.dart';
import '../../../../provider/recent_videos_provider.dart';
import '../../../../provider/video_provider.dart';
import '../../../../theme/styles.dart';
import '../../../common/custom_snackbar.dart';
import '../../settings/widget/logout_dialog.dart';
import '../util/query_time.dart';

class SearchResultsList extends ConsumerWidget {
  const SearchResultsList({super.key, required AppStyle style, required VideosResponse model})
      : _style = style,
        _model = model;

  final AppStyle _style;
  final VideosResponse _model;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            playVideo(_model.list![index], _model.list?[index].category ?? CategoryListResponse(), ref,context);
            // context.goToDetailCategoryScreen(
            //     _model[index].category!,
            //     video: DIModel(
            //         videoType: _model[index].videoType!,
            //         videoId: _model[index].id!,
            //         thumbnailUrl: _model[index].thumbnailImageUrlSrc!,
            //         videoUrl: _model[index].videoUrl!,
            //         duration: _model[index].duration!,
            //         title: _model[index].title!,
            //         categoryName: _model[index].categoryTitle!
            //     ));
          },
          child: DetailItem.video(
            appStyle: _style,
            model: _model.list![index],
            index: '$index',
            onToggleBookmark: () => toggleItemBookmark(ref, _model.list?[index].video?.id, isRemove: _model.list?[index].bookmarked ?? false),
            isDownloaded: false,
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => SizedBox(
        height: _style.scaleX(25),
      ),
    );
  }

  Future<void> playVideo(VideoResponse videoResponse, CategoryListResponse category, WidgetRef ref, BuildContext context) async {
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
    if (detailedVideoModel.video.videoType == ResourceType.paid && !isLoggedIn) {
      showCustomSnackBar('Login to access video', type: false);
      // appRouter.push(RoutePath.signIn);
      return;
    }else if(!(category.isPurchased ?? false)){
       buyNow(context, categoryId: category.id.toString(),isFromSearch: true);

    }else{
    ref.read(videoProvider).playVideo(detailedVideoModel);}
  }

  void toggleItemBookmark(WidgetRef ref, int? itemId, {bool isRemove = false}) {
    if (itemId == null) return;
    ref.read(bookmarkProvider).toggleBookmark(itemId, isRemove: isRemove);
  }
}
