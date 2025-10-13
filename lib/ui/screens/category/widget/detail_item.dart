import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meditation_app/data/model/response/pdfs_response.dart';
import 'package:meditation_app/helper/string_converter.dart';
import 'package:meditation_app/provider/audio_provider.dart';
import 'package:meditation_app/provider/course_provider.dart';
import 'package:meditation_app/provider/download_provider.dart';
import 'package:meditation_app/provider/playlist_provider.dart';
import 'package:meditation_app/provider/video_provider.dart';
import 'package:meditation_app/ui/common/custom_snackbar.dart';
import 'package:meditation_app/ui/screens/playlist/widget/create_playlist_dialog.dart';
import 'package:video_player/video_player.dart';

import '../../../../data/model/body/resource_type.dart';
import '../../../../data/model/response/videos_response.dart';
import '../../../../helper/route/route_paths.dart';
import '../../../../helper/route/router.dart';
import '../../../../provider/auth_provider.dart';
import '../../../../provider/featured_videos_provider.dart';
import '../../../../provider/resource_provider/free_pdfs_provider.dart';
import '../../../../provider/resource_provider/paid_all_item_list_provider.dart';
import '../../../../provider/resource_provider/paid_videos_provider.dart';
import '../../../../provider/resource_provider/paid_audios_provider.dart';
import '../../../../theme/colors.dart';
import '../../../../theme/styles.dart';
import '../../../../theme/text_style.dart';
import '../../../../util/assets.dart';
import '../../../common/media_image_card.dart';
import '../../../common/outlined_icon_button.dart';
import '../../settings/widget/logout_dialog.dart';

class DIModel {
  final int videoId;
  final String thumbnailUrl;
  final String videoUrl;
  final String duration;
  final String title;
  final String categoryName;
  final ResourceType videoType;
  Duration? position;
  final VideoPlayerController? controller; // Added controller

  DIModel({
    required this.videoType,
    required this.videoId,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.duration,
    required this.title,
    required this.categoryName,
    this.position,
    this.controller, // Added controller
  });

  DIModel copyWith({
    int? videoId,
    String? thumbnailUrl,
    String? videoUrl,
    String? duration,
    String? title,
    String? categoryName,
    ResourceType? videoType,
    Duration? position,
    VideoPlayerController? controller,
  }) =>
      DIModel(
        videoId: videoId ?? this.videoId,
        videoUrl: videoUrl ?? this.videoUrl,
        thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
        duration: duration ?? this.duration,
        title: title ?? this.title,
        categoryName: categoryName ?? this.categoryName,
        videoType: videoType ?? this.videoType,
        position: position ?? this.position,
        controller: controller ?? this.controller,
      );

