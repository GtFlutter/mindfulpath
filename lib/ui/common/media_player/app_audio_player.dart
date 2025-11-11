import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/provider/dashboard_provider.dart';
import 'package:meditation_app/provider/video_provider.dart';
import 'package:meditation_app/theme/colors.dart';
import 'package:meditation_app/theme/styles.dart';
import 'package:meditation_app/ui/common/media_player/custom_track_shape.dart';
import 'package:meditation_app/util/assets.dart';
import 'package:meditation_app/util/dimensions.dart';

import '../../screens/analytics/store_local_watch_time.dart';
import '../outlined_icon_button.dart';

class AppAudioPlayer extends ConsumerStatefulWidget {
  final AppStyle style;
  final int audioId;
  final int? categoryId;
  final String duration;
  final String audioUrl;
  final String audioImage;

  const AppAudioPlayer({
    super.key,
    required this.style,
    required this.audioUrl,
    required this.duration,
    required this.audioImage,
    required this.audioId,
    this.categoryId,
  });

  @override
  ConsumerState<AppAudioPlayer> createState() => _AppAudioPlayerState();
}

class _AppAudioPlayerState extends ConsumerState<AppAudioPlayer> {
  AppStyle style = AppStyle();

  AudioPlayer _audioPlayer = AudioPlayer();

  int duration = 30;
  bool _showReload = false;
  int lastSecond = 0;

  Duration playedDuration = Duration(seconds: 0);
  bool get _isOfflineFile => widget.audioUrl.startsWith("file://");

  @override
  void initState() {
    super.initState();
    _initializeAudio();
  }

  void _initializeAudio() {
    // Start playing from the beginning
    _audioPlayer.audioCache.clearAll();
    _audioPlayer.setSourceDeviceFile(widget.audioUrl, mimeType: 'audio/mp3');
    lastSecond = 0;
    _audioPlayer.seek(Duration.zero);
    _audioPlayer.play(UrlSource(widget.audioUrl, mimeType: "audio/mp3"));
  }

