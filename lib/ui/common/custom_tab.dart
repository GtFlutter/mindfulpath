import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../theme/styles.dart';

class CustomTab extends StatelessWidget {
  final AppStyle style;
  final String text;
  final bool smallTab;

  const CustomTab({super.key, required this.text, required this.style}) : smallTab = false;
  const CustomTab.small({super.key, required this.text, required this.style}) : smallTab = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(style.scaleX(40)),
          side: const BorderSide(color: AppColors.primaryColor),
        ),
      ),
      width: smallTab ? null : style.scaleX(100),
      padding: smallTab
          ? EdgeInsets.symmetric(
              horizontal: style.scaleX(12.5),
              vertical: style.scaleX(5),
            )
          : EdgeInsets.symmetric(
              horizontal: style.scaleX(5),
              vertical: style.scaleX(11),
            ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
