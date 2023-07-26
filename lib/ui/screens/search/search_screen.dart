// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/theme/styles.dart';
import 'package:meditation_app/theme/text_style.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/ui/common/common_bottom_sheet_widget.dart';

import '../../../theme/colors.dart';
import '../../../util/assets.dart';
import '../category/temp_data_file.dart';
import '../category/widget/detail_item.dart';

List<String> recentSearchHistory = [
  'Eating for Heart Health',
  'The Power of Nutrients',
  'Transcendental Meditation',
  'Physical Activity and Cancer Prevention',
  'Creating a Personalized Cancer Prevention Plan',
];

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode(
    skipTraversal: true,
  );
  static AppStyle _style = AppStyle();
  bool isFirstTime = true;
  bool showSearchResult = false;

  @override
  void initState() {
    _focusNode.addListener(() {
      if (_focusNode.hasFocus && isFirstTime) {
        setState(() {
          isFirstTime = !isFirstTime;
        });
      }
    });
    _controller.addListener(() {
      if (_controller.text.trim().isNotEmpty) {
        if (showSearchResult) return;
        setState(() {
          showSearchResult = true;
        });
      } else {
        if (!showSearchResult) return;
        setState(() {
          showSearchResult = false;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

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
                          focusNode: _focusNode,
                          onChanged: (value) {},
                          controller: _controller,
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
                if (!isFirstTime) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FilterIconButton(
                        style: _style,
                        title: 'Category',
                        onTap: selectCategory,
                      ),
                      FilterIconButton(
                        style: _style,
                        title: 'Time',
                        onTap: () {},
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          textStyle: _style.text.font(mulishMedium500, sizePx: 10),
                        ),
                        child: Text('Clear all'),
                      ),
                    ],
                  ),
                  Expanded(
                    child: showSearchResult
                        ? SearchResultsList(style: _style)
                        : RecentSearchResultList(controller: _controller, style: _style),
                  )
                ] else
                  Expanded(child: AllVideosList(style: _style))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void selectCategory() {
    showModalBottomSheet(
      // isScrollControlled: true,
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(_style.scaleX(15)),
          topRight: Radius.circular(_style.scaleX(15)),
        ),
      ),
      backgroundColor: Color(0xFF2D251F),
      builder: (context) {
        return OptionsSelection(
          style: _style,
          items: [
            'Meditation',
            'Diet',
            'Nutrition',
            'Exercise',
            'Cancer prevention'
                '1Meditation',
            '1Diet',
            '1Nutrition',
            '1Exercise',
            '1Cancer prevention'
                '2Meditation',
            '2Diet',
            '2Nutrition',
            '2Exercise',
            '2Cancer prevention'
                '3Meditation',
            '3Diet',
            '3Nutrition',
            '3Exercise',
            '3Cancer prevention',
            '4Meditation',
            '4Diet',
            '4Nutrition',
            '4Exercise',
            '4Cancer prevention',
          ],
          selectedItems: [
            'Meditation',
            'Diet',
            'Nutrition',
          ],
          multiSelect: true,
        );
      },
      context: context,
      enableDrag: false,
    );
  }
}

class OptionsSelection extends StatefulWidget {
  final List<String> items;
  final List<String> selectedItems;
  final bool multiSelect;
  const OptionsSelection({
    super.key,
    required this.style,
    required this.items,
    required this.selectedItems,
    required this.multiSelect,
  });

  final AppStyle style;

  @override
  State<OptionsSelection> createState() => _OptionsSelectionState();
}

