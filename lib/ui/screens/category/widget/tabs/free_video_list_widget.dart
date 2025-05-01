import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/provider/course_provider.dart';
import 'package:meditation_app/provider/download_provider.dart';
import 'package:meditation_app/provider/recent_videos_provider.dart';
import 'package:meditation_app/provider/resource_provider/free_audios_provider.dart';

import '../../../../../data/model/body/resource_type.dart';
import '../../../../../data/model/response/category_list_reponse.dart';
import '../../../../../data/model/response/videos_response.dart';
import '../../../../../database/database_helper.dart';
import '../../../../../database/database_model.dart';
import '../../../../../provider/bookmark_provider.dart';
import '../../../../../provider/resource_provider/free_videos_provider.dart';
import '../../../../../provider/video_provider.dart';
import '../../../../../theme/styles.dart';
import '../detail_item.dart';

class FreeVideoListWidget extends ConsumerStatefulWidget {
  final CategoryListResponse category;
  final bool isAudio;

  const FreeVideoListWidget({super.key, required this.category, required this.isAudio});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FreeVideoListWidgetState();
}

class _FreeVideoListWidgetState extends ConsumerState<FreeVideoListWidget> with AutomaticKeepAliveClientMixin {
  final ScrollController _controller = ScrollController();
  static AppStyle _style = AppStyle();

  @override
  void initState() {
    if (ref.read(videoProvider).video == null) {
      ref.read(videoProvider.notifier).isSelected = null;
      ref.read(videoProvider.notifier).selectedItemId = null;
    }
    if (widget.isAudio) {
      Future.delayed(Duration.zero, () async {
        ref.read(freeAudiosProvider.notifier).fetchAudios(widget.category.id ?? 0);
        await initCall();
      });
    } else {
      Future.delayed(Duration.zero, () async {
        // if(ref.read(videoProvider).video==null) {
        //   ref.read(videoProvider.notifier).isSelected = null;
        //   ref.read(videoProvider.notifier).selectedItemId = null;
        // }
        ref.read(freeVideosProvider.notifier).fetchVideos(widget.category.id ?? 0);
        await initCall();
      });
    }

    super.initState();
  }

  Future<void> initCall() async {
    var provider = ref.read(freeVideosProvider);
    var audioProvider = ref.read(freeAudiosProvider);

    ///to get downloaded video for if already downloaded then hide button so....
    CategoryModal? res = await ref.read(databaseProvider).getSingleCategory(widget.category.id!.toString());
    provider.downloadedVideo = await ref.read(databaseProvider).getVideo(int.parse(res?.categoryId ?? "0"));
    CategoryModal? res1 = await ref.read(databaseProvider).getAudioSingleCategory(widget.category.id!.toString());
    audioProvider.downloadedAudio = await ref.read(databaseProvider).getAudio(int.parse(res1?.categoryId ?? "0"));
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
    var provider = ref.watch(freeVideosProvider);
    var audioP = ref.watch(freeAudiosProvider);

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
        bool isDownloaded = false;
        if (!widget.isAudio) {
          isDownloaded = provider.downloadedVideo.any((element) {
            return model.id == int.parse(element.videoId ?? "0");
          });
        } else {
          isDownloaded = audioP.downloadedAudio.any((element) {
            log("~~~~aaaa~~~~>>>>${model.id}~~~~~${element.videoId}");
            return model.id == int.parse(element.videoId ?? "0");
          });
        }
        log("id in free video widget list----->${model.id}---$isDownloaded----${widget.isAudio}---");
        return GestureDetector(
            onTap: () {
              provider.selectedIndex = index;
              playVideo(model, provider.selectedIndex!);
            },
            child: DetailItem.video(
              appStyle: _style,
              isAudio: widget.isAudio,
              model: model,
              index: '$index',
              seletedItemId: model.id,
              // index: '${provider.selectedIndex}',
              onToggleBookmark: () {
                toggleItemBookmark(model.id, isRemove: model.bookmarked ?? false);
              },
              isDownloaded: isDownloaded,
            ));
      },
      separatorBuilder: (BuildContext context, int index) => SizedBox(height: _style.scaleX(25)),
    );
  }

  Future<void> toggleItemBookmark(int? itemId, {bool isRemove = false}) async {
    if (itemId == null) return;
    await ref.read(bookmarkProvider).toggleBookmark(itemId, isRemove: isRemove, isAudio: widget.isAudio);
    if (widget.isAudio) {
      ref.read(freeAudiosProvider.notifier).fetchAudios(widget.category.id ?? 0);
    } else {
      ref.read(freeVideosProvider.notifier).fetchVideos(widget.category.id ?? 0);
    }
  }

  void playVideo(VideoResponse model, int index) {
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
        index: index,
        isAudioFile: widget.isAudio);
  }

  @override
  bool get wantKeepAlive => true;
}
