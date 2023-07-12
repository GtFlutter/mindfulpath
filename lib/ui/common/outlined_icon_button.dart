import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../theme/colors.dart';
import '../../theme/styles.dart';

class OutlinedIconButton extends StatelessWidget {
  final AppStyle appStyle;
  final double padding;
  final double stroke;
  final double iconSize;
  final String? svgIconSrc;
  final Widget? icon;
  final GestureTapCallback? onTap;
  final bool hideBorder;

  const OutlinedIconButton.svg(
    String src, {
    super.key,
    required this.appStyle,
    this.padding = 5,
    this.stroke = 1,
    this.iconSize = 15,
    this.hideBorder = false,
    this.onTap,
  })  : icon = null,
        svgIconSrc = src;
  const OutlinedIconButton.icon({
    super.key,
    required this.appStyle,
    this.padding = 5,
    this.stroke = 1,
    required this.icon,
    this.hideBorder = false,
    this.onTap,
  })  : svgIconSrc = null,
        iconSize = 15;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        splashFactory: InkSplash.splashFactory,
        splashColor: Colors.white.withOpacity(0.2),
        onTap: onTap,
        child: Container(
          // alignment: Alignment.center,
          padding: EdgeInsets.all(appStyle.scaleX(padding)),
          decoration: ShapeDecoration(
            shape: CircleBorder(
              side: hideBorder
                  ? BorderSide.none
                  : BorderSide(
                      color: AppColors.primaryColor,
                      width: appStyle.scaleX(1),
                    ),
            ),
          ),
          child: svgIconSrc != null
              ? SvgPicture.asset(
                  svgIconSrc!,
                  height: appStyle.scaleX(iconSize),
                  fit: BoxFit.fitHeight,
                )
              : icon,
        ),
      ),
    );
  }
}
