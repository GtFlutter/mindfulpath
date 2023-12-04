import 'package:flutter/material.dart';
import 'package:meditation_app/theme/text_style.dart';

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
    if (imgUrl.isEmpty) {
      return SizedBox(
        width: imgSize,
        height: imgSize,
        child: Center(
          child: Text(
            'Video No Longer Available',
            textAlign: TextAlign.center,
            style: appStyle.text.font(mulishSemiBold600, sizePx: 8, color: Colors.white),
          ),
        ),
      );
    }
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(imgRadius),
          child: Image.network(
            imgUrl,
            errorBuilder: (_, __, ___) => SizedBox(
              width: imgSize,
              height: imgSize,
              child: const Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  color: Colors.grey,
                ),
              ),
            ),
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
