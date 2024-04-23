import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meditation_app/helper/string_converter.dart';
import 'package:meditation_app/provider/course_provider.dart';
import 'package:meditation_app/provider/video_provider.dart';
import 'package:meditation_app/theme/colors.dart';
import 'package:meditation_app/theme/styles.dart';
import 'package:meditation_app/theme/text_style.dart';
import 'package:meditation_app/ui/common/media_image_card.dart';
import 'package:meditation_app/util/assets.dart';


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
  final int? index;
  final int? IsSelected;
  final void Function()? onPlay;
  final void Function()? onRemovePress;
  const DownloadDetailItem({super.key, required this.appStyle, required this.model,this.index,this.onPlay,this.IsSelected,this.onRemovePress});

  @override
  ConsumerState<DownloadDetailItem> createState() => _DetailItemState();
}

class _DetailItemState extends ConsumerState<DownloadDetailItem> {

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = widget.appStyle.text.font(mulishRegular400, sizePx: 9);
    var getCategory=0;

    var radius = widget.appStyle.scaleX(10);
    var dimension = widget.appStyle.scaleX(97);
    final coursePro = ref.watch(courseProvider);

    coursePro.downloadResponse.any((element){
      getCategory=int.parse(element.categoryId??"");
      return true;
    });



    return GestureDetector(
      onTap: (){
        widget.onPlay!();

      },
      child: Container(
        decoration: ShapeDecoration(
          color: const Color(0xFF1B1B1B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.appStyle.scaleX(10)),
            side: BorderSide(
              color: (ref.watch(videoProvider).isSelected==widget.index)?AppColors.primaryColor:AppColors.detailItemBgColor,
              width: widget.appStyle.scaleX(0.5),
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
          ),
        ),
        alignment: Alignment.center,
        child: IntrinsicHeight(
          child: Row(
            children: [
              MediaImageCard(
                appStyle: widget.appStyle,
                imgUrl: widget.model.categoryImage ?? '',
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
                            Text(
                              '${widget.model.categoryName}',
                              style: textStyle.copyWith(color: AppColors.categoryNameColor),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(width: widget.appStyle.scaleX(150)),
                          ],
                        ),

                      ],
                    ),

                  ],
                ),
              ),
              IconButton(
                onPressed: (){
                  widget.onRemovePress!();
                  // setState(() async {
                  //   if(coursePro.downloadVideoResponse.length==1){
                  //     coursePro.ref.read(courseProvider.notifier).pushData=true;
                  //     coursePro.ref.read(courseProvider.notifier).deleteCategoryVideo(getCategory,context);
                  //     coursePro.ref.read(courseProvider.notifier).deleteVideo(int.parse(widget.model.videoId??""),context);
                  //
                  //   }else{
                  //    await  coursePro.ref.read(courseProvider.notifier).deleteVideo(int.parse(widget.model.videoId??""),context);
                  //   }
                  // });


                },
                icon: SvgPicture.asset(
                  SvgPaths.remove,
                  height: 17,
                  fit: BoxFit.contain,
                ),
                style: IconButton.styleFrom(
                    tapTargetSize:
                    MaterialTapTargetSize.shrinkWrap),
              ),

            ],
          ),
        ),
      ),
    );
  }
}