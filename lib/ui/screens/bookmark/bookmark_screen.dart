import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/data/model/body/resource_type.dart';
import 'package:meditation_app/data/model/response/bookmark_list_response.dart';
import 'package:meditation_app/data/model/response/category_list_reponse.dart';
import 'package:meditation_app/provider/bookmark_provider.dart';
import 'package:meditation_app/provider/course_provider.dart';
import 'package:meditation_app/provider/download_provider.dart';
import 'package:meditation_app/provider/recent_videos_provider.dart';
import 'package:meditation_app/provider/video_provider.dart';
import 'package:meditation_app/theme/text_style.dart';
import 'package:meditation_app/ui/common/media_player/app_audio_player.dart';
import 'package:meditation_app/ui/common/media_player/app_video_player.dart';
import 'package:meditation_app/ui/screens/bookmark/widget/bookmark_item.dart';
import 'package:meditation_app/ui/screens/category/widget/detail_item.dart';

import '../../../theme/styles.dart';

class BookmarkScreen extends ConsumerStatefulWidget {
  const BookmarkScreen({super.key});

  @override
  ConsumerState<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends ConsumerState<BookmarkScreen> {
  static AppStyle _style = AppStyle();
  Duration? _lastKnownPosition;

  bool showAudioFile = false;

  @override
  void initState() {
    final bookmarkNotifier = ref.read(bookmarkProvider);
    Future.delayed(Duration.zero, () {
      log("init call with mode change");
      bookmarkNotifier.getBookmarkList();
      ref.watch(videoProvider).clearVideo();
    });
    super.initState();
  }

  @override
  void deactivate() {
    ref.read(videoProvider.notifier).isSelected = null;
    super.deactivate();
  }

  Future<void> refreshh() async {
    log("bookmark refresh...");
    Future.delayed(Duration.zero, () async {
      final coursePRead = ref.read(courseProvider);
      final coursePWatch = ref.watch(courseProvider);
      await coursePRead.getCategoryFromDatabase();
      for (final category in coursePWatch.downloadResponse) {
        await coursePRead.getVideoFromDatabase(int.parse(category.categoryId ?? ""));
      }
    });
  }

  void playVideo(
    BookmarkListResponse bookmarkListResponse,
    CategoryListResponse category,
    int index,
      bool isAudioFile
  ) {
    print('------------****${bookmarkListResponse.bookmarkVideoResponse!.videoUrl}');
    ref.read(videoProvider).playVideo(
          DetailedVideoModel(
            category: category,
            video: DIModel(
              thumbnailUrl: bookmarkListResponse.bookmarkVideoResponse!.imgUrl ?? '',
              videoUrl: bookmarkListResponse.bookmarkVideoResponse!.videoUrl!,
              duration: bookmarkListResponse.bookmarkVideoResponse?.duration ?? '',
              title: bookmarkListResponse.bookmarkVideoResponse!.title ?? '',
              categoryName: bookmarkListResponse.bookmarkVideoResponse!.title ?? '',
              videoId: bookmarkListResponse.bookmarkVideoResponse!.id!,
              videoType: bookmarkListResponse.bookmarkVideoResponse!.videoType ?? ResourceType.paid,
            ),
          ),
          index: index,
      isAudioFile: isAudioFile
        );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _style = AppStyle(screenSize: size);
    bool isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;

    var videoCtrl = ref.watch(videoProvider);
    var isVideoAvailable = videoCtrl.isAudioFileAvailable ? false : videoCtrl.video != null;
    var isAudioAvailable = videoCtrl.isAudioFileAvailable && videoCtrl.video != null;

    final bookmarkNotifier = ref.watch(bookmarkProvider);
    final downloadP = ref.watch(downloadProvider);
    if (downloadP.complate == true) {
      refreshh();
      ref.read(downloadProvider.notifier).complate = false;
      setState(() {});
    }
    return SafeArea(
      left: false,
      right: false,
      bottom: false,
      child: bookmarkNotifier.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : bookmarkNotifier.bookmarkListResponse == null || bookmarkNotifier.bookmarkListResponse!.isEmpty
              ? const Center(child: Text('No Data Found'))
              : Padding(
                  padding: isLandscape && isVideoAvailable ? EdgeInsets.zero : EdgeInsets.symmetric(horizontal: _style.scaleX(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Video',
                            style: _style.text.font(mulishSemiBold600, sizePx: 14, color: Colors.white),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: SizedBox(
                              height: _style.scaleX(40),
                              child: FittedBox(
                                fit: BoxFit.fill,
                                child: Switch(
                                  value: showAudioFile,
                                  onChanged: (value) {
                                    showAudioFile = value;
                                    if(value){
                                      bookmarkNotifier.getAudioBookmarks();
                                    }else{
                                      bookmarkNotifier.getBookmarkList();
                                    }
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                          ),
                          Text(
                            'Audio',
                            style: _style.text.font(mulishSemiBold600, sizePx: 14, color: Colors.white),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
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
                              // isLandscape: isLandscape,
                              onBackPress: () {
                                if (MediaQuery.orientationOf(context) == Orientation.landscape) {
                                  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                                }
                                ref.read(videoProvider.notifier).isSelected = null;
                                ref.read(bookmarkProvider.notifier).islandScap = false;

                                videoCtrl.clearVideo();
                              },
                              startPosition: _lastKnownPosition ?? Duration.zero,
                              onPositionChanged: (position) {
                                _lastKnownPosition = position;
                              },
                              isFileUrl: false,
                              onFullScreen: () async {
                                log("isVideoChange--->${videoCtrl.isVideoChanged}");
                                if (MediaQuery.orientationOf(context) == Orientation.portrait) {
                                  final temp = ref.read(videoProvider);
                                  temp.isVideoChanged = false;
                                  ref.read(bookmarkProvider.notifier).islandScap = true;
                                  await SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
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
                          audioId: videoCtrl.video!.videoId,
                          audioUrl: videoCtrl.video!.videoUrl,
                          audioImage: videoCtrl.video!.thumbnailUrl,
                        ),
                        SizedBox(height: _style.scaleX(24)),
                      ]else
                        const SizedBox.shrink(),
                      !isLandscape
                          ? Expanded(
                              child: ListView.separated(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                padding: EdgeInsets.only(
                                  //bottom: _style.scale * 100,
                                  top: _style.scale * 12.5,
                                  right: _style.scale * 10,
                                  left: _style.scale * 10,
                                ),
                                itemCount: bookmarkNotifier.bookmarkListResponse!.length,
                                itemBuilder: (context, index) {
                                  var model = bookmarkNotifier.bookmarkListResponse![index];

                                  return GestureDetector(
                                    onTap: () {},
                                    child: BookmarkItem(
                                      appStyle: _style,
                                      model: model,
                                      index: index,
                                      IsSelected: videoCtrl.isSelected,
                                      onPlay: () {
                                        videoCtrl.isSelected = index;
                                        playVideo(model, bookmarkNotifier.category![index], index, showAudioFile);
                                      },
                                      url: model.bookmarkVideoResponse!.videoUrlSrc,
                                      onBookmarkRemove: () async {
                                        if (model.videoId == null) return;
                                        await ref.read(bookmarkProvider).toggleBookmark(model.videoId!, isRemove: true);
                                        bookmarkNotifier.bookmarkListResponse!.removeAt(index);
                                      },
                                    ),
                                  );
                                },
                                separatorBuilder: (BuildContext context, int index) => SizedBox(height: _style.scaleX(25)),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
    );
  }
}
