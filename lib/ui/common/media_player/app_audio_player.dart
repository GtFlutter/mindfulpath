import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meditation_app/provider/dashboard_provider.dart';
import 'package:meditation_app/theme/colors.dart';
import 'package:meditation_app/theme/styles.dart';
import 'package:meditation_app/ui/common/media_player/custom_track_shape.dart';
import 'package:meditation_app/util/assets.dart';
import 'package:meditation_app/util/dimensions.dart';

class AppAudioPlayer extends ConsumerStatefulWidget {

  final AppStyle style;
  final int audioId;
  final String audioUrl;
  final String audioImage;

  const AppAudioPlayer({super.key, required this.style, required this.audioUrl, required this.audioImage, required this.audioId, });

  @override
  ConsumerState<AppAudioPlayer> createState() => _AppAudioPlayerState();
}

class _AppAudioPlayerState extends ConsumerState<AppAudioPlayer> with TickerProviderStateMixin{

  AppStyle style = AppStyle();

  AudioPlayer _audioPlayer = AudioPlayer();

  int duration = 30;

  late AnimationController _animationController;
  bool _isControlsVisible = true;
  bool get isControlsVisible => _isControlsVisible;

  int lastSecond = 0;

  Duration playedDuration = Duration(seconds: 0);

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _audioPlayer.play(UrlSource(widget.audioUrl));

    Future.delayed(const Duration(seconds: 3), () {
      _isControlsVisible = false;
      setState(() {});
    },);

  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    _audioPlayer.stop();
    _audioPlayer.dispose();
    ref.read(dashboardProvider).storeVideoWatchedTime(widget.audioId, Duration(seconds: lastSecond), true);
    super.deactivate();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleControls() {
    setState(() {
      _isControlsVisible = !_isControlsVisible;
      if (_isControlsVisible) {
        _animationController.forward();
        Future.delayed(const Duration(seconds: 3), () {
          _animationController.reverse();
          _isControlsVisible = false;
          setState(() {});
        },);
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    style = AppStyle(screenSize: MediaQuery.sizeOf(context));

    return GestureDetector(
      onTap: _toggleControls,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.network(widget.audioImage,
            height: style.scaleX(300),
            fit: BoxFit.fill,
            width: style.scaleX(300),
          ),
          StreamBuilder(
            stream: _audioPlayer.onPositionChanged,
            builder:(context, snapshot) {
              if(snapshot.data == null){
                return Container();
              }
              getSongDuration().then((value) {
                duration = value;
              },);
              if(lastSecond != snapshot.data!.inSeconds){
                lastSecond = snapshot.data!.inSeconds;
                debugPrint("Last Second ${lastSecond}");
              }
              return AnimatedOpacity(
                opacity: isControlsVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  height: style.scaleX(300),
                  width: style.scaleX(300),
                  alignment: Alignment.bottomCenter,
                  color:  Colors.black.withOpacity(0.3),
                  padding: EdgeInsets.only(
                    left: widget.style.scaleX(Dimensions.PADDING_SIZE_SMALL),
                    right: widget.style.scaleX(Dimensions.PADDING_SIZE_SMALL),
                    bottom: widget.style.scaleX(14),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if(_audioPlayer.state == PlayerState.playing){
                              _audioPlayer.pause();
                            }else{
                              _audioPlayer.resume();
                            }
                          },
                          child: SvgPicture.asset(
                            _audioPlayer.state == PlayerState.playing ? SvgPaths.pause : SvgPaths.play,
                            width: 50,
                            height: 50,
                          ),
                        ),
                      ),
                      SizedBox(
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
                            onChanged: (progress) async{
                              _audioPlayer.seek(Duration(seconds: progress.toInt()));
                            },
                            activeColor: AppColors.primaryColor,
                            inactiveColor: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<int> getSongDuration() async{
    Duration? duration = await _audioPlayer.getDuration();
    if(duration != null){
      return duration.inSeconds;
    }
    return 30;
  }

}
