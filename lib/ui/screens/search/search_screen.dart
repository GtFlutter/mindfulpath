// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meditation_app/provider/dashboard_provider.dart';
import 'package:meditation_app/theme/styles.dart';
import 'package:meditation_app/theme/text_style.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/ui/common/custom_snackbar.dart';
import 'package:meditation_app/ui/screens/search/util/query_time.dart';
import 'package:meditation_app/ui/screens/search/widget/options_selection_sheet.dart';
import 'package:meditation_app/ui/screens/search/widget/recent_search_result_list.dart';
import 'package:meditation_app/ui/screens/search/widget/search_result_list.dart';
import 'package:pinput/pinput.dart';

import '../../../data/model/response/category_list_reponse.dart';
import '../../../provider/video_provider.dart';
import '../../../util/assets.dart';
import '../../common/media_player/app_video_player.dart';
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
  final FocusNode _focusNode = FocusNode(skipTraversal: true);
  static AppStyle _style = AppStyle();
  bool isFirstTime = true;
  bool showSearchResult = false;
  Duration? _lastKnownPosition;


  @override
  void initState() {
    final dashboardNotifier = ref.read<DashboardNotifier>(dashboardProvider);
    _focusNode.addListener(focusNodeListener);
    dashboardNotifier.addListener(controllerListener);
    Future.delayed(Duration.zero, () {
      if (dashboardNotifier.categoryListResponse == null && dashboardNotifier.categoryListResponse!.isEmpty) {
        print("=================++++++++++============");
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
    if (_controller.text.trim().isNotEmpty || _selectedCategories.isNotEmpty) {
      if (showSearchResult) return;
      setState(() => showSearchResult = true);
    } else {
      if (!showSearchResult) return;
      setState(() => showSearchResult = false);
    }
    log("showSearchResult-->$showSearchResult");
  }

  void setSearchValue(String value) {
    _controller.text = value;
    if (!_focusNode.hasFocus) {
      _focusNode.requestFocus();
    }
    _controller.moveCursorToEnd();
  }

  List<CategoryListResponse> _selectedCategories = [];
  List<String> _selectedCatTitle = [];
  QueryTime? _selectedQueryTime;
  final TextEditingController _controller = TextEditingController();

  @override
  void deactivate() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    ref.read(dashboardProvider).selectedSearchIndex = null;
    videoDataDispose();

    super.deactivate();
  }

  @override
  void dispose() {
    _focusNode.removeListener(focusNodeListener);
    _controller.removeListener(controllerListener);
    _controller.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  void videoDataDispose() {
    var videoCtrl = ref.read(videoProvider);
    if (videoCtrl.video != null) {
      if (MediaQuery.orientationOf(context) == Orientation.landscape) {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      }
      ref.read(videoProvider.notifier).isSelected = null;
      ref.read(dashboardProvider.notifier).islandScap = false;

      videoCtrl.clearVideo(notifie: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _style = AppStyle(screenSize: size);
    final dashboardNotifier = ref.watch<DashboardNotifier>(dashboardProvider);
    bool isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;

    var videoCtrl = ref.watch(videoProvider);
    var isVideoAvailable = videoCtrl.video != null;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BackgroundImage(
        child: SafeArea(
          child: Column(
            children: [
              if (!isLandscape) ...[
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
                          onChanged: (text) {
                            // if (text.isEmpty) {
                            //   return;
                            // }
                            List<int>? ids = [];
                            if (_selectedCategories.isNotEmpty) {
                              _selectedCategories.map((e) {
                                ids.add(e.id ?? 0);
                              }).toList();
                            }

                            // setState(() {
                            // dashboardNotifier.searchVideo(text, queryTime: _selectedQueryTime ?? QueryTime.qTime1, categoryId: _selectedCategories.isNotEmpty ? _selectedCategories.first.id : null);
                            dashboardNotifier.searchVideo(text,
                                queryTime: _selectedQueryTime ?? QueryTime.qTime1, categoryId: ids);
                            if (text.isEmpty) {
                              setState(() {
                                showSearchResult = true;
                              });
                            }

                            // });
                          },
                          style: _style.text.font(mulishMedium500, sizePx: 14, color: Colors.white, spacingPc: 10),
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Hinted search text',
                            hintStyle:
                                _style.text.font(mulishMedium500, sizePx: 14, color: Colors.white.withOpacity(0.5)),
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
                        onTap: () {
                          if (!isVideoAvailable) dashboardNotifier.selectedSearchIndex = null;
                          FocusManager.instance.primaryFocus?.unfocus();
                          selectCategory();
                        },
                      ),
                      FilterIconButton(
                        style: _style,
                        title: _selectedQueryTime != null ? _selectedQueryTime?.title ?? "Time" : 'Time',
                        onTap: () {
                          if (!isVideoAvailable) dashboardNotifier.selectedSearchIndex = null;
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (_selectedCategories.isNotEmpty || _controller.text.isNotEmpty) {
                            selectTime();
                          } else {
                            showCustomSnackBar("Please select a category before selecting a time.");
                          }
                        },
                      ),
                      TextButton(
                        onPressed: () {
                          _selectedQueryTime = null;
                          _selectedCatTitle = [];
                          _selectedCategories = [];
                          _controller.clear();
                          showSearchResult = false;
                          setState(() {});
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          textStyle: _style.text.font(mulishMedium500, sizePx: 12),
                        ),
                        child: Text('Clear all'),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                SizedBox.shrink(),
              ],
              if (isVideoAvailable) ...[
                if (!isLandscape) SizedBox(height: _style.scaleX(25)),
                Flexible(
                  flex: isLandscape ? 1 : 0,
                  child: Container(
                    width: !isLandscape ? null : double.infinity,
                    height: !isLandscape ? null : double.infinity,
                    alignment: !isLandscape ? null : Alignment.topCenter,
                    constraints: !isLandscape ? BoxConstraints(maxHeight: size.height * 0.4) : null,
                    child: AppVideoPlayer(
                      isLandscape: isLandscape,
                      key: const ValueKey('value'),
                      videoId: videoCtrl.video!.videoId,
                      url: videoCtrl.video!.videoUrl,
                      duration: videoCtrl.video!.duration,
                      style: _style,
                      // isLandscape: isLandscape,
                      onBackPress: () {
                        if (MediaQuery.orientationOf(context) == Orientation.landscape) {
                          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                        }
                        ref.read(videoProvider.notifier).isSelected = null;
                        ref.read(dashboardProvider.notifier).islandScap = false;

                        videoCtrl.clearVideo();
                      },
                      isFileUrl: false,
                      startPosition: _lastKnownPosition ?? Duration.zero,
                      onPositionChanged: (position) {
                        _lastKnownPosition = position;
                      },
                      onFullScreen: () {
                        if (MediaQuery.orientationOf(context) == Orientation.portrait) {
                          ref.read(dashboardProvider.notifier).islandScap = true;
                          SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
                        } else {
                          ref.read(dashboardProvider.notifier).islandScap = false;
                          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                        }
                      },
                    ),
                  ),
                )
              ] else
                const SizedBox.shrink(),
              !isLandscape
                  ? Expanded(
                      child: showSearchResult
                          ? dashboardNotifier.isSearchLoading || dashboardNotifier.data == null
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : SearchResultsList(
                                  style: _style,
                                  model: dashboardNotifier.data!,
                                )
                          : RecentSearchResultList(
                              style: _style,
                              onRecentSearchTap: setSearchValue,
                            ),
                    )
                  : const SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }

  void selectCategory() {
    final dashboardNotifier = ref.watch(dashboardProvider);
    print("selected data===${_selectedCatTitle.length}-----${_selectedCategories.length}");
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
        return OptionsSelectionSheet.multiSelect(
          categoryList: dashboardNotifier.categoryListResponse!,
          selectedItems: _selectedCatTitle,
          title: 'Category',
          onCategorySelect: (categories, selectedItem) async {
            debugPrint('Selected Categories :: $categories ------------------ $selectedItem');

            _selectedCategories.clear();
            // _selectedCatTitle.clear();
            if (context.mounted) {
              _selectedCategories.addAll(categories);
              // _selectedCatTitle.addAll(selectedItem);
              _selectedCatTitle = selectedItem;
              log("selected.........${_selectedCategories.length}------------${_selectedCatTitle.length}");
              List<int>? ids = [];
              if (_selectedCategories.isNotEmpty) {
                _selectedCategories.map((e) {
                  ids.add(e.id ?? 0);
                }).toList();
              }

              await dashboardNotifier.searchVideo(_controller.text,
                  queryTime: _selectedQueryTime ?? QueryTime.qTime1, categoryId: ids);
              setState(() {
                showSearchResult = true;
              });
              // dashboardNotifier.searchVideo(_controller.text, queryTime: _selectedQueryTime ?? QueryTime.qTime1, categoryId: _selectedCategories.isNotEmpty ? _selectedCategories.first.id : null);
            }
          },
        );
      },
      context: context,
      enableDrag: false,
    );
  }

  void selectTime() {
    final dashboardNotifier = ref.watch(dashboardProvider);
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
        return OptionsSelectionSheet.singleSelect(
          queryItems: QueryTime.toList,
          useGridLayout: true,
          title: 'Time',
          onTimeSelect: (item) async {
            _selectedQueryTime = item;
            List<int>? ids = [];
            if (_selectedCategories.isNotEmpty) {
              _selectedCategories.map((e) {
                ids.add(e.id ?? 0);
              }).toList();
            }

            await dashboardNotifier.searchVideo(_controller.text,
                queryTime: _selectedQueryTime ?? QueryTime.qTime1, categoryId: ids);
            // setState(() {
            if (dashboardNotifier.data?.list?.isNotEmpty ?? false) {
              showSearchResult = true;
            } else {
              showCustomSnackBar("Data not found");
            }
            // });
            if (context.mounted) setState(() {});
            debugPrint('Selected time :: ${item.title}');
          },
        );
      },
      context: context,
      enableDrag: false,
    );
  }
}