class _OptionsSelectionState extends State<OptionsSelection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CommonBottomSheetWidget(
          style: widget.style,
          title: 'Category',
          doneLable: 'Clear',
          onCancle: () {
            if (context.canPop()) {
              context.pop();
            }
          },
          onDone: widget.selectedItems.isNotEmpty
              ? () {
                  setState(() {
                    widget.selectedItems.clear();
                  });
                }
              : null,
        ),
        Expanded(
            child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: widget.style.scaleX(20)),
          child: Align(
            child: Wrap(
              spacing: widget.style.scaleX(15),
              runSpacing: widget.style.scaleX(12.5),
              children: List.generate(
                widget.items.length,
                (index) {
                  bool isSelected = widget.selectedItems.contains(widget.items[index]);
                  return ChoiceChip(
                    label: Text(widget.items[index]),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.style.scaleX(40))),
                    side: BorderSide(color: AppColors.primaryColor, width: widget.style.scaleX(0.5)),
                    labelStyle: widget.style.text.font(
                      mulishSemiBold600,
                      sizePx: 10,
                      color: isSelected ? Colors.black : Colors.white,
                    ),
                    selected: isSelected,
                    onSelected: (value) {
                      if (isSelected) {
                        widget.selectedItems.remove(widget.items[index]);
                        setState(() {});
                      } else {
                        widget.selectedItems.add(widget.items[index]);
                        setState(() {});
                      }
                    },
                    selectedColor: AppColors.primaryColor,
                    backgroundColor: Color(0xFF2D251F),
                    elevation: 0,
                    disabledColor: Colors.red,
                  );
                },
              ).toList(),
            ),
          ),
        )),
        // Expanded(
        //   child: ListView.builder(
        //     itemBuilder: (context, index) {
        //       return ListTile(
        //         onTap: () {
        //           if (widget.selectedItems.contains(widget.items[index])) {
        //             widget.selectedItems.remove(widget.items[index]);
        //             setState(() {});
        //           } else {
        //             widget.selectedItems.add(widget.items[index]);
        //             setState(() {});
        //           }
        //         },
        //         title: Text(widget.items[index]),
        //         textColor: widget.selectedItems.contains(widget.items[index]) ? Colors.red : null,
        //       );
        //     },
        //     itemCount: widget.items.length,
        //   ),
        // ),
      ],
    );
  }
}

class AllVideosList extends StatelessWidget {
  const AllVideosList({
    super.key,
    required AppStyle style,
  }) : _style = style;

  final AppStyle _style;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.only(
        bottom: _style.scale * 100,
        top: _style.scale * 20,
      ),
      itemCount: TempData.listDiModel.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {},
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
    );
  }
}

class SearchResultsList extends StatelessWidget {
  const SearchResultsList({
    super.key,
    required AppStyle style,
  }) : _style = style;

  final AppStyle _style;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.only(
        bottom: _style.scale * 100,
        top: _style.scale * 20,
      ),
      // itemCount: TempData.listDiModel.length,
      itemCount: 2,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {},
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
    );
  }
}

class RecentSearchResultList extends StatelessWidget {
  const RecentSearchResultList({
    super.key,
    required TextEditingController controller,
    required AppStyle style,
  })  : _controller = controller,
        _style = style;

  final TextEditingController _controller;
  final AppStyle _style;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return MaterialButton(
          onPressed: () {
            _controller.text = recentSearchHistory[index];
          },
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              recentSearchHistory[index],
              textAlign: TextAlign.start,
              style: _style.text.font(mulishRegular400, sizePx: 12.5),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
      itemCount: recentSearchHistory.length,
    );
  }
}

class FilterIconButton extends StatelessWidget {
  const FilterIconButton({
    super.key,
    required AppStyle style,
    required this.title,
    this.onTap,
  }) : _style = style;

  final AppStyle _style;
  final String title;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          horizontal: _style.scaleX(15),
          vertical: _style.scaleX(5),
        ),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: _style.scaleX(0.50), color: AppColors.appBarBorderColor),
            borderRadius: BorderRadius.circular(_style.scaleX(25)),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: _style.text.font(mulishMedium500, sizePx: 10),
            ),
            SizedBox(width: _style.scaleX(7.5)),
            SvgPicture.asset(
              SvgPaths.arrowDown,
              width: _style.scaleX(15),
              fit: BoxFit.fitWidth,
              color: AppColors.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
