import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../theme/styles.dart';
import '../../../../theme/text_style.dart';
import '../../../../util/assets.dart';

class PlaylistItem extends StatelessWidget {
  final String title;
  final AppStyle style;
  final GestureTapCallback? onTap;

  const PlaylistItem({super.key, required this.title, required this.style, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(style.scaleX(40)),
      color: const Color(0xFFD9D9D9).withOpacity(0.1),
      child: InkWell(
        borderRadius: BorderRadius.circular(style.scaleX(40)),
        splashFactory: InkSplash.splashFactory,
        splashColor: Colors.white.withOpacity(0.2),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: style.scaleX(20), vertical: style.scaleX(6)),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: style.text.font(mulishMedium500, sizePx: 15),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: style.scaleX(15)),
              SvgPicture.asset(
                SvgPaths.arrowGoRight,
                height: style.scaleX(17.5),
                fit: BoxFit.contain,
              ),
              SizedBox(width: style.scaleX(15)),
              SvgPicture.asset(
                SvgPaths.bgShape,
                fit: BoxFit.contain,
                height: style.scaleX(37.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
