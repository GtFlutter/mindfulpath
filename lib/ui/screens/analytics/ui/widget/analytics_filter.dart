import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/ui/screens/analytics/helper/analytics_enums.dart';
import 'package:meditation_app/ui/screens/analytics/data/model/response/category_and_video_name_model.dart';

import '../../../../../theme/styles.dart';
import '../../../../common/custom_dropdown_button.dart';

class AnalyticsFilter extends StatefulWidget {
  final List<ItemName> categories;
  final List<ItemName> videos;
  final List<FilterDuration> durationtypes;
  final ItemName? categoryValue;
  final ItemName? videoValue;
  final FilterDuration? durationtypeValue;
  final ValueChanged<ItemName?> onCategoryChanged;
  final ValueChanged<ItemName?> onVideoChanged;
  final ValueChanged<FilterDuration?> onDurationTypeChanged;
  final AppStyle style;
  final Size screenSize;

  const AnalyticsFilter(
    this.style,
    this.screenSize, {
    super.key,
    required this.categories,
    required this.videos,
    required this.durationtypes,
    required this.categoryValue,
    required this.videoValue,
    required this.durationtypeValue,
    required this.onCategoryChanged,
    required this.onVideoChanged,
    required this.onDurationTypeChanged,
  });

  @override
  State<AnalyticsFilter> createState() => _AnalyticsFilterState();
}

class _AnalyticsFilterState extends State<AnalyticsFilter> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.style.scaleX(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: CustomDropDownButton<ItemName>(
                key: const ValueKey<int>(0),
                value: widget.categoryValue,
                appStyle: widget.style,
                items: widget.categories,
                maxHeight: widget.screenSize.height * 0.6,
                width: widget.screenSize.shortestSide * 0.4,
                onChanged: widget.onCategoryChanged,
                hint: 'Category',
              ),
            ),
          ),
          /*Expanded(
            child: Align(
              alignment: Alignment.center,
              child: CustomDropDownButton<ItemName>(
                key: const ValueKey<int>(1),
                value: widget.videoValue,
                appStyle: widget.style,
                items: widget.videos,
                maxHeight: widget.screenSize.height * 0.6,
                width: widget.screenSize.shortestSide * 0.4,
                onChanged: widget.onVideoChanged,
                hint: 'Videos',
              ),
            ),
          ),*/
          ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight:  widget.screenSize.height * 0.6,
                maxWidth: widget.screenSize.shortestSide * 0.4,
              ),
              child: const Text("Videos")),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: CustomDropDownButton<FilterDuration>(
                key: const ValueKey<int>(2),
                value: widget.durationtypeValue,
                appStyle: widget.style,
                items: widget.durationtypes,
                width: widget.screenSize.shortestSide * 0.3,
                maxHeight: widget.screenSize.height * 0.6,
                onChanged: widget.onDurationTypeChanged,
                hint: 'Duration',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
