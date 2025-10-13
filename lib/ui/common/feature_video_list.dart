import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/data/model/response/videos_response.dart';
import 'package:meditation_app/helper/navigation.dart';

import '../../data/model/body/resource_type.dart';
import '../../helper/route/route_paths.dart';
import '../../helper/route/router.dart';
import '../../provider/auth_provider.dart';
import '../../provider/bookmark_provider.dart';
import '../../provider/featured_videos_provider.dart';
import '../../theme/colors.dart';
import '../../theme/styles.dart';
import '../screens/category/widget/detail_item.dart';
import '../screens/discover/widget/featured_item.dart';
import '../screens/discover/widget/featured_item_painter.dart';
import '../screens/settings/widget/logout_dialog.dart';
import 'custom_snackbar.dart';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FeatureVideoList extends ConsumerStatefulWidget {
  final AppStyle style;
  final DashboardCustomImageClipper? clipper;
  final List<VideoResponse> list;
  final ScrollPhysics? physics;
  final Axis scrollDirection;
  final bool shrinkWrap;
  final ScrollController? controller;
  final VoidCallback? onBookmarkChanged;

  const FeatureVideoList.horizontal({
    super.key,
    required this.style,
    required this.list,
    required this.clipper,
    this.physics,
    this.shrinkWrap = false,
    this.controller,
    this.onBookmarkChanged,
  }) : scrollDirection = Axis.horizontal;

  const FeatureVideoList.vertical({
    super.key,
    required this.list,
    required this.style,
    this.physics,
    this.shrinkWrap = false,
    this.controller,
    this.onBookmarkChanged,
  })  : scrollDirection = Axis.vertical,
        clipper = null;

  @override
  ConsumerState<FeatureVideoList> createState() => _FeatureVideoListState();
}

class _FeatureVideoListState extends ConsumerState<FeatureVideoList> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.scrollDirection == Axis.horizontal ? (120 * widget.style.scale) : null,
      child: ListView.separated(
        controller: widget.controller,
        physics: widget.physics,
        shrinkWrap: widget.shrinkWrap,
        scrollDirection: widget.scrollDirection,
        padding: EdgeInsets.symmetric(horizontal: widget.style.scale * 22),
        itemCount: widget.list.length,
        itemBuilder: (context, index) {
          final dataModel = widget.list[index];
          print('------------dataModel-------------->${dataModel.toJson()}');

          return GestureDetector(
            onTap: () async {
              final auth = ref.read(authProvider);
              log("is login --->${auth.isUserLoggedIn}----paid content--->${dataModel.videoType}");

              // 🔒 Check login for paid content
              if (!auth.isUserLoggedIn && dataModel.videoType == ResourceType.paid) {
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

              log("====>featured video--${dataModel.category?.isPurchased}====${dataModel.video?.type == ResourceType.free}");

              // 🆓 Free or Purchased content
              if ((dataModel.category?.isPurchased ?? false) || dataModel.video?.type == ResourceType.free) {
                if (dataModel.category != null) {
                  if (context.canPop()) context.pop();

                  context.goToDetailCategoryScreen(
                    dataModel.category!,
                    isAudio: false,
                    video: DIModel(
                      thumbnailUrl: dataModel.imgUrl ?? '',
                      videoType: dataModel.category?.isPurchased ?? false ? ResourceType.paid : ResourceType.free,
                      videoId: dataModel.video!.id!,
                      videoUrl: dataModel.videoUrl ?? '',
                      duration: dataModel.duration ?? '',
                      title: dataModel.title ?? 'Title Not Found',
                      categoryName: dataModel.category!.title ?? '',
                    ),
                  );
                }
              } else {
                // 🛒 Not purchased → open Buy Now
                await buyNow(
                  context,
                  categoryId: (dataModel.category!.id ?? 0).toString(),
                );
                ref.read(featuredVideosProvider).getFeatureVideoList(1, true);
              }
            },
            child: widget.scrollDirection == Axis.horizontal
                ? FeaturedItem(
                    widget.clipper!,
                    style: widget.style,
                    title: dataModel.title ?? '',
                    imgUrl: dataModel.imgUrl ?? '',
                  )
                : DetailItem.video(
                    appStyle: widget.style,
                    model: dataModel,
                    index: '$index',
                    isDownloaded: false,
                    onToggleBookmark: () async {
                      final auth = ref.read(authProvider);
                      if (!auth.isUserLoggedIn) {
                        showCustomSnackBar(
                          'Please Sign in to Bookmark',
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

                      if (dataModel.id == null) return;
                      await ref.read(bookmarkProvider).toggleBookmark(
                        dataModel.id ?? 0,
                        isRemove: dataModel.bookmarked ?? false,
                      );

                      // 🔁 Let parent handle refresh
                        widget.onBookmarkChanged?.call();
                    },
                  ),
          );
        },
        separatorBuilder: (context, index) => SizedBox(
          width: widget.scrollDirection == Axis.horizontal ? (widget.style.scale * 18) : null,
          height: widget.scrollDirection == Axis.vertical ? (widget.style.scaleX(25)) : null,
        ),
      ),
    );
  }
}

