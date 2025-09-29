import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/data/model/response/category_list_reponse.dart';
import 'package:meditation_app/helper/route/route_paths.dart';
import 'package:meditation_app/helper/route/router.dart';
import 'package:meditation_app/provider/auth_provider.dart';
import 'package:meditation_app/provider/resource_provider/free_all_item_list_provider.dart';
import 'package:meditation_app/provider/resource_provider/paid_audios_provider.dart';
import 'package:meditation_app/provider/resource_provider/paid_videos_provider.dart';
import 'package:meditation_app/theme/styles.dart';
import 'package:meditation_app/ui/common/custom_snackbar.dart';
import 'package:meditation_app/ui/screens/analytics/data/model/response/category_and_video_name_model.dart';
import 'package:meditation_app/ui/screens/category/widget/tabs/free_all_item_list_widget.dart';
import 'package:meditation_app/ui/screens/category/widget/tabs/paid_all_list_widget.dart';
import 'package:meditation_app/ui/screens/category/widget/tabs/paid_video_list_widget.dart';
import 'package:meditation_app/util/dimensions.dart';

import '../../../../provider/dashboard_provider.dart';
import '../../../../provider/resource_provider/paid_all_item_list_provider.dart';
import '../../../../theme/colors.dart';
import '../../../common/custom_dropdown_button.dart';
import 'custom_selecteable_button.dart';
import 'tabs/free_pdf_list_widget.dart';
import 'tabs/free_video_list_widget.dart';
import 'tabs/paid_pdf_list_widget.dart';

class ResourceDetailCategory extends ConsumerStatefulWidget {
  CategoryListResponse category;
  bool? isFromPdfNotification;
  bool? isFromPaidVideoNotification;
  bool? isPaid;
  bool? isPDFView;

  ResourceDetailCategory({super.key, required this.category, this.isFromPdfNotification, this.isPaid, this.isPDFView, this.isFromPaidVideoNotification});

  @override
  ConsumerState<ResourceDetailCategory> createState() => _ResourceDetailCategoryState();
}

class _ResourceDetailCategoryState extends ConsumerState<ResourceDetailCategory> with TickerProviderStateMixin {
  late TabController _tabController;
  List<ItemName> _filters = [ItemName(id: 0, title: 'Video'), ItemName(id: 1, title: 'PDF'), ItemName(id: 2, title: 'Audio'), ItemName(id: 3, title: 'All')];
  List<ItemName> _freeFilters = [];
  List<ItemName> _paidFilters = [];
  int? _lastCategoryId;
  static AppStyle _style = AppStyle();

  /// Either 0(Video) or 1(PDF)
  int filterIndex = 3;

