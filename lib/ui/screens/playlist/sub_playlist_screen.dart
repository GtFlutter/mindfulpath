import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/data/model/body/resource_type.dart';
import 'package:meditation_app/data/model/response/bookmark_list_response.dart';
import 'package:meditation_app/data/model/response/playlist_details_response.dart';
import 'package:meditation_app/provider/playlist_provider.dart';
import 'package:meditation_app/provider/recent_videos_provider.dart';
import 'package:meditation_app/provider/video_provider.dart';
import 'package:meditation_app/theme/colors.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/ui/common/custom_app_bar.dart';
import 'package:meditation_app/ui/common/media_player/app_video_player.dart';
import 'package:meditation_app/ui/screens/category/widget/detail_item.dart';
import 'package:meditation_app/ui/screens/playlist/sub_playlist_item.dart';

import '../../../theme/styles.dart';
import '../bookmark/widget/bookmark_item.dart';

class SubPlayListScreenData {
  int? id;
  String? title;

  SubPlayListScreenData({this.id, this.title});
}

class SubPlayListScreen extends ConsumerStatefulWidget {
  final int id;
  final String title;

  const SubPlayListScreen({super.key, required this.id, required this.title});

  @override
  ConsumerState<SubPlayListScreen> createState() => _SubPlayListScreenState();
}

class _SubPlayListScreenState extends ConsumerState<SubPlayListScreen> {
  static AppStyle _style = AppStyle();

  //late List<DIModel> _items;
  @override
  void initState() {
    //_items = [];
    //_items.addAll(TempData.listDiModel);
    final playlistP = ref.read(playListProvider);
    print('------------->>>>>===${widget.id}');
    Future.delayed(
      Duration.zero,
      () {
        playlistP.getPlaylistDetails(widget.id,showProgress: true);

        ref.watch(videoProvider).clearVideo();

      },
    );
    super.initState();
  }

  Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
    const Color draggableItemColor = AppColors.primaryColor;

    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double elevation = lerpDouble(0, 6, animValue)!;

        return Padding(
          padding: EdgeInsets.only(
              bottom: _style.scaleX(12.5), top: _style.scaleX(12.5)),
          child: Material(
            elevation: elevation,
            color: draggableItemColor,
            shadowColor: draggableItemColor,
            borderRadius: BorderRadius.circular(_style.scaleX(25)),
            child: BookmarkItem.dragable(
              appStyle: _style,
              model: BookmarkListResponse(),
              index: '$index',
              dragging: true,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _style = AppStyle(screenSize: size);
    var videoCtrl = ref.watch(videoProvider);
    var isVideoAvailable = videoCtrl.video != null;
    bool isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;


    final playlistP = ref.watch(playListProvider);
    void playVideo(PlaylistVideoList model) {
      print(
          '------------****${model.video!.videoUrl}');
      ref.read(videoProvider).playVideo(
        DetailedVideoModel(
          video: DIModel(
            thumbnailUrl: model.video?.thumbnailImageUrl ?? '',
            videoUrl: model.video?.videoUrl??"",
            duration: "10",
            title: model.video?.title ?? '',
            categoryName:model.categoryTitle ?? '',
            videoId: model.videoId??0,
            videoType: ResourceType.paid
          ),
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        screenSize: size,
        style: _style,
        title: widget.title,
      ),
      extendBodyBehindAppBar: true,
      body: BackgroundImage(
        child: SafeArea(
          bottom: false,
          child: playlistP.isLoading
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : playlistP.playlistDetailResponse == null ||
              playlistP.playlistDetailResponse!.data!.playlistVideoList!.isEmpty
              ? const Center(child: Text('No Data Found'))
              : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if(isVideoAvailable)...[
                if (!isLandscape) SizedBox(height: _style.scaleX(25)),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Container(
                      width: !isLandscape ? null : double.infinity,
                      height: !isLandscape ? null : double.infinity,
                      alignment: !isLandscape ? null : Alignment.topCenter,
                      constraints: !isLandscape ? BoxConstraints(maxHeight: size.height * 0.4) : null,
                      child: AppVideoPlayer(
                        key: const ValueKey('value'),
                        videoId: videoCtrl.video!.videoId,
                        url: videoCtrl.video!.videoUrl,
                        style: _style,
                        isLandscape: isLandscape,
                        onBackPress: () {
                          if (MediaQuery.orientationOf(context) == Orientation.landscape) {
                            SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                          }
                          videoCtrl.clearVideo();
                        },
                        isFileUrl: false,
                        onFullScreen: () {
                          if (MediaQuery.orientationOf(context) == Orientation.portrait) {
                            SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
                          } else {
                            SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                          }
                        },
                      ),
                    ),
                  ),
                )]else const SizedBox.shrink(),

              !isLandscape?SizedBox(
                height: 500,
                width: double.infinity,
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.only(
                    bottom: _style.scale * 100,
                    top: _style.scale * 12.5,
                    right: _style.scale * 22,
                    left: _style.scale * 22,
                  ),
                  itemCount: playlistP
                          .playlistDetailResponse?.data?.playlistVideoList?.length ??
                      0,
                  itemBuilder: (context, index) {
                    var model = playlistP
                        .playlistDetailResponse?.data?.playlistVideoList?[index];

                    return GestureDetector(
                        key: Key('$index'),
                        onTap: () {

                          playVideo(model);

                        },
                        child: SubPlayListItem(
                          appStyle: _style,
                          model: model!,
                          index: index,
                          url: model.video?.videoUrl??"",
                        ));
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(height: _style.scaleX(25)),
                  /* onReorder: (int oldIndex, int newIndex) {
                    setState(() {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      final DIModel item = playlistP.playlistDetailResponse.removeAt(oldIndex);
                      _items.insert(newIndex, item);
                    });
                  },*/
                  // separatorBuilder: (BuildContext context, int index) => SizedBox(height: _style.scaleX(25)),
                ),
              ):const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
