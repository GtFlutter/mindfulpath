import 'package:flutter/cupertino.dart';

import '../../../../../theme/styles.dart';
import '../../../../common/custom_dropdown_button.dart';

class AnalyticsFilter extends StatefulWidget {
  const AnalyticsFilter({super.key});

  @override
  State<AnalyticsFilter> createState() => _AnalyticsFilterState();
}

class _AnalyticsFilterState extends State<AnalyticsFilter> {
  final List<String> categoryList = [
    'Nutrition',
    'Meditation',
    'Cancer preventation',
    'Diet',
  ];
  final List<String> videosList = [
    'Boosting your Immunity',
    'Cooking for health',
    'Eating for heart Health',
    'Eating for energy',
  ];
  final List<String> allOverList = [
    'Day',
    'Week',
    'Month',
  ];
  String? categoryValue;
  String? videosValue;
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
                items: categoryList,
                maxHeight: size.height * 0.6,
                width: size.shortestSide * 0.4,
                onChanged: (value) {
                  setState(() {
                    categoryValue = value;
                  });
                },
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
                items: videosList,
                maxHeight: size.height * 0.6,
                width: size.shortestSide * 0.4,
                onChanged: (value) {
                  setState(() {
                    videosValue = value;
                  });
                },
                hint: 'Videos',
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: CustomDropDownButton(
                value: allOverValue,
                appStyle: _style,
                items: allOverList,
                width: size.shortestSide * 0.3,
                maxHeight: size.height * 0.6,
                onChanged: (value) {
                  setState(() {
                    allOverValue = value;
                  });
                },
                hint: 'All over',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
