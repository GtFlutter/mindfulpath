import 'package:flutter/material.dart';
import 'package:meditation_app/helper/string_converter.dart';
import 'package:meditation_app/theme/colors.dart';
import 'package:meditation_app/theme/text_style.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/ui/screens/category/temp_data_file.dart';
import 'package:meditation_app/ui/screens/category/widget/detail_item.dart';

import '../../../theme/styles.dart';

class DetailCategoryScreen extends StatefulWidget {
  const DetailCategoryScreen({super.key});

  @override
  State<DetailCategoryScreen> createState() => _DetailCategoryScreenState();
}

class _DetailCategoryScreenState extends State<DetailCategoryScreen> {
  static AppStyle _style = AppStyle();
  ScrollController controller = ScrollController();

  String description =
      'Nutrition is essential for maintaining good health and preventing chronic diseases. A balanced and varied diet that includes a variety of whole foods. ';
  List<List<DIModel>> mainList = [];

  static List<List<DIModel>> getList(List<DIModel> listDiModel) {
    List<List<DIModel>> subLists = [];

    for (var i = 0; i < listDiModel.length; i += 3) {
      var endIndex = i + 3;
      if (endIndex > listDiModel.length) {
        endIndex = listDiModel.length;
      }
      var subList = listDiModel.sublist(i, endIndex);
      subLists.add(subList);
    }

    return subLists;
  }

  @override
  void initState() {
    mainList.addAll(getList(TempData.listDiModel));
    controller.addListener(listner);
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(listner);
    controller.dispose();
    super.dispose();
  }

  void resetList() {
    setState(() {
      mainList.clear();
      mainList.addAll(getList(TempData.listDiModel));
    });
    controller.jumpTo(0);
  }

  void listner() {
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      if (mounted) {
        setState(() {
          mainList.addAll(getList(TempData.listDiModel));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _style = AppStyle(screenSize: size);

    return Scaffold(
      body: BackgroundImage.network(
        imgUrl:
            'https://images.pexels.com/photos/6740518/pexels-photo-6740518.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        child: SafeArea(
          left: false,
          right: false,
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: _style.scaleX(35)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: _style.scaleX(50)),
                    TextButton(
                      onPressed: resetList,
                      child: Text(
                        'Nutrition Verticle',
                        style: _style.text.font(
                          brandonMedium500,
                          sizePx: 30,
                          color: AppColors.primaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Text(
                    //   'Nutrition',
                    //   style: _style.text.font(
                    //     brandonMedium500,
                    //     sizePx: 30,
                    //     color: AppColors.primaryColor,
                    //   ),
                    //   textAlign: TextAlign.center,
                    // ),
                    SizedBox(height: _style.scaleX(25)),
                    Text.rich(
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: _style.text.font(
                        brandonBold700,
                        sizePx: 14,
                        color: AppColors.primaryColor,
                      ),
                      TextSpan(
                        text: description.firstWord(),
                        children: [
                          TextSpan(
                            text: description.removeFirstWord(),
                            style: _style.text.font(
                              mulishLight300,
                              sizePx: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: _style.scaleX(50)),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: controller,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.only(bottom: _style.scale * 100, top: _style.scale * 10),
                  itemCount: mainList.length,
                  itemBuilder: (context, index) {
                    var subList = mainList[index];
                    return SizedBox(
                      height: _style.scaleX(110),
                      child: ListView.builder(
                        itemCount: subList.length,
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.only(left: _style.scaleX(20)),
                        itemBuilder: (context, i) {
                          return DetailItem(
                            appStyle: _style,
                            model: subList[i],
                            index: '$index - $i',
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
