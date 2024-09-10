import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/data/model/response/category_list_reponse.dart';
import 'package:meditation_app/provider/recent_videos_provider.dart';
import 'package:meditation_app/provider/video_provider.dart';
import 'package:meditation_app/theme/colors.dart';
import 'package:meditation_app/theme/text_style.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/ui/common/custom_app_bar.dart';
import 'package:meditation_app/ui/common/media_player/app_video_player.dart';
import 'package:meditation_app/ui/screens/category/widget/resource_widget.dart';
import 'package:meditation_app/util/constants.dart';

import '../../../../theme/styles.dart';
import 'detail_item.dart';
import 'intro_widget.dart';



class DetailCategoryScreen extends ConsumerStatefulWidget {
  final CategoryListResponse categoryListResponse;
  final DIModel? initialVideo;
  final bool? isFromPdfNotification;
  final bool? isFromPaidVideoNotification;
  final bool? isPaid;
  final bool? isPDFView;

  const DetailCategoryScreen({
    super.key,
    required this.categoryListResponse,
    required this.initialVideo,
    this.isFromPdfNotification,
    this.isPaid,
    this.isPDFView,
    this.isFromPaidVideoNotification,
  });

  @override
  ConsumerState createState() => _DetailCategoryScreenState();
}

class _DetailCategoryScreenState extends ConsumerState<DetailCategoryScreen> with WidgetsBindingObserver{
  static AppStyle _style = AppStyle();
  Duration? _lastKnownPosition;
  bool _isFullScreen = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this); // Add observer
    super.initState();
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
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Remove observer
    super.dispose();
  }
  @override
  void didChangeMetrics() {
    // Handle orientation changes
    final orientation = MediaQuery.orientationOf(context);
    if (orientation == Orientation.landscape) {
      // Handle landscape
      setState(() {
        _isFullScreen = true;
      });
    } else {
      // Handle portrait
      setState(() {
        _isFullScreen = false;
      });
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;
    Size size = MediaQuery.sizeOf(context);
    _style = AppStyle(screenSize: size);
    TextStyle textStyle = _style.text.font(mulishRegular400, sizePx: 14);

    var videoCtrl = ref.watch(videoProvider);
    var isVideoAvailable = videoCtrl.video != null;

    return WillPopScope(
      onWillPop: () async {
        if (_isFullScreen) {
          _exitFullScreen(); // Call this to exit full screen
          return false;
        }
        return true;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: isVideoAvailable && _isFullScreen ? null : CustomAppBar(screenSize: size, style: _style),
        body: BackgroundImage.network(
          imgUrl: widget.categoryListResponse.imageResponse?.imageUrl ?? AppConstants.placeHolder,
          hideImage: _isFullScreen && isVideoAvailable,
          child: SafeArea(
            left: false,
            right: false,
            bottom: false,
            child: Padding(
              padding: _isFullScreen ? EdgeInsets.zero : EdgeInsets.symmetric(horizontal: _style.scaleX(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (isVideoAvailable) ...[
                    if (!_isFullScreen) SizedBox(height: _style.scaleX(25)),
                    Flexible(
                      flex: _isFullScreen ? 1 : 0,
                      child: Container(
                        width: !_isFullScreen ? null : double.infinity,
                        height: !_isFullScreen ? null : double.infinity,
                        alignment: !_isFullScreen ? null : Alignment.topCenter,
                        constraints: !_isFullScreen ? BoxConstraints(maxHeight: size.height * 0.4) : null,
                        child: AppVideoPlayer(
                          key: const ValueKey('value'),
                          videoId: videoCtrl.video!.videoId,
                          url: videoCtrl.video!.videoUrl,
                          duration: videoCtrl.video!.duration,
                          style: _style,
                          isLandscape: _isFullScreen,
                          startPosition: _lastKnownPosition ?? Duration.zero,
                          onPositionChanged: (position) {
                            _lastKnownPosition = position;
                          },
                          onFullScreen: () {
                            _enterFullScreen();
                          },
                          onBackPress: () {
                            _exitFullScreen(); // Calls the same function to toggle
                          },
                          isFileUrl: false,
                        ),
                      ),
                    ),
                    if (!_isFullScreen) ...[
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
                                    style: _style.text.font(mulishSemiBold600, sizePx: 14, color: AppColors.primaryColor),
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
                      flex: 2,
                      child: IntroWidget(
                        title: widget.categoryListResponse.title ?? '',
                        style: _style,
                      ),
                    ),
                  if (!_isFullScreen || !isVideoAvailable)
                    Expanded(
                      flex: 3,
                      child: ResourceDetailCategory(
                        category: widget.categoryListResponse,
                        isFromPdfNotification: widget.isFromPdfNotification ?? false,
                        isPaid: widget.isPaid ?? false,
                        isFromPaidVideoNotification: widget.isFromPaidVideoNotification ?? false,
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

  void _enterFullScreen() {
    if (MediaQuery.orientationOf(context) == Orientation.landscape) {
      // If currently in landscape, exit full-screen mode
      setState(() {
        _isFullScreen = false;
      });
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    } else {
      // If currently in portrait, enter full-screen mode
      setState(() {
        _isFullScreen = true;
      });
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    }
  }

  void _exitFullScreen() {
    setState(() {
      _isFullScreen = false;
    });
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    ref.read(videoProvider).clearVideo(); // Clear video resources
  }
}