// class FeatureVideoList extends ConsumerWidget {
//   final AppStyle style;
//   final DashboardCustomImageClipper? clipper;
//   final List<VideoResponse> list;
//   final ScrollPhysics? physics;
//   final Axis scrollDirection;
//   final bool shrinkWrap;
//   final ScrollController? controller;
//
//   const FeatureVideoList.horizontal({
//     super.key,
//     required this.style,
//     required this.list,
//     required this.clipper,
//     this.physics,
//     this.shrinkWrap = false,
//     this.controller,
//   }) : scrollDirection = Axis.horizontal;
//
//   const FeatureVideoList.vertical({
//     super.key,
//     required this.list,
//     required this.style,
//     this.physics,
//     this.shrinkWrap = false,
//     this.controller,
//   })  : scrollDirection = Axis.vertical,
//         clipper = null;
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return SizedBox(
//       height: scrollDirection == Axis.horizontal ? (120 * style.scale) : null,
//       child: ListView.separated(
//         controller: controller,
//         physics: physics,
//         shrinkWrap: shrinkWrap,
//         scrollDirection: scrollDirection,
//         padding: EdgeInsets.symmetric(horizontal: style.scale * 22),
//         itemCount: list.length,
//         itemBuilder: (context, index) {
//           var dataModel = list[index];
//           print('------------dataModel-------------->${dataModel.toJson()}');
//           return GestureDetector(
//             onTap: () async {
//               log("is login --->${ref.read(authProvider).isUserLoggedIn}----paid content--->${dataModel.videoType}");
//               if (!(ref.read(authProvider).isUserLoggedIn) &&(dataModel.videoType==ResourceType.paid)) {
//                 showCustomSnackBar(
//                   'Please Sign in to view Plus Content',
//                   action: SnackBarAction(
//                     label: 'Sign in',
//                     backgroundColor: AppColors.primaryColor.withOpacity(0.8),
//                     textColor: Colors.brown.shade800,
//                     onPressed: () => appRouter.go(RoutePath.signIn),
//                   ),
//                   duration: const Duration(seconds: 5),
//                 );
//                 return;
//               }
//               log("====>featured vedio--${dataModel.category?.isPurchased}====${dataModel.video?.type==ResourceType.free}");
//               if ((dataModel.category?.isPurchased ?? false)  || dataModel.video?.type==ResourceType.free) {
//                 if (dataModel.category != null) {
//                   if (context.canPop()) {
//                     context.pop();
//                   }
//                   context.goToDetailCategoryScreen(
//                     dataModel.category!,
//                     isAudio: false,
//                     video: DIModel(
//                       thumbnailUrl: dataModel.imgUrl ?? '',
//                       videoType: dataModel.category?.isPurchased ?? false ? ResourceType.paid : ResourceType.free,
//                       videoId: dataModel.video!.id!,
//                       videoUrl: dataModel.videoUrl ?? '',
//                       duration: dataModel.duration ?? '',
//                       title: dataModel.title ?? 'Title Not Found',
//                       categoryName: dataModel.category!.title ?? '',
//                     ),
//                   );
//                 }
//               } else {
//                 await buyNow(context, categoryId: (dataModel.category!.id ?? 0).toString());
//                 ref.read(featuredVideosProvider).getFeatureVideoList(1, true);
//
//               }
//             },
//             child: scrollDirection == Axis.horizontal
//                 ? FeaturedItem(
//                     clipper!,
//                     style: style,
//                     title: dataModel.title ?? '',
//                     imgUrl: dataModel.imgUrl ?? '',
//                   )
//                 : DetailItem.video(
//                     appStyle: style,
//                     model: dataModel,
//                     index: '$index',
//                     isDownloaded: false,
//                     onToggleBookmark: () async {
//                       bool isLoggedIn = ref.read(authProvider).isUserLoggedIn;
//                       if(!isLoggedIn){
//                         showCustomSnackBar(
//                           'Please Sign in to Bookmark',
//                           action: SnackBarAction(
//                             label: 'Sign in',
//                             backgroundColor: AppColors.primaryColor.withOpacity(0.8),
//                             textColor: Colors.brown.shade800,
//                             onPressed: () => appRouter.go(RoutePath.signIn),
//                           ),
//                           duration: const Duration(seconds: 5),
//                         );
//                         return;
//                       }
//                         if (dataModel.id == null) return;
//                        await ref.read(bookmarkProvider).toggleBookmark(dataModel.video?.id ?? 0, isRemove: dataModel.bookmarked ?? false);
//                       ref.read(featuredVideosProvider).getFeatureVideoList(1, true);
//
//
//                     },
//                   ),
//           );
//         },
//         separatorBuilder: (BuildContext context, int index) {
//           return SizedBox(
//             width: scrollDirection == Axis.horizontal ? (style.scale * 18) : null,
//             height: scrollDirection == Axis.vertical ? (style.scaleX(25)) : null,
//           );
//         },
//       ),
//     );
//   }
// }
