import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../theme/colors.dart';
import '../../../../theme/styles.dart';
import '../../../../theme/text_style.dart';
import '../../../../util/assets.dart';

class FilterIconButton extends StatelessWidget {
  const FilterIconButton({
    super.key,
    required AppStyle style,
    required this.title,
    this.onTap,
  }) : _style = style;

  final AppStyle _style;
  final String title;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          horizontal: _style.scaleX(15),
          vertical: _style.scaleX(5),
        ),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: _style.scaleX(0.50), color: AppColors.appBarBorderColor),
            borderRadius: BorderRadius.circular(_style.scaleX(25)),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: _style.text.font(mulishMedium500, sizePx: 10),
            ),
            SizedBox(width: _style.scaleX(7.5)),
            SvgPicture.asset(
              SvgPaths.arrowDown,
              width: _style.scaleX(15),
              fit: BoxFit.fitWidth,
              color: AppColors.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
