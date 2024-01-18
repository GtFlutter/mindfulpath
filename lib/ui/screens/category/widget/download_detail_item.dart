import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/helper/string_converter.dart';
import 'package:meditation_app/theme/colors.dart';
import 'package:meditation_app/theme/styles.dart';
import 'package:meditation_app/theme/text_style.dart';
import 'package:meditation_app/ui/common/media_image_card.dart';


class DDIModal {
  int? id;
  String? videoId;
  String? videoName;
  String? videoFile;
  String? videoDuration;
  String? categoryId;
  String? categoryName;
  String? categoryImage;

  DDIModal({this.id, this.videoId, this.videoName, this.videoFile, this.videoDuration, this.categoryId, this.categoryName, this.categoryImage});
}

class DownloadDetailItem extends ConsumerStatefulWidget {
  final AppStyle appStyle;
  final DDIModal model;
  const DownloadDetailItem({super.key, required this.appStyle, required this.model});

  @override
  ConsumerState<DownloadDetailItem> createState() => _DetailItemState();
}

class _DetailItemState extends ConsumerState<DownloadDetailItem> {

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = widget.appStyle.text.font(mulishRegular400, sizePx: 9);

    var radius = widget.appStyle.scaleX(10);
    var dimension = widget.appStyle.scaleX(97);

    return Container(
      decoration: ShapeDecoration(
        color: const Color(0xFF1B1B1B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.appStyle.scaleX(10)),
        ),
      ),
      alignment: Alignment.center,
      child: IntrinsicHeight(
        child: Row(
          children: [
            MediaImageCard(
              appStyle: widget.appStyle,
              imgUrl: widget.model.videoFile ?? '',
              duration: widget.model.videoDuration?.toDuration ?? '',
              imgRadius: radius,
              imgSize: dimension,
            ),
            SizedBox(width: widget.appStyle.scaleX(20)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${widget.model.videoName}',
                    style: widget.appStyle.text.font(mulishSemiBold600, sizePx: 14, color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: widget.appStyle.scaleX(12)),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: widget.appStyle.scaleX(10),
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '●',
                            style: widget.appStyle.text.font(mulishSemiBold600, sizePx: 14, color: AppColors.primaryColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(width: widget.appStyle.scaleX(5)),
                          Flexible(
                            child: Text(
                              '${widget.model.categoryName}',
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
          ],
        ),
      ),
    );
  }
}