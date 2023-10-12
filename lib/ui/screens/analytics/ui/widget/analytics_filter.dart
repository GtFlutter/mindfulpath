import 'package:flutter/cupertino.dart';
import 'package:meditation_app/ui/screens/analytics/data/model/response/category_and_video_name_model.dart';

import '../../../../../theme/styles.dart';
import '../../../../common/custom_dropdown_button.dart';

class AnalyticsFilter extends StatefulWidget {
  final List<ItemName> categoryList;
  final ValueChanged<ItemName?> onCategoryChanged;
  final List<ItemName> videoList;
  final ValueChanged<ItemName?> onVideoChanged;

  const AnalyticsFilter({
    super.key,
    required this.categoryList,
    required this.onCategoryChanged,
    required this.videoList,
    required this.onVideoChanged,
  });

  @override
  State<AnalyticsFilter> createState() => _AnalyticsFilterState();
}

class _AnalyticsFilterState extends State<AnalyticsFilter> {
  final List<String> allOverList = [
    'Day',
    'Week',
    'Month',
  ];
  ItemName? categoryValue;
  ItemName? videosValue;
  String? allOverValue;

  static AppStyle _style = AppStyle();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _style = AppStyle(screenSize: size);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _style.scaleX(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: CustomDropDownButton(
                value: categoryValue,
                appStyle: _style,
                items: widget.categoryList,
                maxHeight: size.height * 0.6,
                width: size.shortestSide * 0.4,
                onChanged: widget.onCategoryChanged,
                hint: 'Category',
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: CustomDropDownButton(
                value: videosValue,
                appStyle: _style,
                items: widget.videoList,
                maxHeight: size.height * 0.6,
                width: size.shortestSide * 0.4,
                onChanged: widget.onVideoChanged,
                hint: 'Videos',
              ),
            ),
          ),
          // Expanded(
          //   child: Align(
          //     alignment: Alignment.centerRight,
          //     child: CustomDropDownButton(
          //       value: allOverValue,
          //       appStyle: _style,
          //       items: allOverList,
          //       width: size.shortestSide * 0.3,
          //       maxHeight: size.height * 0.6,
          //       onChanged: (value) {
          //         setState(() {
          //           allOverValue = value;
          //         });
          //       },
          //       hint: 'All over',
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
