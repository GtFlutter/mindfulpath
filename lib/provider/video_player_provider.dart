import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

final videoPlayerProvider = ChangeNotifierProvider<VideoPlayerNotifier>((ref) {
  return VideoPlayerNotifier();
},);

class VideoPlayerNotifier extends ChangeNotifier {

  VideoPlayerController controller = VideoPlayerController.file(File(''));

  bool _isBuffering = false;
  bool get isBuffering => _isBuffering;

  double? progress;

  bool _showReload = false;
  bool get showReload => _showReload;

  void initVideoPlayer({bool isFileUrl = false,required String url}) {
    if (isFileUrl) {
      controller = VideoPlayerController.file(
        File(url),
      );
    } else {
      controller = VideoPlayerController.networkUrl(
        Uri.parse(url),
      );
    }

    controller..initialize()..setLooping(false).then((value) {
      controller.addListener(listener);
      },
    );

    notifyListeners();
  }

  void listener() {
    double newValue = controller.value.position.inMilliseconds / controller.value.duration.inMilliseconds;
    if (progress != newValue) {
      _isBuffering = controller.value.isBuffering;
      _showReload = controller.value.position >= controller.value.duration;
      progress = controller.value.position.inSeconds.toDouble();
    }
    if (controller.value.isPlaying) {

    } else {

    }
  }

}