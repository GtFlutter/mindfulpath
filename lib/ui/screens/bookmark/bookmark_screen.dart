import 'package:flutter/cupertino.dart';
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

  @override
  void initState() {
    final bookmarkNotifier = ref.read(bookmarkProvider);
    Future.delayed(Duration.zero, () {
      bookmarkNotifier.getBookmarkList();
      ref.watch(videoProvider).clearVideo();
    });
    super.initState();
  }

  @override
  void deactivate() {
    ref.read(videoProvider.notifier).isSelected=null;
    super.deactivate();
  }


  Future<void> refreshh() async{
    Future.delayed(Duration.zero, () async {
      final coursePRead = ref.read(courseProvider);
      final coursePWatch = ref.watch(courseProvider);
      await coursePRead.getCategoryFromDatabase();
      for(final category in coursePWatch.downloadResponse){
       await coursePRead.getVideoFromDatabase(int.parse(category.categoryId??""));

        }
    });

  }

  void playVideo(BookmarkListResponse bookmarkListResponse,
      CategoryListResponse category) {
    print(
        '------------****${bookmarkListResponse.bookmarkVideoResponse!.videoUrl}');
    ref.read(videoProvider).playVideo(
          DetailedVideoModel(
            category: category,
            video: DIModel(
              thumbnailUrl:
                  bookmarkListResponse.bookmarkVideoResponse!.imgUrl ?? '',
              videoUrl: bookmarkListResponse.bookmarkVideoResponse!.videoUrl!,
              duration:
                  bookmarkListResponse.bookmarkVideoResponse?.duration ?? '',
              title: bookmarkListResponse.bookmarkVideoResponse!.title ?? '',
              categoryName:
                  bookmarkListResponse.bookmarkVideoResponse!.title ?? '',
              videoId: bookmarkListResponse.bookmarkVideoResponse!.id!,
              videoType:
                  bookmarkListResponse.bookmarkVideoResponse!.videoType ??
                      ResourceType.paid,
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _style = AppStyle(screenSize: size);
    bool isLandscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;

    var videoCtrl = ref.watch(videoProvider);
    var isVideoAvailable = videoCtrl.video != null;

    final bookmarkNotifier = ref.watch(bookmarkProvider);
    final downloadP = ref.watch(downloadProvider);

    print('______-------BookMark--------_____979479_______${downloadP.complate}');
    if(downloadP.complate==true){
      refreshh();
      ref.read(downloadProvider.notifier).complate=false;
      setState((){});
    }


    return SafeArea(
      left: false,
      right: false,
      bottom: false,
      child: bookmarkNotifier.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : bookmarkNotifier.bookmarkListResponse == null ||
                  bookmarkNotifier.bookmarkListResponse!.isEmpty
              ? const Center(child: Text('No Data Found'))
              : Padding(
                  padding: isLandscape && isVideoAvailable
                      ? EdgeInsets.zero
                      : EdgeInsets.symmetric(horizontal: _style.scaleX(20)),
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
                            alignment:
                                !isLandscape ? null : Alignment.topCenter,
                            constraints: !isLandscape ? BoxConstraints(maxHeight: size.height * 0.4) : null,
                            child: AppVideoPlayer(
                              key: const ValueKey('value'),
                              videoId: videoCtrl.video!.videoId,
                              url: videoCtrl.video!.videoUrl,
                              duration:videoCtrl.video!.duration,
                              style: _style,
                              isLandscape: isLandscape,
                              onBackPress: () {
                                if (MediaQuery.orientationOf(context) ==
                                    Orientation.landscape) {
                                  SystemChrome.setPreferredOrientations(
                                      [DeviceOrientation.portraitUp]);
                                }
                                ref.read(videoProvider.notifier).isSelected=null;
                                ref.read(bookmarkProvider.notifier).islandScap=false;

                                videoCtrl.clearVideo();
                              },
                              isFileUrl: false,
                              onFullScreen: () {
                                if (MediaQuery.orientationOf(context) == Orientation.portrait) {
                                  ref.read(bookmarkProvider.notifier).islandScap=true;
                                  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
                                } else {
                                  ref.read(bookmarkProvider.notifier).islandScap=false;
                                  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                                }
                              },
                            ),
                          ),
                        )
                      ] else
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
                              itemCount: bookmarkNotifier
                                  .bookmarkListResponse!.length,
                              itemBuilder: (context, index) {
                                var model = bookmarkNotifier
                                    .bookmarkListResponse![index];
                            
                                return GestureDetector(
                                  onTap: () {
                            
                                  },
                                  child: BookmarkItem(
                                    appStyle: _style,
                                    model: bookmarkNotifier
                                        .bookmarkListResponse![index],
                                    index: index,
                                    IsSelected: ref.read(videoProvider.notifier).isSelected,
                                    onPlay: (){
                                        ref.read(videoProvider.notifier).isSelected=index;
                                        playVideo(model, bookmarkNotifier.category![index]);
                            
                                    },
                                    url: bookmarkNotifier
                                        .bookmarkListResponse![index]
                                        .bookmarkVideoResponse!
                                        .videoUrlSrc,
                                    onBookmarkRemove: () async {
                                      if (bookmarkNotifier.bookmarkListResponse![index].videoId == null) return;
                                      await ref
                                          .read(bookmarkProvider)
                                          .toggleBookmark(bookmarkNotifier.bookmarkListResponse![index].videoId!,
                                              isRemove: true);
                                      bookmarkNotifier.bookmarkListResponse!
                                          .removeAt(index);
                                    },
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      SizedBox(height: _style.scaleX(25)),
                            ),
                          )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
    );
  }
}
