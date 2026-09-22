import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/provider/dashboard_provider.dart';
import 'package:meditation_app/provider/video_provider.dart';
import 'package:meditation_app/theme/colors.dart';
import 'package:meditation_app/theme/styles.dart';
import 'package:meditation_app/ui/common/media_player/custom_track_shape.dart';
import 'package:meditation_app/util/assets.dart';
import 'package:video_player/video_player.dart';

import '../../../data/model/body/resource_type.dart';
import '../../../util/constants.dart';
import '../../../util/dimensions.dart';
import '../../screens/analytics/store_local_watch_time.dart';
import '../outlined_icon_button.dart';

/// all working but bookmark screen and playlist screen landscape to portrait second start from zero
class AppVideoPlayer extends ConsumerStatefulWidget {
  final String url;
  final int videoId;
  final int? categoryId;
  final String duration;
  final AppStyle style;
  final bool isLandscape;
  final VoidCallback? onBackPress;
  final bool isFileUrl;
  final VoidCallback? onFullScreen;
  final Duration startPosition;
  final VideoOrientation? videoType;
  final Function(Duration position)? onPositionChanged;

  const AppVideoPlayer({
    super.key,
    required this.url,
    required this.duration,
    required this.style,
    this.categoryId,
    this.onBackPress,
    required this.isLandscape,
    required this.videoId,
    this.isFileUrl = false,
    this.onFullScreen,
    this.startPosition = Duration.zero,
    this.videoType,
    this.onPositionChanged,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppVideoPlayerState();
}

class _AppVideoPlayerState extends ConsumerState<AppVideoPlayer> {
  VideoPlayerController? _controller;
  bool _isControllerInitialized = false;
  bool _isBuffering = false;
  bool isFlickering = true;
  double _progress = 0.1;
  bool _showReload = false;
  bool _isDragging = false;
  Timer? _watchTimer;
  Duration _currentPosition = Duration.zero;
  bool _isInitializing = false;

  final Duration _period = const Duration(seconds: 10);
  final Duration _offlinePeriod = const Duration(seconds: 2);

  VideoOrientation get currentVideoType => widget.videoType ?? VideoOrientation.portrait;

  Future<void> _safeDisposeController() async {
    if (!_isControllerInitialized || _controller == null) return;
    try {
      _controller!.removeListener(listener);
      if (_controller!.value.isInitialized) {
        _controller!.pause();
      }
      await _controller!.dispose();
    } catch (e) {
      log("Error disposing video controller: $e");
    } finally {
      _controller = null;
      _isControllerInitialized = false;
    }
  }

  @override
  void initState() {
    debugPrint('Video Init :: ${widget.videoId}-----${widget.startPosition}');
    super.initState();
    _currentPosition = widget.startPosition;
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    await initVideoPlayer();
    if (mounted) {
      setState(() {
        isFlickering = false;
      });
    }
  }

  Future<void> initVideoPlayer() async {
    try {
      if (widget.url.isEmpty) {
        return;
      }

      _isInitializing = true;
      if (mounted) setState(() {});
      await _safeDisposeController();

      VideoPlayerController videoPlayerController;
      if (widget.isFileUrl) {
        videoPlayerController = VideoPlayerController.file(File(widget.url));
      } else {
        videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.url), videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));
      }
      _controller = videoPlayerController
        ..initialize().then((_) async {
          _isInitializing = false;
          _isControllerInitialized = true;
          _controller!.addListener(listener);
          if (mounted) {
            setState(() {});
          }
          await _controller!.seekTo(_currentPosition);
          toggleVideo();
        })
        ..setLooping(false);
    } catch (e) {
      _isInitializing = false;
      print("video initilize error${e.toString()}");
    }
  }

  @override
  void didUpdateWidget(covariant AppVideoPlayer oldWidget) {
    debugPrint(' Video UpdateWidget');

    if (oldWidget.url != widget.url || oldWidget.isFileUrl != widget.isFileUrl) {
      debugPrint('Video changed, reinitializing player.');
      _currentPosition = Duration.zero;

      // Adding a slight delay to avoid GPU overload during orientation change
      Future.delayed(Duration(milliseconds: 200), () async {
        if (mounted) {
          await initVideoPlayer(); // Reinitialize video player only after a slight delay
        }
      });
    } else {
      debugPrint('No video change, maintaining current position: ${_controller?.value.position}');
      // _currentPosition = _controller.value.position;// this commented because bookmark nd playlist screen second not working when landscape to portrait
      _currentPosition = widget.startPosition; // this line added  because bookmark nd playlist screen second not working when landscape to portrait
    }

    super.didUpdateWidget(oldWidget);
  }

  void toggleAudio() {
    if (_controller!.value.volume != 0) {
      _controller!.setVolume(0);
    } else {
      _controller!.setVolume(1);
    }
  }

  void listener() {
    if (_controller != null && _controller!.value.isInitialized) {
      if (mounted && !_isDragging) {
        setState(() {
          _isBuffering = _controller!.value.isBuffering;
          _showReload = _controller!.value.position >= _controller!.value.duration;
          _progress = _controller!.value.position.inSeconds.toDouble();
        });
      }
    }
    // Notify parent widget if needed
    if (widget.onPositionChanged != null && !_isDragging) {
      widget.onPositionChanged!(_controller!.value.position);
    }
    log("isPlaying----->${_controller!.value.isPlaying}");
    if (_controller != null && _controller!.value.isPlaying) {
      _watchTimer ??= Timer.periodic(widget.isFileUrl ? _offlinePeriod : _period, (timer) async {
        // if ((!_isBuffering) && _controller.value.isInitialized) {
        if (_controller != null && _controller!.value.isInitialized) {
          if (mounted) {
            ref.read(videoProvider).watchedDuration = _period;
          }
          log("track offline time---->${!widget.isFileUrl}");
          if (!widget.isFileUrl) {
            /// ====== ONLINE MODE: Send to API ======
            log("track online time---->${!widget.isFileUrl}");
            await ref.read(dashboardProvider).storeVideoWatchedTime(
                  widget.videoId,
                  _period,
                  false,
                );
          } else {
            /// ====== OFFLINE MODE: Save to local pref ======
            await LocalAnalyticsStore.addWatchTime(
              isAudio: false,
              // here video only, audio you handle separately
              seconds: _offlinePeriod.inSeconds,
              date: DateTime.now(),
              categoryId: widget.categoryId ?? 1,
              videoId: widget.videoId,
            );

            /// 🔹 Immediately read back & print to check
            final all = await LocalAnalyticsStore.getAllWatchTime();
            print("---- Watch Time Data ----");
            print("All data=====>${all.keys}:${all.values}");

// Example: read today's total for video category=2, videoId=123
            final today = "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";

            final categoryKey = (widget.categoryId ?? 1).toString();
            final videoKey = widget.videoId.toString();

            final videoData = all["video"]?[today]?[categoryKey]?[videoKey];
            print("Video=====> $videoKey watch time today: ${videoData ?? 0} seconds");
          }
        }
      });
    } else {
      _watchTimer?.cancel();
      _watchTimer = null;
    }

    // Notify parent widget of the current position
    if (widget.onPositionChanged != null) {
      log("on position change======>${_controller!.value.position}");
      widget.onPositionChanged!(_controller!.value.position);
    }
  }

  void toggleVideo() {
    setState(() {
      if (_controller != null && _controller!.value.isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
      }
    });
  }

  @override
  void deactivate() {
    if (_controller != null && _controller!.value.isInitialized) {
      _controller!.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    if (_controller != null && _isControllerInitialized) {
      _controller!.removeListener(listener);
      if (_controller!.value.isInitialized) {
        _currentPosition = _controller!.value.position;
        _controller!.pause();
      }
      try {
        _controller!.dispose();
      } catch (e) {
        log("Error disposing video controller: $e");
      }
      _controller = null;
      _isControllerInitialized = false;
    }
    _watchTimer?.cancel();
    _watchTimer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isPlaying = _controller != null && _controller!.value.isPlaying;
    bool isMute = _controller != null && _controller!.value.volume == 0;
    bool isInitialized = _controller != null && _controller!.value.isInitialized;
    debugPrint(
      "Player height: ${MediaQuery.of(context).size.height}",
    );
    print("currentVideoType--->$currentVideoType----${widget.videoType}");
    return Stack(
      alignment: Alignment.center,
      children: [
          if (isInitialized && !isFlickering)
            if (currentVideoType == VideoOrientation.portrait)
              Container(
                width: double.infinity,
                clipBehavior: Clip.none,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.contain,
                  child: SizedBox(
                    width: _controller!.value.size.width,
                    height: _controller!.value.size.height,
                    child: VideoPlayer(_controller!),
                  ),
                  ),
                ),
              )
            else
              AspectRatio(
                aspectRatio: isInitialized ? _controller!.value.aspectRatio : 16 / 9,
                child: ClipRRect(borderRadius: widget.isLandscape ? BorderRadius.zero : BorderRadius.circular(widget.style.scaleX(25)), child: VideoPlayer(_controller!)),
              ),
          if (!_isInitializing && (!isInitialized || (_isBuffering && !_showReload))) const CircularProgressIndicator(),
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
                          if (widget.videoType == VideoOrientation.landscape)
                            OutlinedIconButton.svg(
                              SvgPaths.maximize,
                              appStyle: widget.style,
                              hideBorder: true,
                              iconSize: widget.isLandscape ? 23 : 20,
                              onTap: widget.onFullScreen,
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
                                thumbShape: RoundSliderThumbShape(enabledThumbRadius: widget.style.scaleX(6)),
                                trackShape: CustomTrackShape(),
                              ),
                          child: Slider(
                            value: _progress,
                            min: 0.0,
                            max: _controller != null ? _controller!.value.duration.inSeconds.toDouble() : 0.0,
                            onChangeStart: (progress) {
                              setState(() {
                                _isDragging = true; // User starts dragging
                              });
                              // Stop listening to video updates while the user is dragging
                               _controller!.removeListener(listener);
                            },
                            onChangeEnd: (progress) {
                              setState(() {
                                _isDragging = false; // User stops dragging
                              });
                              // Seek to the new position after dragging is finished
                               _controller!.seekTo(Duration(seconds: progress.toInt()));
                               // Resume listening to video updates
                               _controller!.addListener(listener);
                            },
                            onChanged: (progress) {
                              setState(() {
                                _progress = progress;
                              });
                               _controller!.seekTo(Duration(seconds: progress.toInt()));
                            },
                            activeColor: AppColors.primaryColor,
                            inactiveColor: Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: widget.style.scaleX(8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FutureBuilder<Duration?>(
                              future: _controller != null ? _controller!.position : Future.value(null),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final position = snapshot.data;
                                  return Text('${position?.inMinutes.toString().padLeft(2, '0') ?? 0}:${((position?.inSeconds ?? 0) % 60).toString().padLeft(2, '0')}');
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              },
                            ),
                            Text(stringToDuration(widget.duration)),
                          ],
                        ),
                      ),
                      if (widget.isLandscape) SizedBox(height: widget.style.scaleX(15)),
                    ],
                  ),
                ),
            ],
          ),
        ],

    );
  }

  String stringToDuration(String durationString) {

    log("duration string.....:$durationString");
    List<String> durationParts = durationString.split(':');
    if (durationParts.length >= 3) {
      int hours = int.parse(durationParts[0]);
      int minutes = int.parse(durationParts[1]);
      List<String> seconds = durationParts[2].split('.');
      int secs = int.parse(seconds[0]);

      // Format hours, minutes, and seconds with required padding
      String formattedHours = hours.toString().padLeft(2, '0'); // 4 digits
      String formattedMinutes = minutes.toString().padLeft(2, '0'); // 2 digits
      String formattedSeconds = secs.toString().padLeft(2, '0'); // 2 digits
      if (formattedHours == "00") {
        return "$formattedMinutes:$formattedSeconds";
      } else {
        return "$formattedHours:$formattedMinutes:$formattedSeconds";
      }
    }
    return "00.00.00";
  }
}
