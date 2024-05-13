import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/data/model/response/category_list_reponse.dart';
import 'package:meditation_app/helper/route/route_paths.dart';
import 'package:meditation_app/helper/route/router.dart';
import 'package:meditation_app/provider/auth_provider.dart';
import 'package:meditation_app/provider/resource_provider/paid_videos_provider.dart';
import 'package:meditation_app/theme/styles.dart';
import 'package:meditation_app/ui/common/custom_snackbar.dart';
import 'package:meditation_app/ui/screens/analytics/data/model/response/category_and_video_name_model.dart';
import 'package:meditation_app/ui/screens/category/widget/tabs/paid_video_list_widget.dart';
import 'package:meditation_app/ui/screens/settings/widget/logout_dialog.dart';
import 'package:meditation_app/util/dimensions.dart';

import '../../../../provider/dashboard_provider.dart';
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
  final List<ItemName> _filters = [ItemName(id: 0, title: 'Video'), ItemName(id: 1, title: 'PDF')];
  static AppStyle _style = AppStyle();

  /// Either 0(Video) or 1(PDF)
  // late int filterIndex;
  int filterIndex = 0;

  /// Either 0(Free) or 1(Paid)
  // late int courseIndex;
  int courseIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: courseIndex, length: 4, vsync: this);
    (widget.isFromPdfNotification ?? false) ? _changeFilter(ItemName(id: 1, title: 'PDF')) : _changeFilter(ItemName(id: 0, title: 'Video'));

    Future.delayed(Duration(seconds: 0), () {
      ref.read(paidVideosProvider.notifier).fetchVideos(widget.category.id ?? 0, isLoading: false);
    }).then((value) async {
      if (widget.isFromPdfNotification ?? false) {
        _changeFilter(ItemName(id: 1, title: 'PDF'));
        log("isPaid and purchased--->${widget.isPaid}----${widget.category.isPurchased}");
        if ((widget.isPaid ?? false) && !(widget.category.isPurchased ?? false)) {
          await buyNow(context, categoryId: widget.category.id.toString());
          if (ref.read(paidVideosProvider.notifier).videosResponse?.category?.isPurchased ?? false) {
            _changeCourseType(1);
          } else {
            _changeCourseType(0);
          }
        } else if ((widget.isPaid ?? false) && (widget.category.isPurchased ?? false)) {
          log("callleeddddddd");
          _changeCourseType(1);
          _changeFilter(ItemName(id: 1, title: 'PDF'));
          setState(() {});
        }
      }
      else if (widget.isFromPaidVideoNotification ?? false) {
        log("isPaid and purchased  11--->${widget.isPaid}----${widget.category.isPurchased}");
        if ((widget.isPaid ?? false) && !(widget.category.isPurchased ?? false)) {
          await buyNow(context, categoryId: widget.category.id.toString());
          log("-------->${ref.read(paidVideosProvider.notifier).videosResponse?.category?.isPurchased}---------------");
          log("starrttt~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
          await ref.read(paidVideosProvider.notifier).fetchVideos(widget.category.id ?? 0);
          log("starrttt~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~sfdsfdsfdsf");
          if (ref.read(paidVideosProvider.notifier).videosResponse?.category?.isPurchased ?? false) {
            _changeCourseType(1);
          } else {
            _changeCourseType(0);
          }
        } else if ((widget.isPaid ?? false) && (widget.category.isPurchased ?? false)) {
          log("callleeddddddd~~~~~~~~");
          _changeCourseType(1);
          _changeFilter(ItemName(id: 0, title: 'Video'));
          setState(() {});
        }
      } else {
        _changeCourseType(0);
        _changeFilter(ItemName(id: 0, title: 'Video'));
      }
    });
    print('_______________________________________46_${widget.category.isPurchased}');
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

    var provider = ref.watch(paidVideosProvider);
    var dashboardPro = ref.watch(dashboardProvider);
    log("provider.videosResponse?.category?.isPurchased----------${provider.videosResponse?.category?.isPurchased}");
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
              onTap: () async {
                if (!ref.read(authProvider).isUserLoggedIn) {
                  showCustomSnackBar(
                    'Please login to view paid video.',
                    action: SnackBarAction(
                      label: 'Log In',
                      backgroundColor: AppColors.primaryColor.withOpacity(0.8),
                      textColor: Colors.brown.shade800,
                      onPressed: () => appRouter.go(RoutePath.signIn),
                    ),
                    duration: const Duration(seconds: 5),
                  );
                  return;
                }
                print('_______________________________________126_${provider.videosResponse?.category?.isPurchased}');
                // if (!(provider.videosResponse?.list?.first.category?.isPurchased ?? false)|| !(widget.category.isPurchased ?? false)) {
                if (!(provider.videosResponse?.category?.isPurchased ?? false)) {
                  await buyNow(context, categoryId: widget.category.id.toString());
                  await provider.fetchVideos(widget.category.id ?? 0, isLoading: filterIndex == 0);
                  if (ref.read(paidVideosProvider.notifier).videosResponse?.category?.isPurchased ?? false) {
                    _changeCourseType(1);
                  } else {
                    _changeCourseType(0);
                  }
                  // await  dashboardPro.getCategoryList();
                  // dashboardPro.categoryListResponse?.map((e) {
                  //   if(e.id==widget.category.id){
                  //     widget.category=e;
                  //     setState(() {
                  //
                  //     });
                  //   }
                  // });

                  // provider.fetchVideos(widget.category.id ?? 0);
                  return;
                } else {
                  log("ttthhhiiissss ccaakkkeddd");
                  _changeCourseType(1);
                }
              },
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
              PaidVideoListWidget(
                category: widget.category,
                isPurchased: provider.videosResponse?.category?.isPurchased ?? false,
              ),
              FreePdfListWidget(category: widget.category),
              PaidPdfListWidget(
                category: widget.category,
                isPurchased: provider.videosResponse?.category?.isPurchased ?? false,
              ),
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
