// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/helper/route/route_paths.dart';
import 'package:meditation_app/theme/styles.dart';
import 'package:meditation_app/theme/text_style.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/ui/screens/search/widget/all_videos_list.dart';
import 'package:meditation_app/ui/screens/search/widget/options_selection_sheet.dart';

import '../../../util/assets.dart';

List<String> recentSearchHistory = [
  'Eating for Heart Health',
  'The Power of Nutrients',
  'Transcendental Meditation',
  'Physical Activity and Cancer Prevention',
  'Creating a Personalized Cancer Prevention Plan',
];

class FeaturedSearchScreen extends StatefulWidget {
  const FeaturedSearchScreen({super.key});

  @override
  State<FeaturedSearchScreen> createState() => _FeaturedSearchScreenState();
}

class _FeaturedSearchScreenState extends State<FeaturedSearchScreen> {
  static AppStyle _style = AppStyle();


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _style = AppStyle(screenSize: size);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BackgroundImage(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: _style.scaleX(20)),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: _style.scaleX(15)),
                  margin: EdgeInsets.symmetric(vertical: _style.scaleX(10)),
                  alignment: Alignment.center,
                  decoration: ShapeDecoration(
                    color: Color(0xFF2D251F),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_style.scaleX(22.5))),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        SvgPaths.search,
                        height: _style.scale * 20,
                        fit: BoxFit.contain,
                        color: Colors.white,
                      ),
                      SizedBox(width: _style.scaleX(14)),
                      Flexible(
                        child: TextField(
                          readOnly: true,
                          textInputAction: TextInputAction.search,
                          keyboardType: TextInputType.text,
                          onTap: () {
                            context.replace(RoutePath.search);
                          },
                          style: _style.text.font(mulishMedium500, sizePx: 11, color: Colors.white, spacingPc: 10),
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Hinted search text',
                            hintStyle:
                            _style.text.font(mulishMedium500, sizePx: 10, color: Colors.white.withOpacity(0.5)),
                            contentPadding: EdgeInsets.only(bottom: _style.scaleX(9)),
                            constraints: BoxConstraints(maxHeight: _style.scaleX(40)),
                            alignLabelWithHint: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: AllVideosList(
                  style: _style,
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void selectCategory() {
    showModalBottomSheet(
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: 400,
        maxWidth: 500,
        minHeight: 300,
      ),
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(_style.scaleX(15)),
          topRight: Radius.circular(_style.scaleX(15)),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      builder: (context) {
        var items = ['Meditation', 'Diet', 'Nutrition', 'Exercise', 'Cancer prevention'];
        return OptionsSelectionSheet.multiSelect(
          items: items,
          selectedItems: ['Cancer prevention'],
          title: 'Category',
        );
      },
      context: context,
      enableDrag: false,
    );
  }

  void selectTime() {
    showModalBottomSheet(
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: 400,
        maxWidth: 500,
        minHeight: 300,
      ),
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(_style.scaleX(15)),
          topRight: Radius.circular(_style.scaleX(15)),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      builder: (context) {
        var items = ['3 min', '5 min', '10 min', '15 min', '45 min', '60+ min'];
        return OptionsSelectionSheet.singleSelect(
          items: items,
          useGridLayout: true,
          title: 'Time',
        );
      },
      context: context,
      enableDrag: false,
    );
  }
}
