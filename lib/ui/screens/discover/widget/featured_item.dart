import 'package:flutter/material.dart';
import 'package:meditation_app/data/model/response/video_list_response.dart';
import 'package:meditation_app/theme/colors.dart';
import 'package:meditation_app/theme/styles.dart';
import 'package:meditation_app/theme/text_style.dart';
import 'featured_item_painter.dart';

class FCTempModel {
  final String title;
  final String imgUrl;
  FCTempModel(this.title, this.imgUrl);
}

class FeaturedItem extends StatelessWidget {
  final VideoListResponse model;
  final DashboardCustomImageClipper clipper;
  final AppStyle style;
  const FeaturedItem(this.model, this.clipper, {super.key, required this.style});

  @override
  Widget build(BuildContext context) {
    final double cardRadius = style.scaleX(26.5);
    final double cardWidth = style.scaleX(209);

    return Container(
      width: cardWidth,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cardRadius)),
        gradient: const LinearGradient(
          colors: [AppColors.primaryGradientColor, AppColors.secondaryGradientColor],
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              style.scaleX(30),
              style.scaleX(15),
              style.scaleX(30),
              style.scaleX(9),
            ),
            child: Text(
              model.title ?? '',
              style: style.text.font(mulishRegular400, sizePx: 12.5),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: CustomPaint(
              painter: ShadowPainter(clipper),
              child: ClipPath(
                clipper: clipper,
                child: Container(
                  width: cardWidth * 0.55,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(model.thumbnailImage ?? ''), fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
