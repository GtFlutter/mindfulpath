// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meditation_app/provider/dashboard_provider.dart';
import 'package:meditation_app/theme/styles.dart';
import 'package:meditation_app/theme/text_style.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/ui/common/custom_snackbar.dart';
import 'package:meditation_app/ui/screens/search/widget/options_selection_sheet.dart';
import 'package:meditation_app/ui/screens/search/widget/recent_search_result_list.dart';
import 'package:meditation_app/ui/screens/search/widget/search_result_list.dart';
import 'package:pinput/pinput.dart';

import '../../../util/assets.dart';
import 'widget/filter_icon_button.dart';

List<String> recentSearchHistory = [
  'Eating for Heart Health',
  'The Power of Nutrients',
  'Transcendental Meditation',
  'Physical Activity and Cancer Prevention',
  'Creating a Personalized Cancer Prevention Plan',
];

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  final FocusNode _focusNode = FocusNode(skipTraversal: true);
  static AppStyle _style = AppStyle();
  bool isFirstTime = true;
  bool showSearchResult = false;

  @override
  void initState() {
    _focusNode.addListener(focusNodeListener);
    _controller.addListener(controllerListener);
    final dashboardNotifier = ref.read<DashboardNotifier>(dashboardProvider);
    Future.delayed(Duration.zero, () {
      if (dashboardNotifier.categoryListResponse == null && dashboardNotifier.categoryListResponse!.isEmpty) {
        dashboardNotifier.getCategoryList();
      }
    });
    super.initState();
  }

  void focusNodeListener() {
    if (_focusNode.hasFocus && isFirstTime) {
      setState(() => isFirstTime = !isFirstTime);
    }
  }

  void controllerListener() {
    if (_controller.text.trim().isNotEmpty) {
      if (showSearchResult) return;
      setState(() => showSearchResult = true);
    } else {
      if (!showSearchResult) return;
      setState(() => showSearchResult = false);
    }
  }

  void setSearchValue(String value) {
    _controller.text = value;
    if (!_focusNode.hasFocus) {
      _focusNode.requestFocus();
    }
    _controller.moveCursorToEnd();
  }

  @override
  void dispose() {
    _focusNode.removeListener(focusNodeListener);
    _controller.removeListener(controllerListener);
    _controller.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _style = AppStyle(screenSize: size);
    // final dashboardNotifier = ref.watch<DashboardNotifier>(dashboardProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BackgroundImage(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: _style.scaleX(15), vertical: _style.scaleX(2)),
                margin: EdgeInsets.symmetric(vertical: _style.scaleX(10), horizontal: _style.scaleX(20)),
                alignment: Alignment.center,
                decoration: ShapeDecoration(
                  color: Color(0xFF2D251F),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_style.scaleX(22.5))),
                  shadows: [BoxShadow(blurRadius: 1, offset: Offset(0.5, 1), color: Colors.black12)],
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      SvgPaths.search,
                      height: _style.scale * 20,
                      fit: BoxFit.contain,
                      colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                    SizedBox(width: _style.scaleX(14)),
                    Flexible(
                      child: TextField(
                        focusNode: _focusNode,
                        autofocus: true,
                        controller: _controller,
                        textInputAction: TextInputAction.search,
                        keyboardType: TextInputType.text,
                        onSubmitted: (text) {
                          if (text.isEmpty) {
                            return;
                          }
                          showCustomSnackBar(text);
                        },
                        style: _style.text.font(mulishMedium500, sizePx: 11, color: Colors.white, spacingPc: 10),
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Hinted search text',
                          hintStyle:
                              _style.text.font(mulishMedium500, sizePx: 10, color: Colors.white.withOpacity(0.5)),
                          contentPadding: EdgeInsets.only(bottom: _style.scaleX(16)),
                          constraints: BoxConstraints(maxHeight: _style.scaleX(40)),
                          alignLabelWithHint: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: _style.scaleX(20)),
                child: Row(
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
                      onTap: selectTime,
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
              ),
              Expanded(
                child: showSearchResult
                    ? SearchResultsList(style: _style)
                    : RecentSearchResultList(
                        style: _style,
                        onRecentSearchTap: setSearchValue,
                      ),
              )
            ],
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
