import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../theme/colors.dart';
import '../../theme/styles.dart';

class OutlinedIconButton extends StatelessWidget {
  final AppStyle appStyle;
  final double padding;
  final double stroke;
  final double iconSize;
  final String svgIconSrc;
  const OutlinedIconButton({
    super.key,
    required this.appStyle,
    this.padding = 5,
    this.stroke = 1,
    this.iconSize = 18,
    required this.svgIconSrc,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        splashFactory: InkSplash.splashFactory,
        splashColor: Colors.white.withOpacity(0.2),
        onTap: () {},
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(appStyle.scaleX(padding)),
          decoration: ShapeDecoration(
            shape: CircleBorder(
              side: BorderSide(color: AppColors.primaryColor, width: appStyle.scaleX(1)),
            ),
          ),
          child: SvgPicture.asset(
            svgIconSrc,
            height: appStyle.scaleX(iconSize),
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
    );
  }
}
