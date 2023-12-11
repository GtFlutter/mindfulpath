import 'package:flutter/material.dart';
import 'package:meditation_app/data/model/response/category_list_reponse.dart';
import 'package:meditation_app/theme/styles.dart';
import 'package:meditation_app/ui/screens/analytics/data/model/response/category_and_video_name_model.dart';
import 'package:meditation_app/ui/screens/category/widget/tabs/paid_video_list_widget.dart';
import 'package:meditation_app/util/dimensions.dart';

import '../../../../theme/colors.dart';
import '../../../common/custom_dropdown_button.dart';
import 'custom_selecteable_button.dart';
import 'tabs/free_pdf_list_widget.dart';
import 'tabs/free_video_list_widget.dart';
import 'tabs/paid_pdf_list_widget.dart';

class ResourceDetailCategory extends StatefulWidget {
  final CategoryListResponse category;

  const ResourceDetailCategory({super.key, required this.category});

  @override
  State<ResourceDetailCategory> createState() => _ResourceDetailCategoryState();
}

class _ResourceDetailCategoryState extends State<ResourceDetailCategory> with TickerProviderStateMixin {
  late TabController _tabController;
  final List<ItemName> _filters = [ItemName(id: 0, title: 'Video'), ItemName(id: 1, title: 'PDF')];

  static AppStyle _style = AppStyle();

  /// Either 0(Video) or 1(PDF)
  late int filterIndex;

  /// Either 0(Free) or 1(Paid)
  late int courseIndex;

  @override
  void initState() {
    super.initState();
    filterIndex = 0;
    courseIndex = 0;
    _tabController = TabController(initialIndex: courseIndex, length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _changeTab(int filterIndex, int courseTypeIndex) {
    int currentTabIndex = _tabController.index;
    int goTo;
    if (filterIndex == 0 && courseTypeIndex == 0) {
      goTo = 0;
    } else if (filterIndex == 0 && courseTypeIndex == 1) {
      goTo = 1;
    } else if (filterIndex == 1 && courseTypeIndex == 0) {
      goTo = 2;
    } else if (filterIndex == 1 && courseTypeIndex == 1) {
      goTo = 3;
    } else {
      goTo = throw ArgumentError();
    }
    if (currentTabIndex == goTo) return;
    _tabController.animateTo(goTo);
  }

  void _changeFilter(ItemName? value) {
    if (value == null || value.id == filterIndex) return;
    setState(() {
      filterIndex = value.id;
      _changeTab(filterIndex, courseIndex);
    });
  }

  void _changeCourseType(int index) {
    if (index == courseIndex) return;
    setState(() {
      courseIndex = index;
      _changeTab(filterIndex, courseIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    _style = AppStyle(screenSize: MediaQuery.sizeOf(context));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomSelecteableButton(
              text: 'Free',
              selected: courseIndex == 0,
              onTap: () => _changeCourseType(0),
            ),
            const SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
            CustomSelecteableButton(
              text: 'Paid',
              selected: courseIndex == 1,
              onTap: () => _changeCourseType(1),
            ),
            const Spacer(),
            Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_style.scaleX(40)),
                  side: const BorderSide(color: AppColors.primaryColor),
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: _style.scaleX(10),
                vertical: _style.scaleX(3.5),
              ),
              child: CustomDropDownButton<ItemName>(
                value: _filters[filterIndex],
                appStyle: _style,
                items: _filters,
                width: _style.scaleX(120),
                maxHeight: _style.scaleX(150),
                onChanged: _changeFilter,
                hint: 'Filter',
              ),
            ),
          ],
        ),
        SizedBox(height: _style.scaleX(Dimensions.PADDING_SIZE_DEFAULT)),
        Expanded(
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: [
              FreeVideoListWidget(category: widget.category),
              PaidVideoListWidget(category: widget.category),
              FreePdfListWidget(category: widget.category),
              PaidPdfListWidget(category: widget.category),
            ],
          ),
        ),
      ],
    );
  }
}

class DemoWIdget1 extends StatefulWidget {
  final String title;
  const DemoWIdget1({super.key, required this.title});

  @override
  State<DemoWIdget1> createState() => _DemoWIdget1State();
}

class _DemoWIdget1State extends State<DemoWIdget1> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox.expand(
      child: Center(
        child: Text(widget.title),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
