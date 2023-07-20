import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../theme/styles.dart';
import '../../../../theme/text_style.dart';

class ProfileItem extends StatelessWidget {
  final AppStyle appStyle;
  final String title;
  final GestureTapCallback? onTap;

  /// svg icon path
  final String src;
  const ProfileItem({
    super.key,
    required this.appStyle,
    required this.title,
    required this.src,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(appStyle.scaleX(25)),
      color: const Color(0xFF2D251F),
      child: InkWell(
        borderRadius: BorderRadius.circular(appStyle.scaleX(25)),
        splashFactory: InkSplash.splashFactory,
        splashColor: Colors.white.withOpacity(0.2),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            appStyle.scaleX(40),
            appStyle.scaleX(15),
            appStyle.scaleX(55),
            appStyle.scaleX(15),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: appStyle.text.font(mulishBold700, sizePx: 15, heightPx: 25),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: appStyle.scaleX(15)),
              SvgPicture.asset(
                src,
                fit: BoxFit.contain,
                height: appStyle.scaleX(40),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
