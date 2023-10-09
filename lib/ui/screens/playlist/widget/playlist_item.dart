import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meditation_app/theme/colors.dart';

import '../../../../theme/styles.dart';
import '../../../../theme/text_style.dart';
import '../../../../util/assets.dart';

class PlaylistItem extends StatelessWidget {
  final String title;
  final AppStyle style;
  final GestureTapCallback? onTap;
  final bool isCreateTile;

  const PlaylistItem({super.key, required this.title, required this.style, this.onTap}):isCreateTile=false;
  const PlaylistItem.create({super.key, required this.title, required this.style, this.onTap}):isCreateTile=true;

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
              if (isCreateTile)...[
                Icon(
                  Icons.add_outlined,
                  size: style.scaleX(17.5),
                  color: AppColors.primaryColor,
                ),
              ] else...[
                SvgPicture.asset(
                  SvgPaths.arrowGoRight,
                  height: style.scaleX(17.5),
                  fit: BoxFit.contain,
                ),
              ],
              SizedBox(width: style.scaleX(15)),
              SvgPicture.asset(
                SvgPaths.bgShape,
                fit: BoxFit.contain,
                height: style.scaleX(37.5),
              ),
              if (!isCreateTile)...[
                PopupMenuButton(
                  padding: EdgeInsets.zero,
                  tooltip: '',
                  icon: const Icon(
                    Icons.more_vert_outlined,
                    color: AppColors.popupMenuColor,
                  ),
                  color: AppColors.popupMenuItemColor,
                  position: PopupMenuPosition.under,
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                        height: style.scaleX(30),
                        child: Text(
                          'Delete',
                          style: style.text.font(mulishSemiBold600, sizePx: 12, color: AppColors.deleteMenuText),
                        ),
                      ),
                    ];
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
