import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/provider/course_provider.dart';
import 'package:meditation_app/provider/download_provider.dart';
import 'package:meditation_app/provider/recent_videos_provider.dart';
import 'package:meditation_app/ui/screens/settings/widget/logout_dialog.dart';

import '../../../../../data/model/body/resource_type.dart';
import '../../../../../data/model/response/category_list_reponse.dart';
import '../../../../../data/model/response/videos_response.dart';
import '../../../../../provider/bookmark_provider.dart';
import '../../../../../provider/resource_provider/paid_videos_provider.dart';
import '../../../../../provider/video_provider.dart';
import '../../../../../theme/styles.dart';
import '../detail_item.dart';

class PaidVideoListWidget extends ConsumerStatefulWidget {
  final CategoryListResponse category;
  final bool isPurchased;

  const PaidVideoListWidget({super.key, required this.category,required this.isPurchased});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PaidVideoListWidgetState();
}

class _PaidVideoListWidgetState extends ConsumerState<PaidVideoListWidget>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _controller = ScrollController();
  static AppStyle _style = AppStyle();

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      print('______________________________________35__${widget.category.isPurchased}');
      if (!(widget.isPurchased)) {
        buyNow(context, categoryId: widget.category.id.toString());
      }
      ref.read(paidVideosProvider.notifier).fetchVideos(widget.category.id??0);
      initCall();
    });
    super.initState();
  }

  Future<void> initCall() async {
    ///to get downloaded video for if already downloaded then hide button so....
    // ref.read(paidVideosProvider).downloadedVideo = await ref.read(databaseProvider).getVideo(widget.category.id!);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> refreshh() async {
    Future.delayed(Duration.zero, () async {
      final coursePRead = ref.read(courseProvider);
      await coursePRead.getCategoryFromDatabase();
      await coursePRead.getVideoFromDatabase(widget.category.id ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _style = AppStyle(screenSize: MediaQuery.sizeOf(context));
    var provider = ref.watch(paidVideosProvider);

    if (provider.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.videosResponse == null ||
        provider.videosResponse!.list == null) {
      return const Center(child: Text('Unable to find data!'));
    }
    if (provider.videosResponse!.list!.isEmpty) {
      return const Center(child: Text('Paid Videos Is Empty'));
    }

    final downloadP = ref.watch(downloadProvider);

    if (downloadP.complate == true) {
      refreshh();
      ref.read(downloadProvider.notifier).complate = false;
      setState(() {});
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: _controller,
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.only(
        bottom: _style.scale * 100,
        top: _style.scale * 10,
      ),
      itemCount: provider.videosResponse!.list!.length,
      itemBuilder: (context, index) {
        var model = provider.videosResponse!.list![index];

        return GestureDetector(
          onTap: () {
            print('______________________________________103__${model.category?.isPurchased}');
            // if (model.category?.isPurchased??false) {
            if (model.category?.isPurchased??false) {
              playVideo(model);
            } else {
              buyNow(context, categoryId: widget.category.id.toString());
            }
          },
          child: DetailItem.video(
            appStyle: _style,
            model: model,
            index: '$index',
            isDownloaded: provider.downloadedVideo.any((element) =>
                element.id == provider.videosResponse?.list?[index].id),
            onToggleBookmark: () => toggleItemBookmark(model.id,
                isRemove: model.bookmarked ?? false),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) =>
          SizedBox(height: _style.scaleX(25)),
    );
  }

  void toggleItemBookmark(int? itemId, {bool isRemove = false}) {
    if (itemId == null) return;
    ref.read(bookmarkProvider).toggleBookmark(itemId, isRemove: isRemove);
    ref.read(paidVideosProvider.notifier).fetchVideos(widget.category.id??0);

  }

  void playVideo(VideoResponse model) {
    ref.read(videoProvider).playVideo(
          DetailedVideoModel(
            category: widget.category,
            video: DIModel(
              thumbnailUrl: model.imgUrl ?? '',
              videoUrl: model.videoUrl!,
              duration: model.duration ?? '',
              title: model.title ?? '',
              categoryName: widget.category.title ?? '',
              videoId: model.id!,
              videoType: model.videoType ?? ResourceType.paid,
            ),
          ),
        );
  }

  @override
  bool get wantKeepAlive => true;
}
