import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/provider/dashboard_provider.dart';
import 'package:meditation_app/theme/colors.dart';
import 'package:meditation_app/theme/styles.dart';
import 'package:meditation_app/ui/common/media_player/custom_track_shape.dart';
import 'package:meditation_app/util/assets.dart';
import 'package:video_player/video_player.dart';

import '../../../util/dimensions.dart';
import '../outlined_icon_button.dart';

class AppVideoPlayer extends ConsumerStatefulWidget {
  final String url;
  final int videoId;
  final AppStyle style;
  final bool isLandscape;
  final VoidCallback? onBackPress;

  const AppVideoPlayer({
    super.key,
    required this.url,
    required this.style,
    this.onBackPress,
    required this.isLandscape,
    required this.videoId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppVideoPlayerState();
}

class _AppVideoPlayerState extends ConsumerState<AppVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isBuffering = false;
  double _progress = 0;
  bool _showReload = false;

  Timer? _watchTimer;
  // Duration _watchTimeInSeconds = Duration.zero;
  final Duration _period = const Duration(seconds: 10);

  @override
  void initState() {
    debugPrint(' Video Init :: ${widget.videoId}');
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

  @override
  void didUpdateWidget(covariant AppVideoPlayer oldWidget) {
    debugPrint(' Video UpdateWidget');

    super.didUpdateWidget(oldWidget);
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
    if (_controller.value.isPlaying) {
      _watchTimer ??= Timer.periodic(_period, (timer) {
        // _watchTimeInSeconds += _period; // Increment watch time
        // Call API to update watch duration and video ID
        if (!_isBuffering && _controller.value.isInitialized) {
          ref.read(dashboardProvider).storeVideoWatchedTime(widget.videoId, _period);
        }
      });
    } else {
      _watchTimer?.cancel();
      _watchTimer = null;
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
    _watchTimer?.cancel();
    debugPrint(' Video Disposed ');
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
              iconSize: widget.style.scaleX(widget.isLandscape ? 40 : 35),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.onBackPress != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: widget.style.scaleX(15), top: widget.style.scaleX(10)),
                    child: OutlinedIconButton.icon(
                      icon: Icon(Icons.arrow_back_ios_rounded, size: widget.style.scaleX(widget.isLandscape ? 20 : 15)),
                      appStyle: widget.style,
                      onTap: widget.onBackPress,
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
                        children: [
                          if (!_showReload)
                            OutlinedIconButton.svg(
                              isPlaying ? SvgPaths.pause : SvgPaths.play,
                              appStyle: widget.style,
                              hideBorder: true,
                              iconSize: widget.isLandscape ? 23 : 20,
                              onTap: toggleVideo,
                            ),
                          const Spacer(),
                          OutlinedIconButton.svg(
                            isMute ? SvgPaths.audioMute : SvgPaths.audioOn,
                            appStyle: widget.style,
                            hideBorder: true,
                            iconSize: widget.isLandscape ? 23 : 20,
                            onTap: toggleAudio,
                          ),
                          if (widget.isLandscape) SizedBox(width: widget.style.scaleX(15)),
                          OutlinedIconButton.svg(
                            SvgPaths.maximize,
                            appStyle: widget.style,
                            hideBorder: true,
                            iconSize: widget.isLandscape ? 23 : 20,
                            onTap: () {},
                          ),
                        ],
                      ),
                      SizedBox(height: widget.style.scaleX(widget.isLandscape ? 10 : 5)),
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
                      if (widget.isLandscape) SizedBox(height: widget.style.scaleX(15)),
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
