import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:meditation_app/util/assets.dart';

import '../../theme/colors.dart';

class BackgroundImage extends StatelessWidget {
  final Widget? child;

  final AlignmentGeometry alignment;

  /// [opacity] should be between 0 to 1
  final double? opacity;

  final String imgUrl;
  final bool hideImage;

  const BackgroundImage({
    super.key,
    this.child,
    this.alignment = AlignmentDirectional.topStart,
    this.opacity,
  })  : imgUrl = '',
        hideImage = false;

  const BackgroundImage.network({
    super.key,
    this.child,
    this.alignment = AlignmentDirectional.topStart,
    required this.imgUrl,
    this.hideImage = false,
  }) : opacity = null;

  @override
  Widget build(BuildContext context) {
    // return child != null ? ColoredBox(color: Colors.grey, child: child) : const SizedBox.shrink();
    return Stack(
      alignment: alignment,
      children: [
        if (imgUrl.isNotEmpty && !hideImage) ...[
          Image.network(
            imgUrl,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
            child: Container(
              color: AppColors.bottomNavBgColor.withOpacity(0.80),
            ),
          ),
        ],
        Image.asset(
          // ImagePaths.bg,
          ImagePaths.bg2,
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
          opacity: hideImage
              ? null
              : imgUrl.isNotEmpty
                  ? const AlwaysStoppedAnimation(0.50)
                  : opacity == null
                      ? null
                      : AlwaysStoppedAnimation(opacity!),
        ),
        if (child != null) child!,
      ],
    );
  }
}
