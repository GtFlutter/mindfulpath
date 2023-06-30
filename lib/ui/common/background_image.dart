import 'package:flutter/material.dart';
import 'package:meditation_app/util/assets.dart';

class BackgroundImage extends StatelessWidget {
  final Widget? child;

  final AlignmentGeometry alignment;

  /// [opacity] should be between 0 to 1
  final double? opacity;

  const BackgroundImage({
    super.key,
    this.child,
    this.alignment = AlignmentDirectional.topStart,
    this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: alignment,
      children: [
        Image.asset(
          ImagePaths.bg,
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
          opacity: opacity == null ? null : AlwaysStoppedAnimation(opacity!),
        ),
        if (child != null) SafeArea(child: child!),
      ],
    );
  }
}
