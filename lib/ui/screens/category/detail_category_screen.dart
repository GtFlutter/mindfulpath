import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/data/model/response/category_list_reponse.dart';
import 'package:meditation_app/provider/download_provider.dart';
import 'package:meditation_app/provider/recent_videos_provider.dart';
import 'package:meditation_app/provider/video_provider.dart';
import 'package:meditation_app/theme/colors.dart';
import 'package:meditation_app/theme/text_style.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/ui/common/custom_app_bar.dart';
import 'package:meditation_app/ui/screens/category/widget/resource_widget.dart';
import 'package:meditation_app/util/assets.dart';
import 'package:meditation_app/util/constants.dart';

import '../../../theme/styles.dart';
import '../../common/media_player/app_video_player.dart';
import 'widget/detail_item.dart';
import 'widget/intro_widget.dart';

class DetailCategoryScreen extends ConsumerStatefulWidget {
  final CategoryListResponse categoryListResponse;
  final DIModel? initialVideo;
  bool? isFromPdfNotification;
  bool? isFromPaidVideoNotification;
  bool? isPaid;
  bool? isPDFView;
   DetailCategoryScreen({
    super.key,
    required this.categoryListResponse,
    required this.initialVideo,
    this.isFromPdfNotification,
     this.isPaid,
     this.isPDFView,
     this.isFromPaidVideoNotification
  });

  @override
  ConsumerState<DetailCategoryScreen> createState() => _DetailCategoryScreenState();
}

class _DetailCategoryScreenState extends ConsumerState<DetailCategoryScreen> {
  static AppStyle _style = AppStyle();

  @override
  void initState() {
    ref.read(videoProvider).clearVideo(notifie: false);
    Future.delayed(
      Duration.zero,
      () {
        ref.read(videoProvider).reInit(
              widget.initialVideo != null
                  ? DetailedVideoModel(
                      category: widget.categoryListResponse,
                      video: widget.initialVideo!,
                    )
                  : null,
            );
      },
    );
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;
    Size size = MediaQuery.sizeOf(context);
    _style = AppStyle(screenSize: size);
    TextStyle textStyle = _style.text.font(mulishRegular400, sizePx: 14);

    var videoCtrl = ref.watch(videoProvider);

    var isVideoAvailable = videoCtrl.video != null;

    print('_______7789878_________${widget.categoryListResponse.isPurchased}');

    return PopScope(
      canPop: !isVideoAvailable,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        if (isVideoAvailable) {
          if (MediaQuery.orientationOf(context) == Orientation.landscape) {
            SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
        appBar: isVideoAvailable && isLandscape ? null : CustomAppBar(screenSize: size, style: _style),
        body: BackgroundImage.network(
          imgUrl: widget.categoryListResponse.imageResponse?.imageUrl ?? AppConstants.placeHolder,
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
                        constraints: !isLandscape ? BoxConstraints(maxHeight: size.height * 0.4) : null,
                        child: AppVideoPlayer(
                          key: const ValueKey('value'),
                          videoId: videoCtrl.video!.videoId,
                          url: videoCtrl.video!.videoUrl,
                          duration:videoCtrl.video!.duration,
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
                    if (isVideoAvailable && !isLandscape) ...[
                      SizedBox(height: _style.scaleX(15)),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            videoCtrl.video!.title,
                            style: _style.text.font(mulishSemiBold600, sizePx: 20, color: Colors.white),
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
                                    style:
                                        _style.text.font(mulishSemiBold600, sizePx: 14, color: AppColors.primaryColor),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(width: _style.scaleX(5)),
                                  Flexible(
                                    child: Text(
                                      videoCtrl.video!.categoryName,
                                      style: textStyle.copyWith(color: AppColors.autherNameColor),
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
                        title: widget.categoryListResponse.title ?? '',
                        style: _style,
                      ),
                    ),
                  if (!isLandscape || !isVideoAvailable)
                    Expanded(
                      flex: 3,
                      child: ResourceDetailCategory(
                        category: widget.categoryListResponse,
                        isFromPdfNotification: widget.isFromPdfNotification ?? false,
                        isPaid: widget.isPaid ?? false,
                        isFromPaidVideoNotification:widget.isFromPaidVideoNotification ?? false ,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
