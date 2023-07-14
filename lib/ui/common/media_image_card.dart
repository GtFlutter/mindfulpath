import 'package:flutter/cupertino.dart';

import '../../theme/styles.dart';
import 'cutom_media_card.dart';

class MediaImageCard extends StatelessWidget {
  const MediaImageCard(
      {super.key,
      required this.appStyle,
      required this.imgUrl,
      required this.duration,
      required this.imgSize,
      required this.imgRadius});

  final AppStyle appStyle;
  final String imgUrl;
  final String duration;
  final double imgSize;
  final double imgRadius;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(imgRadius),
          child: Image.network(
            imgUrl,
            width: imgSize,
            height: imgSize,
            fit: BoxFit.cover,
          ),
        ),
        IntrinsicHeight(
          child: CustomMediaCard(appStyle: appStyle, duration: duration),
        ),
      ],
    );
  }
}
