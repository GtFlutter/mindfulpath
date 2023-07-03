import 'package:flutter/material.dart';

import '../../../../main.dart';
import '../../../../theme/text_style.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final String? subTitle;
  final Color? subTitleColor;
  final double? subTitleFontSize;

  final EdgeInsetsGeometry? padding;

  const CustomHeader({
    super.key,
    required this.title,
    this.subTitle,
    this.padding,
    this.subTitleColor,
    this.subTitleFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: $style.scale * 25, vertical: $style.scale * 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: $style.text.font(mulishMedium500, sizePx: 22.5, color: Colors.white),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (subTitle != null) ...[
            SizedBox(height: $style.scale * 5),
            Text(
              subTitle!,
              style: $style.text.font(mulishMedium500, sizePx: subTitleFontSize ?? 17, color: subTitleColor),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
