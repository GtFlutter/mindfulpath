import 'package:flutter/material.dart';
import 'package:meditation_app/helper/string_converter.dart';
import 'package:meditation_app/theme/colors.dart';
import 'package:meditation_app/theme/text_style.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/ui/screens/category/temp_data_file.dart';
import 'package:meditation_app/ui/screens/category/widget/detail_item.dart';

import '../../../theme/styles.dart';
import '../../common/media_player/app_video_player.dart';

class DetailCategoryScreen extends StatefulWidget {
  const DetailCategoryScreen({super.key});

  @override
  State<DetailCategoryScreen> createState() => _DetailCategoryScreenState();
}

class _DetailCategoryScreenState extends State<DetailCategoryScreen> {
  static AppStyle _style = AppStyle();
  ScrollController controller = ScrollController();
  String link2 = 'https://assets.mixkit.co/videos/preview/mixkit-man-holding-neon-light-1238-large.mp4';
  String link = 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';
  bool _showVideo = false;
  DIModel? _videoDetail;

  String description =
      'Nutrition is essential for maintaining good health and preventing chronic diseases. A balanced and varied diet that includes a variety of whole foods. ';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;

    var size = MediaQuery.of(context).size;
    _style = AppStyle(screenSize: size);
    TextStyle textStyle = _style.text.font(mulishRegular400, sizePx: 14);

    return Scaffold(
      body: BackgroundImage.network(
        imgUrl:
            'https://images.pexels.com/photos/6740518/pexels-photo-6740518.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        hideImage: isLandscape && _showVideo,
        child: SafeArea(
          left: false,
          right: false,
          bottom: false,
          child: Padding(
            padding: isLandscape && _showVideo ? EdgeInsets.zero : EdgeInsets.symmetric(horizontal: _style.scaleX(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_showVideo) ...[
                  if (!isLandscape) SizedBox(height: _style.scaleX(25)),
                  Flexible(
                    flex: isLandscape ? 1 : 0,
                    child: Container(
                      width: !isLandscape ? null : double.infinity,
                      height: !isLandscape ? null : double.infinity,
                      alignment: !isLandscape ? null : Alignment.topCenter,
                      constraints: !isLandscape ? BoxConstraints(maxHeight: size.height * 0.4) : null,
                      child: AppVideoPlayer(
                        key: const ValueKey('value'),
                        url: link,
                        style: _style,
                        isLandscape: isLandscape,
                        onBackPress: () {
                          if (_showVideo) {
                            setState(() {
                              _showVideo = false;
                              _videoDetail = null;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  if (_videoDetail != null && (!_showVideo || !isLandscape)) ...[
                    SizedBox(height: _style.scaleX(15)),
                    Text(
                      _videoDetail!.title,
                      style: _style.text.font(mulishSemiBold600, sizePx: 20, color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: _style.scaleX(7)),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: _style.scaleX(10),
                      children: [
                        Text(
                          _videoDetail!.auther,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textStyle.copyWith(color: AppColors.autherNameColor),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '●',
                              style: _style.text.font(mulishSemiBold600, sizePx: 14, color: AppColors.primaryColor),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(width: _style.scaleX(5)),
                            Flexible(
                              child: Text(
                                _videoDetail!.category,
                                style: textStyle.copyWith(color: AppColors.autherNameColor),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: _style.scaleX(30)),
                  ],
                ] else
                  Expanded(
                    flex: 2,
                    child: IntroWidget(
                      description: description,
                      title: 'Nutrution',
                      style: _style,
                    ),
                  ),
                if (!isLandscape || !_showVideo)
                  Expanded(
                    flex: 3,
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: controller,
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.only(
                        bottom: _style.scale * 100,
                        top: _style.scale * 10,
                      ),
                      itemCount: TempData.listDiModel.length,
                      itemBuilder: (context, index) {
                        var model = TempData.listDiModel[index];
                        return GestureDetector(
                          onTap: () {
                            if (!_showVideo) {
                              setState(() {
                                _showVideo = true;
                                _videoDetail = DIModel(
                                  imgUrl: model.imgUrl,
                                  duration: model.duration,
                                  title: '$index ${model.title}',
                                  auther: model.auther,
                                  category: model.category,
                                );
                              });
                            }
                          },
                          child: DetailItem(
                            appStyle: _style,
                            model: TempData.listDiModel[index],
                            index: '$index',
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) => SizedBox(
                        height: _style.scaleX(25),
                      ),
                    ),
                  ),
                // Expanded(
                //   child: ListView.builder(
                //     physics: const AlwaysScrollableScrollPhysics(),
                //     controller: controller,
                //     scrollDirection: Axis.vertical,
                //     padding: EdgeInsets.only(bottom: _style.scale * 100, top: _style.scale * 10),
                //     itemCount: mainList.length,
                //     itemBuilder: (context, index) {
                //       var subList = mainList[index];
                //       return SizedBox(
                //         height: _style.scaleX(110),
                //         child: ListView.builder(
                //           itemCount: subList.length,
                //           scrollDirection: Axis.horizontal,
                //           padding: EdgeInsets.only(left: _style.scaleX(20)),
                //           itemBuilder: (context, i) {
                //             return DetailItem(
                //               _style: _style,
                //               _videoDetail!: subList[i],
                //               index: '$index - $i',
                //             );
                //           },
                //         ),
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class IntroWidget extends StatelessWidget {
  final String title;
  final String description;
  final AppStyle style;

  const IntroWidget({
    super.key,
    required this.title,
    required this.description,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: style.scaleX(15)),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Spacer(flex: 3),
          Text(
            title,
            style: style.text.font(
              brandonMedium500,
              sizePx: 30,
              color: AppColors.primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: style.scaleX(25)),
          Text.rich(
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: style.text.font(
              brandonBold700,
              sizePx: 14,
              color: AppColors.primaryColor,
            ),
            TextSpan(
              text: description.firstWord(),
              children: [
                TextSpan(
                  text: description.removeFirstWord(),
                  style: style.text.font(
                    mulishLight300,
                    sizePx: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}