  factory DIModel.fromJson(dynamic json) {
    return DIModel(
      videoId: json['video_id'] as int,
      videoUrl: json['video_url'] as String,
      thumbnailUrl: json['thumbnail_url'] as String,
      duration: json['duration'] as String,
      title: json['title'] as String,
      categoryName: json['category_name'] as String,
      videoType: ResourceType.fromJson(json['video_type'] as int)!,
      position: json.containsKey('position') ? Duration(milliseconds: json['position']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['video_id'] = videoId;
    data['video_url'] = videoUrl;
    data['thumbnail_url'] = thumbnailUrl;
    data['duration'] = duration;
    data['title'] = title;
    data['category_name'] = categoryName;
    data['video_type'] = videoType.toInt();
    if (position != null) {
      data['position'] = position!.inMilliseconds;
    }
    return data;
  }
}

// class DIModel {
//   final int videoId;
//   final String thumbnailUrl;
//   final String videoUrl;
//   final String duration;
//   final String title;
//   final String categoryName;
//   final ResourceType videoType;
//
//   const DIModel({
//     required this.videoType,
//     required this.videoId,
//     required this.thumbnailUrl,
//     required this.videoUrl,
//     required this.duration,
//     required this.title,
//     required this.categoryName,
//   });
//
//   DIModel copyWith() => DIModel(
//         videoId: videoId,
//         videoUrl: videoUrl,
//         thumbnailUrl: thumbnailUrl,
//         duration: duration,
//         title: title,
//         categoryName: categoryName,
//         videoType: videoType,
//       );
//
//   factory DIModel.fromJson(dynamic json) {
//     return DIModel(
//       videoId: json['video_id'] as int,
//       videoUrl: json['video_url'] as String,
//       thumbnailUrl: json['thumbnail_url'] as String,
//       duration: json['duration'] as String,
//       title: json['title'] as String,
//       categoryName: json['category_name'] as String,
//       videoType: ResourceType.fromJson(json['video_type'] as int)!,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['video_id'] = videoId;
//     data['video_url'] = videoUrl;
//     data['thumbnail_url'] = thumbnailUrl;
//     data['duration'] = duration;
//     data['title'] = title;
//     data['category_name'] = categoryName;
//     data['video_type'] = videoType.toInt();
//     return data;
//   }
// }

class DetailItem extends ConsumerStatefulWidget {
  final AppStyle appStyle;
  final VideoResponse? model;
  final PdfResponse? pdfModel;
  final String? title;
  final String? subTitle;
  final String index;
  final int? seletedItemId;
  final bool isDownloaded;
  final bool? isShow, isAudio;
  final GestureTapCallback? onToggleBookmark;
  final bool? isRemove;
  final void Function()? pressRemove;

  const DetailItem.video({
    super.key,
    required this.appStyle,
    required VideoResponse this.model,
    required this.index,
    this.seletedItemId,
    required this.onToggleBookmark,
    required this.isDownloaded,
    this.isShow,
    this.isRemove,
    this.isAudio,
    this.pressRemove,
  })  : title = null,
        subTitle = null,
        pdfModel = null;

  const DetailItem.pdf({
    super.key,
    required this.appStyle,
    required this.index,
    this.seletedItemId,
    this.pdfModel,
    this.isAudio = false,
    required String this.title,
    required String this.subTitle,
    required this.isDownloaded,
    required this.onToggleBookmark,
    this.isRemove,
    this.pressRemove,
    this.isShow,
  }) : model = null;

  @override
  ConsumerState<DetailItem> createState() => _DetailItemState();
}

class _DetailItemState extends ConsumerState<DetailItem> {
  // bool _isDownloading = false, _isDownloadComplete = false;
  //
  // double _progress = 0.0;

  @override
  void initState() {
    final playlistP = ref.read(playListProvider);
    final courseP = ref.read(courseProvider);

    Future.delayed(
      Duration.zero,
      () {
        playlistP.getPlaylistList();
        // print("playlist gettttttt........=>${playlistP.playlistListResponse == null}=====${playlistP.playlistListResponse?.isEmpty}.");
        // if (playlistP.playlistListResponse != null && playlistP.playlistListResponse!.isNotEmpty) {
        //   print("playlist gettttttt.........");
        //   playlistP.getPlaylistList();
        // }

        getCategory();
      },
    );
    super.initState();
  }

  getCategory() async {
    final coursePRead = ref.read(courseProvider);
    final coursePWatch = ref.watch(courseProvider);
    await coursePRead.getCategoryPdfFromDatabase();
    await coursePRead.getCategoryFromDatabase();
    await coursePRead.getAudioCategoryFromDatabase();

    await coursePRead.getVideoFromDatabase(widget.model?.categoryId ?? 0);
    await coursePRead.getAudioFromDatabase(widget.model?.categoryId ?? 0);
    await coursePRead.getPdfFromDatabase(widget.pdfModel?.categoryId ?? 0);
  }

  @override
  void deactivate() {
    // ref.read(courseProvider.notifier).downloadPdfResponses.clear();
    // ref.read(courseProvider.notifier).downloadResponse.clear();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = widget.appStyle.text.font(mulishRegular400, sizePx: 9);
    var radius = widget.appStyle.scaleX(10);
    var dimension = widget.appStyle.scaleX(97);
    bool isVideo = widget.model != null;
    bool isPdf = widget.pdfModel != null;
    var pdfIconSize = isVideo ? 0.0 : widget.appStyle.scaleX(30);

    final playlistP = ref.watch(playListProvider);

    final videoP = ref.watch(videoProvider);
    final audioP = ref.watch(audioProvider);
    var paidVideo = ref.watch(paidVideosProvider);
    var paidAudio = ref.watch(paidAudiosProvider);
    var freePdf = ref.watch(freePdfsProvider);
    var paidPdf = ref.watch(freePdfsProvider);
    var paidAllItem = ref.watch(paidAllItemProvider);
    var freeallItem = ref.watch(freePdfsProvider);
    log("color------${videoP.isSelected}=====${int.parse(widget.index)}");
    log("color 222------${videoP.selectedItemId}=====${widget.seletedItemId})}");
    log("bookmark in detail item------${widget.model?.bookmarked} ${widget.pdfModel?.bookmarked} ");
    log("bookmark pdf in detail item------${widget.pdfModel?.bookmarked} ${!widget.isDownloaded} ${widget.isShow} ");
    return Container(
      decoration: ShapeDecoration(
        color: const Color(0xFF1B1B1B),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.appStyle.scaleX(10)),
            side: BorderSide(
                // color: videoP.isSelected != null
                //     ? videoP.isSelected == int.parse(widget.index)
                color: videoP.selectedItemId != null
                    ? videoP.selectedItemId == widget.seletedItemId
                        ? AppColors.primaryColor
                        : AppColors.detailItemBgColor
                    : AppColors.detailItemBgColor)),
      ),
      alignment: Alignment.center,
      child: IntrinsicHeight(
        child: Row(
          children: [
            if (isVideo)
              MediaImageCard(
                appStyle: widget.appStyle,
                imgUrl: widget.model?.imgUrl ?? '',
                duration: widget.model?.duration?.toDuration ?? "",
                imgRadius: radius,
                imgSize: dimension,
              )
            else
              Container(
                key: const ValueKey<String>('pdf-icon'),
                width: dimension,
                height: dimension,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius),
                  color: AppColors.pdfItemBgColor,
                ),
                alignment: Alignment.center,
                child: Image.asset(
                  ImagePaths.pdfIcon,
                  width: pdfIconSize,
                  height: pdfIconSize,
                  fit: BoxFit.contain,
                ),
              ),
            SizedBox(width: widget.appStyle.scaleX(20)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isVideo ? '${widget.model!.title}' : widget.title ?? '',
                    style: widget.appStyle.text.font(mulishSemiBold600, sizePx: 14, color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: widget.appStyle.scaleX(12)),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: widget.appStyle.scaleX(10),
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '●',
                            style: widget.appStyle.text.font(mulishSemiBold600, sizePx: 14, color: AppColors.primaryColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(width: widget.appStyle.scaleX(5)),
                          Expanded(
                            child: Text(
                              isVideo ? widget.model?.category?.title ?? "" : widget.subTitle ?? '',
                              style: textStyle.copyWith(color: AppColors.categoryNameColor, fontSize: 9, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: widget.appStyle.scaleX(60)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (widget.isRemove ?? false)
              IconButton(
                onPressed: () {
                  widget.pressRemove!();
                },
                icon: SvgPicture.asset(
                  SvgPaths.remove,
                  height: 17,
                  fit: BoxFit.contain,
                ),
                style: IconButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              ),
            if (isVideo)
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Spacer(),
                  OutlinedIconButton.svg(
                    widget.model!.bookmarked != null && widget.model!.bookmarked! ? SvgPaths.bookmarkSelected : SvgPaths.bookmarkUnselected,
                    appStyle: widget.appStyle,
                    // svgIconSrc: SvgPaths.bookmarkSelected,
                    onTap: widget.onToggleBookmark,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      if (!widget.isDownloaded)
                        Consumer(
                          builder: (context, ref, child) {
                            final downloadP = ref.watch(downloadProvider);
                            bool getCat = false;
                            if (widget.isAudio ?? false) {
                              getCat = ref.watch(courseProvider).downloadAudioResponse.any((element) => int.parse(element.videoId ?? "") == widget.model?.id);
                              print('--------audio---------->${getCat}');
                              ref.watch(courseProvider).downloadAudioResponse.any((e) {
                                return true;
                              });
                            } else {
                              getCat = ref.watch(courseProvider).downloadVideoResponse.any((element) => int.parse(element.videoId ?? "") == widget.model?.video?.id);
                              print('--------video---------->${getCat}');
                              ref.watch(courseProvider).downloadVideoResponse.any((e) {
                                return true;
                              });
                            }

                            if (getCat) {
                              return const SizedBox.shrink();
                            } else {
                              // if (downloadP.isDownloading && widget.model?.categoryId == downloadP.model?.categoryId) {
                              if (downloadP.isDownloading && widget.model?.id == downloadP.model?.id) {
                                return SizedBox(
                                  height: 15,
                                  width: 15,
                                  child: CircularProgressIndicator(
                                    strokeCap: StrokeCap.butt,
                                    strokeWidth: 2,
                                    value: downloadP.progress,
                                  ),
                                );
                              } else {
                                return OutlinedIconButton.svg(
                                  SvgPaths.download,
                                  appStyle: widget.appStyle,
                                  // svgIconSrc: SvgPaths.bookmarkSelected,
                                  onTap: () async {
                                    print("download call=========");
                                    if ((widget.model?.category?.isPurchased ?? false) || widget.model?.videoType == ResourceType.free) {
                                      log("model--------->${widget.model?.toJson()}");
                                      print("download--${downloadP.isDownloading}---${widget.model!.id}---${downloadP.model?.id}----${downloadP.model}");
                                      debugPrint('File Path :: ${widget.model?.video?.fileName ?? ""}');
                                      bool isLoggedIn = ref.read(authProvider).isUserLoggedIn;
                                      if (!isLoggedIn) {
                                        showCustomSnackBar(
                                          'Please Sign in to Download',
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
                                      if (downloadP.model == null) {
                                        if (widget.model?.video != null) {
                                          downloadP.download(model: widget.model);
                                          log("vedio download");
                                        } else {
                                          downloadP.downloadAudio(model: widget.model);
                                        }
                                      } else if (widget.model!.id != downloadP.model!.id) {
                                        if (widget.model?.video != null) {
                                          showCustomSnackBar('Another Video is in progress');
                                        } else {
                                          showCustomSnackBar('Another Audio is in progress');
                                        }
                                      }
                                    } else {
                                      await buyNow(context, categoryId: (widget.model?.category?.id ?? 0).toString());
                                      paidVideo.fetchVideos(widget.model?.category?.id ?? 0);
                                      paidAudio.fetchAudios(widget.model?.category?.id ?? 0);
                                      paidAllItem.fetchAllPaidItem(widget.model?.category?.id ?? 0);
                                      ref.read(featuredVideosProvider).getFeatureVideoList(1, true);
                                    }
                                  },
                                );
                              }
                            }
                          },
                        ),
                      const SizedBox(
                        width: 10,
                      ),
                      MenuAnchor(
                        menuChildren: [
                          MenuItemButton(
                            onPressed: () async {
                              log("create playlist-->${widget.model?.videoType == ResourceType.free}");
                              if ((widget.model?.category?.isPurchased ?? false) || widget.model?.videoType == ResourceType.free) {
                                log("create playlist---${widget.model?.id?.toString()}---${widget.model?.video}-widget.isAudio---${widget.isAudio}");
                                bool isLoggedIn = ref.read(authProvider).isUserLoggedIn;
                                // if ((widget.model?.video != null) && widget.model?.id != null && isLoggedIn) {
                                if (widget.model?.id != null && isLoggedIn) {
                                  createPlaylist(context, videoId: widget.model?.id?.toString(), isAudio: widget.isAudio ?? false);
                                } else {
                                  showCustomSnackBar(
                                    'Please Sign in to create playlist.',
                                    action: SnackBarAction(
                                      label: 'Sign in',
                                      backgroundColor: AppColors.primaryColor.withOpacity(0.8),
                                      textColor: Colors.brown.shade800,
                                      onPressed: () => appRouter.go(RoutePath.signIn),
                                    ),
                                    duration: const Duration(seconds: 5),
                                  );
                                }
                              } else {
                                await buyNow(context, categoryId: (widget.model?.category?.id ?? 0).toString());
                                paidVideo.fetchVideos(widget.model?.category?.id ?? 0);
                                paidAudio.fetchAudios(widget.model?.category?.id ?? 0);
                              }
                            },
                            child: Text(
                              'Create Playlist',
                              style: widget.appStyle.text.font(mulishSemiBold600, sizePx: 12, color: AppColors.deleteMenuText),
                            ),
                          ),
                          if (ref.read(authProvider).isUserLoggedIn && playlistP.playlistListResponse != null)
                            SubmenuButton(
                              menuStyle: const MenuStyle(backgroundColor: WidgetStatePropertyAll(AppColors.popupMenuItemColor), surfaceTintColor: MaterialStatePropertyAll(AppColors.popupMenuItemColor)),
                              menuChildren: [
                                ...List.generate(playlistP.playlistListResponse!.length, (index) {
                                  return MenuItemButton(
                                    onPressed: () async {
                                      log("Add to playlist tapped");
                                      if ((widget.model?.category?.isPurchased ?? false) || widget.model?.videoType == ResourceType.free) {
                                        await playlistP.addToPlaylist(playlistP.playlistListResponse![index].id.toString(), widget.model!.id!.toString(), widget.isAudio ?? false);
                                      } else {
                                        await buyNow(context, categoryId: (widget.model?.category?.id ?? 0).toString());
                                        paidVideo.fetchVideos(widget.model?.category?.id ?? 0);
                                        paidAudio.fetchAudios(widget.model?.category?.id ?? 0);
                                      }
                                    },
                                    child: Text(
                                      playlistP.playlistListResponse![index].title ?? '',
                                      style: widget.appStyle.text.font(
                                        mulishSemiBold600,
                                        sizePx: 12,
                                        color: AppColors.deleteMenuText,
                                      ),
                                    ),
                                  );
                                }),
                              ],
                              child: Text(
                                'Add to Playlist',
                                style: widget.appStyle.text.font(mulishSemiBold600, sizePx: 12, color: AppColors.deleteMenuText),
                              ),
                              style: SubmenuButton.styleFrom(
                                backgroundColor: AppColors.popupMenuItemColor,
                                surfaceTintColor: AppColors.popupMenuItemColor,
                                iconColor: Colors.grey,
                              ),
                            )
                          else
                            MenuItemButton(
                              onPressed: () {
                                showCustomSnackBar(
                                  'Please Sign in to Add to Playlist',
                                  action: SnackBarAction(
                                    label: 'Sign in',
                                    backgroundColor: AppColors.primaryColor.withOpacity(0.8),
                                    textColor: Colors.brown.shade800,
                                    onPressed: () => appRouter.go(RoutePath.signIn),
                                  ),
                                  duration: const Duration(seconds: 5),
                                );
                              },
                              child: Text(
                                'Add to Playlist',
                                style: widget.appStyle.text.font(mulishSemiBold600, sizePx: 12, color: AppColors.deleteMenuText),
                              ),
                            )

                          // SubmenuButton(
                          //   menuChildren: [
                          //     if (playlistP.playlistListResponse != null && ref.read(authProvider).isUserLoggedIn) ...[
                          //       ...List.generate(playlistP.playlistListResponse!.length, (index) {
                          //         return MenuItemButton(
                          //           // height: widget.appStyle.scaleX(24),
                          //           onPressed: () async {
                          //             log("Add to  playlist-->${widget.model?.videoType == ResourceType.free}");
                          //             if ((widget.model?.category?.isPurchased ?? false) || widget.model?.videoType == ResourceType.free) {
                          //               log("Add to  playlist---${widget.model!.id!.toString()}---${widget.model!.video!.id!.toString()}");
                          //               bool isLoggedIn = ref.read(authProvider).isUserLoggedIn;
                          //               if (widget.model!.video != null && widget.model!.id != null && isLoggedIn) {
                          //                 await playlistP.addToPlaylist(playlistP.playlistListResponse![index].id.toString(), widget.model!.id!.toString(), widget.isAudio!);
                          //               } else {
                          //                 showCustomSnackBar(
                          //                   'Please Sign in to Add to Playlist',
                          //                   action: SnackBarAction(
                          //                     label: 'Sign in',
                          //                     backgroundColor: AppColors.primaryColor.withOpacity(0.8),
                          //                     textColor: Colors.brown.shade800,
                          //                     onPressed: () => appRouter.go(RoutePath.signIn),
                          //                   ),
                          //                   duration: const Duration(seconds: 5),
                          //                 );
                          //               }
                          //             } else {
                          //               await buyNow(context, categoryId: (widget.model?.category?.id ?? 0).toString());
                          //               paidVideo.fetchVideos(widget.model?.category?.id ?? 0);
                          //               paidAudio.fetchAudios(widget.model?.category?.id ?? 0);
                          //             }
                          //           },
                          //           child: Text(
                          //             playlistP.playlistListResponse![index].title ?? '',
                          //             style: widget.appStyle.text.font(mulishSemiBold600, sizePx: 12, color: AppColors.deleteMenuText),
                          //           ),
                          //         );
                          //       })
                          //     ]
                          //   ],
                          //   menuStyle: const MenuStyle(
                          //     padding: MaterialStatePropertyAll(EdgeInsets.zero),
                          //     backgroundColor: MaterialStatePropertyAll(AppColors.popupMenuItemColor),
                          //   ),
                          //   style: SubmenuButton.styleFrom(backgroundColor: AppColors.popupMenuItemColor, surfaceTintColor: AppColors.popupMenuItemColor, iconColor: Colors.grey),
                          //   child: Text(
                          //     'Add to Playlist',
                          //     style: widget.appStyle.text.font(mulishSemiBold600, sizePx: 12, color: AppColors.deleteMenuText),
                          //   ),
                          // ),
                        ],
                        style: const MenuStyle(
                          // padding: MaterialStatePropertyAll(EdgeInsets.zero),
                          backgroundColor: MaterialStatePropertyAll(AppColors.popupMenuItemColor),
                          visualDensity: VisualDensity(vertical: -4),
                          surfaceTintColor: MaterialStatePropertyAll(AppColors.popupMenuItemColor),
                        ),
                        builder: (context, controller, child) {
                          return OutlinedIconButton.svg(
                            SvgPaths.addToPlaylist,
                            appStyle: widget.appStyle,
                            onTap: () {
                              if (controller.isOpen) {
                                controller.close();
                              } else {
                                controller.open();
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              )
            // else if (!widget.isDownloaded)
            else if (isPdf)
              (widget.isShow ?? false)
                  ? Row(
                      children: [
                        if (!widget.isDownloaded)
                          Consumer(
                            builder: (context, ref, child) {
                              final downloadP = ref.watch(downloadProvider);
                              bool getCat = false;
                              for (final e in ref.watch(courseProvider).downloadPdfResponse) {
                                print("Comparing e.pdfId=${e.pdfId} with widget.pdfModel.id=${widget.pdfModel?.id}");
                              }
                              getCat = ref.watch(courseProvider).downloadPdfResponse.any((element) => int.parse(element.pdfId ?? "") == widget.pdfModel?.id);
                              print('-----gat cat---pdf---------->${getCat}');
                              if (getCat) {
                                return const SizedBox.shrink();
                              } else {
                                if (downloadP.isPdfDownloading && widget.pdfModel?.id == downloadP.pdfModel?.id) {
                                  return SizedBox(
                                    height: 15,
                                    width: 15,
                                    child: CircularProgressIndicator(
                                      strokeCap: StrokeCap.butt,
                                      strokeWidth: 2,
                                      value: downloadP.progress,
                                    ),
                                  );
                                } else {
                                  return OutlinedIconButton.svg(
                                    SvgPaths.download,
                                    appStyle: widget.appStyle,
                                    // svgIconSrc: SvgPaths.bookmarkSelected,
                                    onTap: () async {
                                      print('------------pdf download-------->${widget.pdfModel?.toJson()}');
                                      print('------------pdf download11-------->${downloadP.pdfModel?.toJson()}');
                                      print('------------pdf download22-------->${widget.pdfModel?.pdfType == ResourceType.free}');
                                      if ((widget.pdfModel?.category?.isPurchased ?? false) || widget.pdfModel?.pdfType == ResourceType.free) {
                                        bool isLoggedIn = ref.read(authProvider).isUserLoggedIn;
                                        if (!isLoggedIn) {
                                          showCustomSnackBar(
                                            'Please Sign in to Download',
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
                                        if (downloadP.pdfModel == null) {
                                          print(widget.pdfModel?.categoryId ?? "");
                                          downloadP.pdfDownload(model: widget.pdfModel);
                                        } else if (widget.pdfModel?.id != downloadP.pdfModel?.id) {
                                          showCustomSnackBar('Another PDF is in progress');
                                        }
                                      } else {
                                        await buyNow(context, categoryId: (widget.pdfModel?.category?.id ?? 0).toString());
                                        paidPdf.fetchPdfs(widget.pdfModel?.category?.id ?? 0);
                                        paidAllItem.fetchAllPaidItem(widget.pdfModel?.category?.id ?? 0);
                                      }
                                    },
                                  );
                                }
                              }
                            },
                          ),
                        const SizedBox(width: 8), // spacing between buttons
                        OutlinedIconButton.svg(
                          widget.pdfModel?.bookmarked != null && (widget.pdfModel?.bookmarked ?? false) ? SvgPaths.bookmarkSelected : SvgPaths.bookmarkUnselected,
                          appStyle: widget.appStyle,
                          onTap: widget.onToggleBookmark,
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            SizedBox(width: widget.appStyle.scaleX(10)),
          ],
        ),
      ),
    );
  }

  void createPlaylist(BuildContext context, {String? videoId, bool isAudio = false}) {
    showDialog(
      context: context,
      // barrierDismissible: false,
      builder: (c) {
        return ProviderScope(
          parent: ProviderScope.containerOf(context, listen: false),
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.appStyle.scaleX(10))),
            child: CreatePlaylistDialog(
              widget.appStyle,
              videoId: videoId,
              isAudio: isAudio,
            ),
          ),
        );
      },
    );
  }
}