  @override
  void didUpdateWidget(covariant AppAudioPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.audioId != widget.audioId) {
      _audioPlayer.stop();
      _initializeAudio(); // Reinitialize for new audio
    }
  }

  @override
  Future<void> deactivate() async {
    // TODO: implement deactivate
    _audioPlayer.stop();
    _audioPlayer.dispose();
    // ref.read(dashboardProvider).storeVideoWatchedTime(widget.audioId, Duration(seconds: lastSecond), true);
    final watchedDuration = Duration(seconds: lastSecond);
    log("offline or not--->$_isOfflineFile----${widget.categoryId}");
    if (_isOfflineFile) {
      // 🔹 Store locally if playing from downloaded file
      LocalAnalyticsStore.addWatchTime(
        isAudio: true,
        seconds: lastSecond,
        date: DateTime.now(),
        categoryId: widget.categoryId,  // or pass actual category id if available
        videoId: widget.audioId,
      );
      /// 🔹 Immediately read back & print to check
      final all = await LocalAnalyticsStore.getAllWatchTime();
      print("---- Local Audio Analytics ----");
      print("All data: ${jsonEncode(all)}");

      // 🔹 Example: today's data
      final today = "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";
      final categoryKey = (widget.categoryId ?? 1).toString();
      final audioKey = (widget.audioId ?? 0).toString();
      final seconds = all["audio"]?[today]?[categoryKey]?[audioKey] ?? 0;

      print("Audio ID $audioKey watch time today: $seconds seconds");
    } else {
      // 🔹 Store online via API if streaming from URL
      ref.read(dashboardProvider).storeVideoWatchedTime(widget.audioId, watchedDuration, true);
    }

    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> togglePlayPause() async {
    print("===_audioPlayer.state~~${_audioPlayer.state}----${widget.audioUrl}");
    // if (await File(widget.audioUrl).exists()) {
    //   print('File exists at: ${widget.audioUrl}');
    // } else {
    //   print('File does NOT exist at: ${widget.audioUrl}');
    //   return; // Stop execution if the file doesn't exist
    // }
    setState(() {
      if (_audioPlayer.state == PlayerState.playing) {
        _audioPlayer.pause();
      } else {
        _audioPlayer.resume();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    log("aidio play online or offline----->$_isOfflineFile");
    style = AppStyle(screenSize: MediaQuery.sizeOf(context));
    lastSecond = 0;
    setState(() {});
    getSongDuration().then(
      (value) {
        duration = value;
      },
    );
    return IntrinsicHeight(
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(widget.style.scaleX(25)),
              child: Image.network(
                widget.audioImage,
                // height: style.scaleX(300),
                fit: BoxFit.fill,
                // width: style.scaleX(300),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: widget.style.scaleX(15), top: widget.style.scaleX(10)),
              child: OutlinedIconButton.icon(
                icon: Icon(Icons.arrow_back_ios_rounded, size: widget.style.scaleX(15)),
                appStyle: widget.style,
                onTap: () {
                  log("back called");
                  log("dsfdsdsfdsfdsf======>${ref.read(videoProvider).isAudioFileAvailable}");
                  ref.read(videoProvider.notifier).deactivateAudioPlayer();
                  ref.read(offlineVideoProvider.notifier).deactivateAudioPlayer();
                  log("dsfdsdsfdsfdsf======>${ref.read(videoProvider).isAudioFileAvailable}");
                  // ref.read(dashboardProvider).storeVideoWatchedTime(widget.audioId, Duration(seconds: lastSecond), true);
                  setState(() {});
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 70,
              child: StreamBuilder(
                stream: _audioPlayer.onPositionChanged,
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return Container();
                  }
                  getSongDuration().then(
                    (value) {
                      duration = value;
                    },
                  );
                  if (lastSecond != snapshot.data!.inSeconds) {
                    lastSecond = snapshot.data!.inSeconds;
                    // debugPrint("Last Second ${lastSecond}");
                  }
                  return Container(
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(widget.style.scaleX(25)),
                          bottomRight: Radius.circular(widget.style.scaleX(25)),
                        ),
                      ),
                    ),
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.only(
                      left: widget.style.scaleX(Dimensions.PADDING_SIZE_SMALL),
                      right: widget.style.scaleX(Dimensions.PADDING_SIZE_SMALL),
                      bottom: widget.style.scaleX(14),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            if (!_showReload)
                              OutlinedIconButton.svg(
                                _audioPlayer.state == PlayerState.playing ? SvgPaths.pause : SvgPaths.play,
                                appStyle: widget.style,
                                hideBorder: true,
                                iconSize: 20,
                                onTap: togglePlayPause,
                              ),
                            Expanded(
                              child: SizedBox(
                                width: style.scaleX(268),
                                child: SliderTheme(
                                  data: Theme.of(context).sliderTheme.copyWith(
                                        trackHeight: widget.style.scaleX(4),
                                        overlayShape: SliderComponentShape.noOverlay,
                                        thumbShape: RoundSliderThumbShape(enabledThumbRadius: widget.style.scaleX(6)),
                                        trackShape: CustomTrackShape(),
                                      ),
                                  child: Slider(
                                    value: snapshot.data!.inSeconds.toDouble(),
                                    min: 0.0,
                                    max: duration.toDouble(),
                                    onChanged: (progress) async {
                                      _audioPlayer.seek(Duration(seconds: progress.toInt()));
                                    },
                                    activeColor: AppColors.primaryColor,
                                    inactiveColor: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (snapshot.hasData) ...[Text('${snapshot.data?.inMinutes.toString().padLeft(2, '0') ?? 0}:${((snapshot.data?.inSeconds ?? 0) % 60).toString().padLeft(2, '0')}')] else ...[const CircularProgressIndicator()],
                            Text(stringToDuration(widget.duration ?? "")),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<int> getSongDuration() async {
    Duration? duration = await _audioPlayer.getDuration();
    if (duration != null) {
      return duration.inSeconds;
    }
    return 30;
  }

  String stringToDuration(String durationString) {
    // log("duration string.....:$durationString");
    List<String> durationParts = durationString.split(':');
    if (durationParts.length >= 3) {
      int hours = int.parse(durationParts[0]);
      int minutes = int.parse(durationParts[1]);
      List<String> seconds = durationParts[2].split('.');
      Duration duration = Duration(hours: hours, minutes: minutes, seconds: int.parse(seconds[0]));
      if (hours == 0) {
        return "${minutes == 0 ? "00" : minutes.toString().padLeft(2, '0')}:${int.parse(seconds[0]).toString().padLeft(2, '0')}";
      } else {
        return "${hours == 0 ? "00" : hours.toString().padLeft(2, '0')}:${minutes == 0 ? "00" : minutes.toString().padLeft(2, '0')}:${int.parse(seconds[0]).toString().padLeft(2, '0')}";
      }
    }
    return "00:00";
  }
}

