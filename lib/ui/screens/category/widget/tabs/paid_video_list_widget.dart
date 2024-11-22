import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/provider/course_provider.dart';
import 'package:meditation_app/provider/download_provider.dart';
import 'package:meditation_app/provider/recent_videos_provider.dart';
import 'package:meditation_app/provider/resource_provider/paid_audios_provider.dart';
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
  final bool isAudio;

  const PaidVideoListWidget({super.key, required this.category,required this.isPurchased, required this.isAudio});

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
    if(ref.read(videoProvider).video==null) {
      ref.read(videoProvider.notifier).isSelected = null;
      ref.read(videoProvider.notifier).selectedItemId = null;
    }
    if(widget.isAudio){
      Future.delayed(Duration.zero, () async {
        ref.read(paidAudiosProvider.notifier).fetchAudios(widget.category.id??0);
        await initCall();
      });
    }else{
      Future.delayed(Duration.zero, () async {
        // if(ref.read(videoProvider).video==null) {
        //   ref.read(videoProvider.notifier).isSelected = null;
        //   ref.read(videoProvider.notifier).selectedItemId = null;
        // }
        ref.read(paidVideosProvider.notifier).fetchVideos(widget.category.id??0);
        await initCall();
      });
    }
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
      await coursePRead.getAudioCategoryFromDatabase();
      await coursePRead.getVideoFromDatabase(widget.category.id ?? 0);
      await coursePRead.getAudioFromDatabase(widget.category.id ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _style = AppStyle(screenSize: MediaQuery.sizeOf(context));
    var provider = ref.watch(paidVideosProvider);
    var audioP = ref.watch(paidAudiosProvider);

    if (provider.loading || audioP.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.isAudio ? (audioP.videosResponse == null || audioP.videosResponse!.list == null) : (provider.videosResponse == null || provider.videosResponse!.list == null)) {
      return const Center(child: Text('Unable to find data!'));
    }
    if (widget.isAudio ? audioP.videosResponse!.list!.isEmpty : provider.videosResponse!.list!.isEmpty) {
      return const Center(child: Text('Free Videos Is Empty'));
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
      itemCount: widget.isAudio ? audioP.videosResponse!.list!.length : provider.videosResponse!.list!.length,
      itemBuilder: (context, index) {
        var model = widget.isAudio ? audioP.videosResponse!.list![index] : provider.videosResponse!.list![index];
        bool isDownloaded=false;
        if(!widget.isAudio)
        {
          isDownloaded = provider.downloadedVideo.any((element) {
            return model.id == int.parse(element.videoId ?? "0");
          });
        }else{
          isDownloaded = audioP.downloadedAudio.any((element) {
            return model.id == int.parse(element.videoId ?? "0");
          });
        }
        return GestureDetector(
          onTap: () async {
            if (model.category?.isPurchased??false) {
              playVideo(model);
            } else {
              await buyNow(context, categoryId: widget.category.id.toString());
              provider.fetchVideos(widget.category.id ?? 0);
              audioP.fetchAudios(widget.category.id ?? 0);
            }
          },
          child: DetailItem.video(
            appStyle: _style,
            model: model,
            isAudio: widget.isAudio,
            seletedItemId: model.id,
            index: '$index',
            isDownloaded: isDownloaded,
            // isDownloaded: provider.downloadedVideo.any((element) =>
            // element.id == provider.videosResponse?.list?[index].id),
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
    ref.read(bookmarkProvider).toggleBookmark(itemId, isRemove: isRemove,isAudio: widget.isAudio);
    if(widget.isAudio){
      ref.read(paidAudiosProvider.notifier).fetchAudios(widget.category.id??0);
    }else{
      ref.read(paidVideosProvider.notifier).fetchVideos(widget.category.id??0);
    }

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
        isAudioFile: widget.isAudio
    );
  }

  @override
  bool get wantKeepAlive => true;
}
