import 'package:flutter/material.dart';
import 'package:meditation_app/theme/colors.dart';
import 'package:meditation_app/theme/styles.dart';
import 'package:meditation_app/util/assets.dart';
import 'package:video_player/video_player.dart';

import '../../../util/dimensions.dart';
import '../outlined_icon_button.dart';

class AppVideoPlayer extends StatefulWidget {
  final String url;
  final AppStyle style;
  final bool isLandscape;
  final VoidCallback? onBackPress;

  const AppVideoPlayer({
    super.key,
    required this.url,
    required this.style,
    this.onBackPress,
    required this.isLandscape,
  });

  @override
  State<AppVideoPlayer> createState() => _AppVideoPlaterState();
}

class _AppVideoPlaterState extends State<AppVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isBuffering = false;
  double _progress = 0;
  bool _showReload = false;

  @override
  void initState() {
    debugPrint('Yashvant Video Init');
    super.initState();
    VideoPlayerController videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.url),
    );
    _controller = videoPlayerController
      ..initialize()
      ..setLooping(false).then(
        (value) {
          _controller.addListener(listner);
          setState(() {});
          toggleVideo();
        },
      );
  }

  void listner() {
    double newValue = _controller.value.position.inMilliseconds / _controller.value.duration.inMilliseconds;
    if (_progress != newValue) {
      setState(
        () {
          _isBuffering = _controller.value.isBuffering;
          _progress = newValue.clamp(0, 1).toDouble();
          _showReload = _controller.value.position >= _controller.value.duration;
        },
      );
    }
  }

  void toggleVideo() async {
    setState(() {
      if (_controller.value.position >= _controller.value.duration) {
        _controller.seekTo(Duration.zero);
      }
      _controller.value.isPlaying ? _controller.pause() : _controller.play();
    });
  }

  void toggleAudio() {
    if (_controller.value.volume != 0) {
      _controller.setVolume(0);
    } else {
      _controller.setVolume(1);
    }
  }

  @override
  void dispose() {
    debugPrint('Yashvant Video Disposed ');
    if (_controller.value.isInitialized) {
      _controller.removeListener(listner);
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isPlaying = _controller.value.isPlaying;
    bool isMute = _controller.value.volume == 0;
    bool isInitialized = _controller.value.isInitialized;
    return IntrinsicHeight(
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: isInitialized ? _controller.value.aspectRatio : 16 / 9,
            child: ClipRRect(
              borderRadius: widget.isLandscape ? BorderRadius.zero : BorderRadius.circular(widget.style.scaleX(25)),
              child: VideoPlayer(_controller),
            ),
          ),
          if (!isInitialized || (_isBuffering && !_showReload)) const CircularProgressIndicator(),
          if (_showReload && isInitialized)
            IconButton(
              onPressed: toggleVideo,
              icon: const Icon(Icons.replay_rounded),
              iconSize: widget.style.scaleX(35),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.onBackPress != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: widget.style.scaleX(10), top: widget.style.scaleX(5)),
                    child: IconButton.outlined(
                      constraints:
                          BoxConstraints(maxWidth: widget.style.scale * 30, maxHeight: widget.style.scale * 30),
                      onPressed: widget.onBackPress,
                      icon: const Icon(Icons.arrow_back_ios_rounded),
                      iconSize: widget.style.scale * 15,
                      style: IconButton.styleFrom(
                        side: const BorderSide(color: AppColors.appBarBorderColor),
                        backgroundColor: Colors.black.withOpacity(0.2),
                      ),
                    ),
                  ),
                ),
              const Spacer(),
              if (isInitialized && !_isBuffering)
                Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.only(
                    left: widget.style.scaleX(Dimensions.PADDING_SIZE_SMALL),
                    right: widget.style.scaleX(Dimensions.PADDING_SIZE_SMALL),
                    bottom: widget.style.scaleX(14),
                    // top: widget.style.scaleX(30),
                  ),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: widget.isLandscape
                          ? BorderRadius.zero
                          : BorderRadius.only(
                              bottomLeft: Radius.circular(widget.style.scaleX(25)),
                              bottomRight: Radius.circular(widget.style.scaleX(25)),
                            ),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.20),
                        Colors.black.withOpacity(0.40),
                        Colors.black.withOpacity(0.60),
                        Colors.black.withOpacity(0.80),
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (!_showReload)
                            OutlinedIconButton(
                              appStyle: widget.style,
                              svgIconSrc: isPlaying ? SvgPaths.pause : SvgPaths.play,
                              hideBorder: true,
                              iconSize: 20,
                              onTap: toggleVideo,
                            ),
                          const Spacer(),
                          OutlinedIconButton(
                            appStyle: widget.style,
                            svgIconSrc: isMute ? SvgPaths.audioMute : SvgPaths.audioOn,
                            hideBorder: true,
                            iconSize: 20,
                            onTap: toggleAudio,
                          ),
                          OutlinedIconButton(
                            appStyle: widget.style,
                            svgIconSrc: SvgPaths.maximize,
                            hideBorder: true,
                            iconSize: 20,
                            onTap: () {},
                          ),
                        ],
                      ),
                      SizedBox(height: widget.style.scaleX(5)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: widget.style.scaleX(8)),
                        child: SliderTheme(
                          data: Theme.of(context).sliderTheme.copyWith(
                                trackHeight: widget.style.scaleX(4),
                                overlayShape: SliderComponentShape.noOverlay,
                                thumbShape: SliderComponentShape.noThumb,
                                // thumbShape: RoundSliderThumbShape(enabledThumbRadius: widget.style.scaleX(6)),
                                trackShape: CustomTrackShape(),
                              ),
                          child: Slider(
                            value: _progress,
                            onChanged: (_) {},
                            activeColor: AppColors.primaryColor,
                            // thumbColor: AppColors.primaryColor,
                            inactiveColor: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 2,
  }) {
    super.paint(
      context,
      offset,
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      enableAnimation: enableAnimation,
      textDirection: textDirection,
      thumbCenter: thumbCenter,
      secondaryOffset: secondaryOffset,
      isDiscrete: isDiscrete,
      isEnabled: isEnabled,
      additionalActiveTrackHeight: 0,
    );
  }
}