  /// Either 0(Free) or 1(Paid)
  int courseIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 6, length: 8, vsync: this);
    // (widget.isFromPdfNotification ?? false) ? _changeFilter(ItemName(id: 1, title: 'PDF')) : _changeFilter(ItemName(id: 0, title: 'Video'));
    // if(widget.isFromPdfNotification ?? false)  _changeFilter(ItemName(id: 1, title: 'PDF'));
    Future.delayed(Duration(seconds: 0), () async {
      log("------>cst id for all item--${widget.category.id}");
      await ref.read(freeAllItemProvider.notifier).fetchAllFreeItem(widget.category.id ?? 0);
      // // ✅ Build _freeFilters after fetching free items
      // final isVideo = (ref.read(freeAllItemProvider).allItemResponse?.data?.isVideo ?? 0) == 1;
      // final isAudio = (ref.read(freeAllItemProvider).allItemResponse?.data?.isAudio ?? 0) == 1;
      // final isPdf = (ref.read(freeAllItemProvider).allItemResponse?.data?.isPdf ?? 0) == 1;
      //
      // _freeFilters = buildFilterOptions(hasVideo: isVideo, hasAudio: isAudio, hasPdf: isPdf);
      final data = ref.read(freeAllItemProvider).allItemResponse?.data;

      final hasVideo = (data?.video?.isNotEmpty ?? false);
      final hasAudio = (data?.audio?.isNotEmpty ?? false);
      final hasPdf = (data?.pdf?.isNotEmpty ?? false);
      log("------>hasVideo=$hasVideo-------->hasAudio=$hasAudio------->hasPdf=$hasPdf");
      _freeFilters = buildFilterOptions(
        hasVideo: hasVideo,
        hasAudio: hasAudio,
        hasPdf: hasPdf,
      );
      setState(() {
        _filters = _freeFilters;
        // filterIndex = _filters.first.id;
        final availableCount = [hasVideo, hasAudio, hasPdf].where((e) => e).length;
        log("available count---->$availableCount");
        if (availableCount == 0) {
          // no data → All only
          filterIndex = 3;
        } else if (availableCount == 1) {
          // exactly one category → that one
          filterIndex = _filters.first.id;
        } else {
          // multiple categories → default to All
          filterIndex = 3;
        }
        // ✅ run after first frame
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if(filterIndex!=3) {
            _changeTab(filterIndex, courseIndex);
          }
          log("👉 Default filterIndex applied AFTER build: $filterIndex");
        });

        log("👉 Default filterIndex set to $filterIndex");
      });
      ref.read(paidVideosProvider.notifier).fetchVideos(widget.category.id ?? 0, isLoading: false);
    }).then((value) async {
      if (widget.isFromPdfNotification ?? false) {
        _changeFilter(ItemName(id: 1, title: 'PDF'));
        log("isPaid and purchased--->${widget.isPaid}----${widget.category.isPurchased}");
        if (widget.isPaid ?? false) {
          _changeCourseType(1);
        } else {
          _changeCourseType(0);
        }
      } else if (widget.isFromPaidVideoNotification ?? false) {
        log("isPaid and purchased  11--->${widget.isPaid}----${widget.category.isPurchased}");
        if (widget.isPaid ?? false) {
          _changeCourseType(1);
        } else {
          _changeCourseType(0);
        }
      }
      // else {
      //   _changeCourseType(0);
      //   _changeFilter(ItemName(id: 0, title: 'Video'));
      // }
    });

  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<ItemName> buildFilterOptions({
    required bool hasVideo,
    required bool hasAudio,
    required bool hasPdf,
  }) {
    final List<ItemName> filters = [];
    final availableTypes = [hasVideo, hasAudio, hasPdf].where((e) => e).length;
    log("=======>available types=====>$availableTypes");
    if (availableTypes == 0) {
      // No data at all → only All
      filters.add(ItemName(id: 3, title: 'All'));
    } else if (availableTypes == 1) {
      // Only one category → show only that one
      if (hasVideo) filters.add(ItemName(id: 0, title: 'Video'));
      if (hasPdf) filters.add(ItemName(id: 1, title: 'PDF'));
      if (hasAudio) filters.add(ItemName(id: 2, title: 'Audio'));
    } else {
      // More than one category → show all available + All
      filters.add(ItemName(id: 3, title: 'All'));
      if (hasVideo) filters.add(ItemName(id: 0, title: 'Video'));
      if (hasPdf) filters.add(ItemName(id: 1, title: 'PDF'));
      if (hasAudio) filters.add(ItemName(id: 2, title: 'Audio'));
    }

    return filters;
  }

  // List<ItemName> buildFilterOptions({
  //   required bool isVideo,
  //   required bool isAudio,
  //   required bool isPdf,
  // }) {
  //   final List<ItemName> filters = [];
  //
  //   if (isVideo) {
  //     filters.add(ItemName(id: 0, title: 'Video'));
  //   }
  //   if (isPdf) {
  //     filters.add(ItemName(id: 1, title: 'PDF'));
  //   }
  //   if (isAudio) {
  //     filters.add(ItemName(id: 2, title: 'Audio'));
  //   }
  //
  //   if (filters.isEmpty) {
  //     filters.add(ItemName(id: 3, title: 'All'));
  //   } else {
  //     filters.add(ItemName(id: 3, title: 'All'));
  //   }
  //
  //   return filters;
  // }

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
    } else if (filterIndex == 2 && courseTypeIndex == 0) {
      goTo = 4;
    } else if (filterIndex == 2 && courseTypeIndex == 1) {
      goTo = 5;
    } else if (filterIndex == 3 && courseTypeIndex == 0) {
      goTo = 6;
    } else if (filterIndex == 3 && courseTypeIndex == 1) {
      goTo = 7;
    } else {
      goTo = throw ArgumentError();
    }
    if (currentTabIndex == goTo) return;
    _tabController.animateTo(goTo);
  }

  void _changeFilter(
    ItemName? value,
  ) {
    if (value == null || value.id == filterIndex) return;
    // Map title to index used in _changeTab
    final title = value.title.toLowerCase();
    int mappedIndex;

    if (title == 'video') {
      mappedIndex = 0;
    } else if (title == 'audio') {
      mappedIndex = 2;
    } else if (title == 'pdf') {
      mappedIndex = 1;
    } else if (title == 'all') {
      mappedIndex = 3;
    } else {
      // Unknown filter title, do nothing
      return;
    }

    if (mappedIndex == filterIndex) return;
    log("course index during filter change --->$courseIndex");

    setState(() {
      filterIndex = mappedIndex;
      _changeTab(filterIndex, courseIndex);
    });
  }

  // void _changeCourseType(int index) {
  //   if (index == courseIndex) return;
  //   setState(() {
  //     courseIndex = index;
  //     _changeTab(filterIndex, courseIndex);
  //   });
  // }
  void _changeCourseType(int index) async {
    if (index == courseIndex) return;

    setState(() {
      courseIndex = index;
    });

    if (courseIndex == 1) {
     log("paid filter is empty----->${_paidFilters.isEmpty}");
      // if (_paidFilters.isEmpty) {
      if (true) {
        await ref.read(paidAllItemProvider.notifier).fetchAllPaidItem(widget.category.id ?? 0);
        // final isVideo = (ref.read(paidAllItemProvider).allItemResponse?.data?.isVideo ?? 0) == 1;
        // final isAudio = (ref.read(paidAllItemProvider).allItemResponse?.data?.isAudio ?? 0) == 1;
        // final isPdf = (ref.read(paidAllItemProvider).allItemResponse?.data?.isPdf ?? 0) == 1;
        // _paidFilters = buildFilterOptions(hasVideo: isVideo, hasAudio: isAudio, hasPdf: isPdf);
        final data = ref.read(paidAllItemProvider).allItemResponse?.data;

        final hasVideo = (data?.video?.isNotEmpty ?? false);
        final hasAudio = (data?.audio?.isNotEmpty ?? false);
        final hasPdf = (data?.pdf?.isNotEmpty ?? false);

        _paidFilters = buildFilterOptions(
          hasVideo: hasVideo,
          hasAudio: hasAudio,
          hasPdf: hasPdf,
        );
      }
      setState(() {
        _filters = _paidFilters;
        // filterIndex = _filters.first.id;
        final data = ref.read(paidAllItemProvider).allItemResponse?.data;

        final hasVideo = (data?.video?.isNotEmpty ?? false);
        final hasAudio = (data?.audio?.isNotEmpty ?? false);
        final hasPdf = (data?.pdf?.isNotEmpty ?? false);
        final availableCount = [hasVideo, hasAudio, hasPdf].where((e) => e).length;

        if (availableCount == 0) {
          filterIndex = 3; // no data → All
        } else if (availableCount == 1) {
          filterIndex = _filters.first.id; // single category → that one
        } else {
          filterIndex = 3; // multiple categories → All
        }
      });
    } else {
      log("free filter is empty----->${_freeFilters.isEmpty}");
      // if (_freeFilters.isEmpty) {
      if (true) {
        // fallback: rebuild filters from existing data if needed
        await ref.read(freeAllItemProvider.notifier).fetchAllFreeItem(widget.category.id ?? 0);
        // final isVideo = (ref.read(freeAllItemProvider).allItemResponse?.data?.isVideo ?? 0) == 1;
        // final isAudio = (ref.read(freeAllItemProvider).allItemResponse?.data?.isAudio ?? 0) == 1;
        // final isPdf = (ref.read(freeAllItemProvider).allItemResponse?.data?.isPdf ?? 0) == 1;
        // _freeFilters = buildFilterOptions(hasVideo: isVideo, hasAudio: isAudio, hasPdf: isPdf);
        final data = ref.read(freeAllItemProvider).allItemResponse?.data;

        final hasVideo = (data?.video?.isNotEmpty ?? false);
        final hasAudio = (data?.audio?.isNotEmpty ?? false);
        final hasPdf = (data?.pdf?.isNotEmpty ?? false);

        _freeFilters = buildFilterOptions(
          hasVideo: hasVideo,
          hasAudio: hasAudio,
          hasPdf: hasPdf,
        );
      }

      setState(() {
        _filters = _freeFilters;
        // filterIndex = _filters.first.id;
        final data = ref.read(freeAllItemProvider).allItemResponse?.data;

        final hasVideo = (data?.video?.isNotEmpty ?? false);
        final hasAudio = (data?.audio?.isNotEmpty ?? false);
        final hasPdf = (data?.pdf?.isNotEmpty ?? false);
        final availableCount = [hasVideo, hasAudio, hasPdf].where((e) => e).length;

        if (availableCount == 0) {
          filterIndex = 3; // no data → All
        } else if (availableCount == 1) {
          filterIndex = _filters.first.id; // single category → that one
        } else {
          filterIndex = 3; // multiple categories → All
        }
      });
    }
    log("course index during course type change --->$courseIndex");
    _changeTab(filterIndex, courseIndex); // Reloads content for selected tab and filter
  }

  @override
  Widget build(BuildContext context) {
    _style = AppStyle(screenSize: MediaQuery.sizeOf(context));

    var provider = ref.watch(paidVideosProvider);
    var audioProvider = ref.watch(paidAudiosProvider);
    var dashboardPro = ref.watch(dashboardProvider);
    log("provider.videosResponse?.category?.isPurchased----------${provider.videosResponse?.category?.isPurchased}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomSelecteableButton(
              text: 'Core',
              selected: courseIndex == 0,
              onTap: () => _changeCourseType(0),
            ),
            const SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
            CustomSelecteableButton(
              text: 'Plus',
              selected: courseIndex == 1,
              onTap: () async {
                if (!ref.read(authProvider).isUserLoggedIn) {
                  showCustomSnackBar(
                    'Please Sign in to view Plus Content',
                    action: SnackBarAction(
                      label: 'Sign in',
                      backgroundColor: AppColors.primaryColor.withOpacity(0.8),
                      textColor: Colors.brown.shade800,
                      onPressed: () => appRouter.go(RoutePath.signIn),
                    ),
                    duration: const Duration(seconds: 5),
                  );
                  return;
                }
                _changeCourseType(1);
              },
            ),
            const Spacer(),
            Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_style.scaleX(40)),
                  side: const BorderSide(color: AppColors.primaryThemeColor1),
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: _style.scaleX(10),
                vertical: _style.scaleX(3.5),
              ),
              child: CustomDropDownButton<ItemName>(
                // value: _filters[filterIndex],
                value: _filters.firstWhere((e) => e.id == filterIndex, orElse: () => _filters.last),
                appStyle: _style,
                items: _filters,
                width: _style.scaleX(120),
                maxHeight: _style.scaleX(250),
                onChanged: (value) {
                  log("filters------>${_filters.length}");
                  // _changeCourseType(0);because at filter change time no need to tab change so this code comment
                  _changeFilter(ItemName(id: value?.id ?? 0, title: value!.title));

                  // _changeCourseType(0);
                },
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
              FreeVideoListWidget(
                category: widget.category,
                isAudio: false,
              ),
              PaidVideoListWidget(
                category: widget.category,
                isAudio: false,
                isPurchased: provider.videosResponse?.category?.isPurchased ?? false,
              ),
              FreePdfListWidget(category: widget.category),
              PaidPdfListWidget(
                category: widget.category,
                isPurchased: provider.videosResponse?.category?.isPurchased ?? false,
              ),
              FreeVideoListWidget(
                category: widget.category,
                isAudio: true,
              ),
              PaidVideoListWidget(
                category: widget.category,
                isAudio: true,
                isPurchased: audioProvider.videosResponse?.category?.isPurchased ?? false,
              ),
              AllItemListWidget(category: widget.category),
              //All Paid Content
              PaidAllItemListWidget(category: widget.category),
            ],
          ),
        ),
      ],
    );
  }
}
