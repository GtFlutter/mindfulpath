import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../theme/colors.dart';
import '../../../../theme/styles.dart';
import '../../../../theme/text_style.dart';
import '../../../../util/assets.dart';

class CustomMediaButton extends StatelessWidget {
  final String duration;
  final AppStyle appStyle;
  const CustomMediaButton({super.key, required this.appStyle, required this.duration});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: appStyle.scaleX(70)),
      margin: EdgeInsets.only(bottom: appStyle.scaleX(5)),
      padding: EdgeInsets.all(appStyle.scaleX(1.5)),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: appStyle.scaleX(0.5), color: AppColors.primaryColor),
          borderRadius: BorderRadius.circular(appStyle.scaleX(25)),
        ),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(appStyle.scaleX(25)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
              child: Container(color: AppColors.detailItemBgColor.withOpacity(0.4)),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: appStyle.scaleX(8), vertical: appStyle.scaleX(4)),
            child: Row(
              children: [
                SvgPicture.asset(
                  SvgPaths.play,
                  width: appStyle.scaleX(12),
                  height: appStyle.scaleX(12),
                  fit: BoxFit.contain,
                ),
                SizedBox(width: appStyle.scaleX(5)),
                Expanded(
                  child: Text(
                    duration,
                    style: appStyle.text.font(mulishRegular400, sizePx: 9),
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
