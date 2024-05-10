import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meditation_app/theme/styles.dart';

import '../../theme/text_style.dart';
import '../../util/assets.dart';

class CommonBottomSheetWidget extends StatelessWidget {
  final AppStyle style;
  final String title;
  final String doneLable;
  final VoidCallback? onDone;
  final VoidCallback? onCancle;

  const CommonBottomSheetWidget({
    super.key,
    required this.style,
    this.onDone,
    this.onCancle,
    required this.title,
    required this.doneLable,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: style.scaleX(12), vertical: style.scaleX(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (onCancle != null)
            IconButton(
              onPressed: onCancle,
              icon: SvgPicture.asset(
                SvgPaths.remove,
                width: style.scaleX(25),
                fit: BoxFit.fitWidth,
              ),
            ),
          Flexible(
            child: Text(
              title,
              style: style.text.font(mulishSemiBold600, sizePx: 18),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 5,
            ),
          ),
          TextButton(
            onPressed: onDone,
            style: TextButton.styleFrom(
              textStyle: style.text.font(mulishMedium500, sizePx: 15),
              foregroundColor: Colors.white,
            ),
            child: Text(doneLable),
          ),
        ],
      ),
    );
  }
}
