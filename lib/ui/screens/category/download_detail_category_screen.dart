import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/database/database_model.dart';
import 'package:meditation_app/provider/bookmark_provider.dart';
import 'package:meditation_app/provider/course_provider.dart';
import 'package:meditation_app/provider/video_provider.dart';
import 'package:meditation_app/theme/colors.dart';
import 'package:meditation_app/theme/text_style.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/ui/common/custom_app_bar.dart';
import 'package:meditation_app/ui/screens/category/widget/download_detail_item.dart';
import 'package:meditation_app/util/assets.dart';
import 'package:meditation_app/util/constants.dart';

import '../../../theme/styles.dart';
import '../../common/media_player/app_video_player.dart';
import 'widget/intro_widget.dart';

class DownloadDetailCategoryScreen extends ConsumerStatefulWidget {
  final CategoryModal categoryModal;

  const DownloadDetailCategoryScreen({super.key, required this.categoryModal});

  @override
  ConsumerState<DownloadDetailCategoryScreen> createState() =>
      _DetailCategoryScreenState();
}

class _DetailCategoryScreenState
    extends ConsumerState<DownloadDetailCategoryScreen>
    with AutomaticKeepAliveClientMixin {
  static AppStyle _style = AppStyle();

  @override
  void initState() {
    Future.delayed(
      Duration.zero,
      () {
        ref.read(courseProvider).getVideoFromDatabase(
            int.parse(widget.categoryModal.categoryId ?? ""));

      },
    );
    /* Future.delayed(Duration.zero, () {
      print('--------------*******---${widget.categoryModal.id}');
      ref.read(courseProvider).getPdfFromDatabase(int.parse(widget.categoryModal.categoryId??""));

    },);*/
    super.initState();
  }
  @override
  void deactivate() {
    ref.read(videoProvider.notifier).isSelected=null;
    ref.read(courseProvider.notifier).downloadVideoResponse.clear();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bool isLandscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;
    Size size = MediaQuery.sizeOf(context);
    _style = AppStyle(screenSize: size);
    TextStyle textStyle = _style.text.font(mulishRegular400, sizePx: 14);

    var videoCtrl = ref.watch(offlineVideoProvider);
    final courseP = ref.watch(courseProvider);

    print('---------------->${videoCtrl.video?.videoName ?? ""}');

    var isVideoAvailable = videoCtrl.video != null;
    return PopScope(
      canPop: !isVideoAvailable,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        if (isVideoAvailable) {
          if (MediaQuery.orientationOf(context) == Orientation.landscape) {
            SystemChrome.setPreferredOrientations(
                [DeviceOrientation.portraitUp]);
          }
          videoCtrl.clearVideo();
          return;
        }
        if (context.canPop()) {
          context.pop();
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: isVideoAvailable
            ? null
            : CustomAppBar(screenSize: size, style: _style),
        body: BackgroundImage.network(
          // imgUrl: widget.categoryListResponse.imageResponse?.imageUrl ?? AppConstants.placeHolder,
          imgUrl: AppConstants.placeHolder,
          hideImage: isLandscape && isVideoAvailable,
          child: SafeArea(
            left: false,
            right: false,
            bottom: false,
            child: Padding(
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
                        alignment: !isLandscape ? null : Alignment.topCenter,
                        constraints: !isLandscape
                            ? BoxConstraints(maxHeight: size.height * 0.4)
                            : null,
                        child: AppVideoPlayer(
                          key: const ValueKey('value'),
                          videoId: videoCtrl.video?.id??0,
                          url: videoCtrl.video?.videoFile??'',
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
                          isFileUrl: true,
                          onFullScreen: () {
                            if (MediaQuery.orientationOf(context) ==
                                Orientation.portrait) {
                              SystemChrome.setPreferredOrientations(
                                  [DeviceOrientation.landscapeLeft]);
                              ref.read(bookmarkProvider.notifier).islandScap =
                                  true;
                            } else {
                              ref.read(bookmarkProvider.notifier).islandScap =
                                  false;

                              SystemChrome.setPreferredOrientations(
                                  [DeviceOrientation.portraitUp]);
                            }
                          },
                        ),
                      ),
                    ),
                    if (isVideoAvailable && !isLandscape) ...[
                      SizedBox(height: _style.scaleX(15)),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            videoCtrl.video?.videoName ?? '',
                            style: _style.text.font(mulishSemiBold600,
                                sizePx: 20, color: Colors.white),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: _style.scaleX(7)),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: _style.scaleX(10),
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '●',
                                    style: _style.text.font(mulishSemiBold600,
                                        sizePx: 14,
                                        color: AppColors.primaryColor),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(width: _style.scaleX(5)),
                                  Flexible(
                                    child: Text(
                                      videoCtrl.video?.categoryName ?? '',
                                      style: textStyle.copyWith(
                                          color: AppColors.autherNameColor),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),

                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: _style.scaleX(30)),
                        ],
                      ),
                    ],
                  ] else
                    Expanded(
                      flex: !isLandscape ? 2 : 1,
                      child: IntroWidget(
                        title: widget.categoryModal.categoryName ?? '',
                        style: _style,
                      ),
                    ),
                  !isLandscape
                    ?Expanded(
                        flex: 3,
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          // controller: _controller,
                          scrollDirection: Axis.vertical,
                          padding: EdgeInsets.only(
                            bottom: _style.scale * 100,
                            top: _style.scale * 10,
                          ),
                          itemCount: courseP.downloadVideoResponse.length,
                          itemBuilder: (context, index) {
                            VideoModal item =
                                courseP.downloadVideoResponse[index];
                            var model = DDIModal(
                                id: item.id,
                                videoId: item.videoId,
                                videoName: item.videoName,
                                videoFile: item.videoFile,
                                videoDuration: item.videoDuration,
                                categoryId: widget.categoryModal.id.toString(),
                                categoryName: widget.categoryModal.categoryName,
                                categoryImage:
                                    widget.categoryModal.categoryImage);
                            return GestureDetector(
                              //onTap: () => playVideo(model),
                              child: DownloadDetailItem(
                                IsSelected: ref.read(videoProvider.notifier).isSelected,
                                onPlay: (){
                                  ref.read(videoProvider.notifier).isSelected=index;
                                  playVideo(model);
                                },
                                appStyle: _style,
                                index: index,
                                model: model,
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              SizedBox(height: _style.scaleX(25)),
                        )): const SizedBox.shrink(),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void playVideo(DDIModal model) {
    ref.read(offlineVideoProvider).playVideo(model);
  }

  @override
  bool get wantKeepAlive => true;
}
