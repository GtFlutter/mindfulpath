import 'package:flutter/material.dart';

import '../../../../theme/colors.dart';
import '../../../../theme/styles.dart';
import '../../../../theme/text_style.dart';
import '../../../../util/assets.dart';
import '../../../common/outlined_icon_button.dart';
import 'cutom_media_button.dart';

class DIModel {
  final String imgUrl;
  final String duration;
  final String title;
  final String auther;
  final String category;

  DIModel({
    required this.imgUrl,
    required this.duration,
    required this.title,
    required this.auther,
    required this.category,
  });
}

class DetailItem extends StatelessWidget {
  final AppStyle appStyle;
  final DIModel model;
  final String index;
  const DetailItem({super.key, required this.appStyle, required this.model, required this.index});

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = appStyle.text.font(mulishRegular400, sizePx: 9);
    return Container(
      alignment: Alignment.center,
      constraints: BoxConstraints(maxWidth: appStyle.scaleX(350)),
      margin: EdgeInsets.only(bottom: appStyle.scaleX(25), right: appStyle.scaleX(15)),
      decoration: ShapeDecoration(
        color: const Color(0xFF1B1B1B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(appStyle.scaleX(10)),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(appStyle.scaleX(10)),
                  child: Image.network(
                    model.imgUrl,
                    width: appStyle.scaleX(100),
                    height: appStyle.scaleX(100),
                    fit: BoxFit.cover,
                  ),
                ),
                IntrinsicHeight(
                  child: CustomMediaButton(
                    appStyle: appStyle,
                    duration: model.duration,
                  ),
                ),
              ],
            ),
            SizedBox(width: appStyle.scaleX(20)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$index ${model.title}',
                    style: appStyle.text.font(mulishSemiBold600, sizePx: 14, color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: appStyle.scaleX(12)),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: appStyle.scaleX(10),
                    children: [
                      Text(
                        model.auther,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textStyle.copyWith(color: AppColors.autherNameColor),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '●',
                            style: appStyle.text.font(mulishSemiBold600, sizePx: 14, color: AppColors.primaryColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(width: appStyle.scaleX(5)),
                          Flexible(
                            child: Text(
                              model.category,
                              style: textStyle.copyWith(color: AppColors.categoryNameColor),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                OutlinedIconButton(
                  appStyle: appStyle,
                  // svgIconSrc: SvgPaths.bookmarkSelected,
                  svgIconSrc: SvgPaths.bookmarkUnselected,
                ),
                OutlinedIconButton(
                  appStyle: appStyle,
                  svgIconSrc: SvgPaths.addToPlaylist,
                ),
              ],
            ),
            SizedBox(width: appStyle.scaleX(10)),
          ],
        ),
      ),
    );
  }
}
