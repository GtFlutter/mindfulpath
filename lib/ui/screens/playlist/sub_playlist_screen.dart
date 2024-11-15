import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/data/model/body/resource_type.dart';
import 'package:meditation_app/data/model/response/bookmark_list_response.dart';
import 'package:meditation_app/data/model/response/playlist_details_response.dart';
import 'package:meditation_app/provider/bookmark_provider.dart';
import 'package:meditation_app/provider/playlist_provider.dart';
import 'package:meditation_app/provider/recent_videos_provider.dart';
import 'package:meditation_app/provider/video_provider.dart';
import 'package:meditation_app/theme/colors.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/ui/common/custom_app_bar.dart';
import 'package:meditation_app/ui/common/media_player/app_audio_player.dart';
import 'package:meditation_app/ui/common/media_player/app_video_player.dart';
import 'package:meditation_app/ui/screens/category/widget/detail_item.dart';
import 'package:meditation_app/ui/screens/playlist/sub_playlist_item.dart';

import '../../../provider/course_provider.dart';
import '../../../provider/download_provider.dart';
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
  Duration? _lastKnownPosition;

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
        playlistP.getPlaylistDetails(widget.id, showProgress: true);
        ref.watch(videoProvider).clearVideo();
      },
    );
    super.initState();
  }

  Future<void> refreshh() async {
    log("playlist refresh...");
    Future.delayed(Duration.zero, () async {
      final coursePRead = ref.read(courseProvider);
      final coursePWatch = ref.watch(courseProvider);
      await coursePRead.getCategoryFromDatabase();
      for (final category in coursePWatch.downloadResponse) {
        await coursePRead.getVideoFromDatabase(int.parse(category.categoryId ?? ""));
      }
    });
  }

  @override
  void deactivate() {
    ref.read(videoProvider.notifier).isSelected = null;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    ref.read(bookmarkProvider.notifier).islandScap = false;
    super.deactivate();
  }

  Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
    const Color draggableItemColor = AppColors.primaryColor;

    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double elevation = lerpDouble(0, 6, animValue)!;

        return Padding(
          padding: EdgeInsets.only(bottom: _style.scaleX(12.5), top: _style.scaleX(12.5)),
          child: Material(
            elevation: elevation,
            color: draggableItemColor,
            shadowColor: draggableItemColor,
            borderRadius: BorderRadius.circular(_style.scaleX(25)),
            child: BookmarkItem.dragable(
              appStyle: _style,
              model: BookmarkListResponse(),
              index: index,
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
    var isVideoAvailable = videoCtrl.isAudioFileAvailable ? false : videoCtrl.video != null;
    var isAudioAvailable = videoCtrl.isAudioFileAvailable && videoCtrl.video != null;
    bool isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;

    final playlistP = ref.watch(playListProvider);
    final downloadP = ref.watch(downloadProvider);

    if (downloadP.complate == true) {
      refreshh();
      ref.read(downloadProvider.notifier).complate = false;
      setState(() {});
    }
    void playVideo(PlaylistVideoList model,int index) {
      print('------------****${model.video!.videoUrl}');
      ref.read(videoProvider).playVideo(
            DetailedVideoModel(
              video: DIModel(
                  thumbnailUrl: model.video != null ? model.video!.thumbnailImageUrlSrc ?? '' : '',
                  videoUrl: model.video?.videoUrl ?? "",
                  duration: model.video?.duration ?? "",
                  title: model.video?.title ?? '',
                  categoryName: model.categoryTitle ?? '',
                  videoId: model.videoId ?? 0,
                  videoType: ResourceType.paid),
            ),
        index: index,
        isAudioFile: model.video!.videoUrlSrc!.split('.').last.contains('mp3')
          );
    }

    return Scaffold(
      appBar: isLandscape && isVideoAvailable
          ? null
          : CustomAppBar(
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
              : playlistP.playlistDetailResponse == null || playlistP.playlistDetailResponse!.data!.playlistVideoList!.isEmpty
                  ? const Center(child: Text('No Data Found'))
                  : Padding(
                      padding: isLandscape && isVideoAvailable ? EdgeInsets.zero : EdgeInsets.symmetric(horizontal: _style.scaleX(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (isVideoAvailable) ...[
                            if (!isLandscape) SizedBox(height: _style.scaleX(25)),
                            Flexible(
                              flex: isLandscape ? 1 : 0,
                              child: Container(
                                width: !isLandscape ? null : double.infinity,
                                height: !isLandscape ? null : double.infinity,
                                alignment: !isLandscape ? null : Alignment.topCenter,
                                constraints: !isLandscape ? BoxConstraints(maxHeight: size.height * 0.4) : null,
                                child: AppVideoPlayer(
                                  isLandscape: isLandscape,
                                  key: const ValueKey('value'),
                                  videoId: videoCtrl.video!.videoId,
                                  url: videoCtrl.video!.videoUrl,
                                  duration: videoCtrl.video!.duration,
                                  style: _style,
                                  startPosition: _lastKnownPosition ?? Duration.zero,
                                  onPositionChanged: (position) {
                                    _lastKnownPosition = position;
                                  },
                                  // isLandscape: isLandscape,
                                  onBackPress: () {
                                    if (MediaQuery.orientationOf(context) == Orientation.landscape) {
                                      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                                    }
                                    ref.read(videoProvider.notifier).isSelected = null;
                                    ref.read(bookmarkProvider.notifier).islandScap = false;

                                    videoCtrl.clearVideo();
                                  },
                                  isFileUrl: false,
                                  onFullScreen: () {
                                    if (MediaQuery.orientationOf(context) == Orientation.portrait) {
                                      ref.read(bookmarkProvider.notifier).islandScap = true;
                                      final temp = ref.read(videoProvider);
                                      temp.isVideoChanged=false;
                                      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
                                    } else {
                                      ref.read(bookmarkProvider.notifier).islandScap = false;
                                      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                                    }
                                  },
                                ),
                              ),
                            )
                          ] else if(isAudioAvailable)...[
                            AppAudioPlayer(
                              style: _style,
                              duration: videoCtrl.video!.duration,
                              audioId: videoCtrl.video!.videoId,
                              audioUrl: videoCtrl.video!.videoUrl,
                              audioImage: videoCtrl.video!.thumbnailUrl,
                            ),
                            SizedBox(height: _style.scaleX(24)),
                          ] else
                            const SizedBox.shrink(),
                          !isLandscape
                              ? Expanded(
                                  child: Column(
                                    children: [
                                      Theme(
                                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                        child: ExpansionTile(title: const Text("Videos"),
                                          children: [
                                            if(playlistP.playlistVideoListResponse?.isNotEmpty ?? false)...[SizedBox(height:300,
                                              child: ListView.separated(
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                padding: EdgeInsets.only(
                                                  top: _style.scale * 12.5,
                                                  right: _style.scale * 10,
                                                  left: _style.scale * 10,
                                                ),
                                                itemCount: playlistP.playlistVideoListResponse?.length ?? 0,
                                                itemBuilder: (context, index) {
                                                  var model = playlistP.playlistVideoListResponse?[index];

                                                  return GestureDetector(
                                                    //key: Key('$index'),
                                                      onTap: () {
                                                        //playVideo(model);
                                                      },
                                                      child: SubPlayListItem(
                                                        key: Key('$index'),
                                                        appStyle: _style,
                                                        model: model!,
                                                        onPlay: () {
                                                          ref.read(videoProvider.notifier).isSelected = index;
                                                          playVideo(model,index);
                                                          FocusManager.instance.primaryFocus?.unfocus();
                                                        },
                                                        onRemovePress: () async {
                                                          await playlistP.removeFromPlaylist((model.playlistId ?? 0).toString(), (model.video?.id ?? 0).toString(), model.video!.videoUrlSrc!.split('.').last.contains('mp3')); // TODO ::: CHANGES REQUIRED
                                                          playlistP.getPlaylistDetails(model.playlistId ?? 0, showProgress: true);
                                                        },
                                                        index: index,
                                                        url: model.video?.videoUrl ?? "",
                                                      ));
                                                },
                                                separatorBuilder: (BuildContext context, int index) => SizedBox(height: _style.scaleX(25)),
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
                                            ),]else...[const Text("Data Not Available")],

                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Theme(
                                          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                          child: ExpansionTile(title: const Text("Audios"),
                                            children: [
                                              if(playlistP.playlistAudioListResponse?.isNotEmpty ?? false)...[ ListView.separated(
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                padding: EdgeInsets.only(
                                                  top: _style.scale * 12.5,
                                                  right: _style.scale * 10,
                                                  left: _style.scale * 10,
                                                ),
                                                itemCount: playlistP.playlistAudioListResponse?.length ?? 0,
                                                itemBuilder: (context, index) {
                                                  var model = playlistP.playlistAudioListResponse?[index];

                                                  return GestureDetector(
                                                    //key: Key('$index'),
                                                      onTap: () {
                                                        //playVideo(model);
                                                      },
                                                      child: SubPlayListItem(
                                                        key: Key('$index'),
                                                        appStyle: _style,
                                                        model: model!,
                                                        onPlay: () {
                                                          ref.read(videoProvider.notifier).isSelected = index;
                                                          playVideo(model,index);
                                                          FocusManager.instance.primaryFocus?.unfocus();
                                                        },
                                                        onRemovePress: () async {
                                                          await playlistP.removeFromPlaylist((model.playlistId ?? 0).toString(), (model.video?.id ?? 0).toString(), model.video!.videoUrlSrc!.split('.').last.contains('mp3')); // TODO ::: CHANGES REQUIRED
                                                          playlistP.getPlaylistDetails(model.playlistId ?? 0, showProgress: true);
                                                        },
                                                        index: index,
                                                        url: model.video?.videoUrl ?? "",
                                                      ));
                                                },
                                                separatorBuilder: (BuildContext context, int index) => SizedBox(height: _style.scaleX(25)),
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
                                              ),]else...[const Text("Data Not Available")],

                                            ],
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}
