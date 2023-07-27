import 'package:flutter/material.dart';

import '../../../../theme/colors.dart';
import '../../../../theme/styles.dart';
import '../../../../theme/text_style.dart';

class OutlinedSelectableButton extends StatelessWidget {
  final AppStyle appStyle;
  final bool selected;
  final GestureTapCallback? onTap;
  final String title;
  final int? maxLines;
  final TextOverflow? overflow;
  final AlignmentGeometry? alignment;
  final BoxConstraints? constraints;

  const OutlinedSelectableButton({
    super.key,
    required this.appStyle,
    required this.selected,
    this.onTap,
    required this.title,
    this.maxLines,
    this.overflow,
    this.alignment,
    this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: alignment,
        constraints: constraints,
        padding: EdgeInsets.symmetric(
          vertical: appStyle.scaleX(8.5),
          horizontal: appStyle.scaleX(20),
        ),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(appStyle.scaleX(40)),
            side: BorderSide(color: AppColors.primaryColor, width: appStyle.scaleX(0.5)),
          ),
          color: selected ? AppColors.primaryColor : null,
        ),
        child: Text(
          title,
          style: appStyle.text.font(
            mulishSemiBold600,
            sizePx: 10,
            color: selected ? Colors.black : Colors.white,
          ),
          textAlign: TextAlign.center,
          maxLines: maxLines,
          overflow: overflow,
        ),
      ),
    );
  }
}
