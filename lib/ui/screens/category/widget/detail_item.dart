import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meditation_app/data/model/response/pdfs_response.dart';
import 'package:meditation_app/helper/string_converter.dart';
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
import '../../../../theme/colors.dart';
import '../../../../theme/styles.dart';
import '../../../../theme/text_style.dart';
import '../../../../util/assets.dart';
import '../../../common/media_image_card.dart';
import '../../../common/outlined_icon_button.dart';

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
    this.isRemove,
    this.pressRemove,
    this.isShow,
  })  : model = null,
        onToggleBookmark = null;

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

    /*for(final category in coursePWatch.downloadPdfResponses){
    }*/
    await coursePRead.getPdfFromDatabase(widget.pdfModel?.categoryId ?? 0);

    /* for(final category in coursePWatch.downloadResponse){
      print('-------------149${category.categoryId}');

    }*/
    await coursePRead.getVideoFromDatabase(widget.model?.categoryId ?? 0);
  }

  @override
  void deactivate() {
    ref.read(courseProvider.notifier).downloadPdfResponses.clear();
    ref.read(courseProvider.notifier).downloadResponse.clear();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = widget.appStyle.text.font(mulishRegular400, sizePx: 9);
    var radius = widget.appStyle.scaleX(10);
    var dimension = widget.appStyle.scaleX(97);
    bool isVideo = widget.model != null;
    var pdfIconSize = isVideo ? 0.0 : widget.appStyle.scaleX(30);

    final playlistP = ref.watch(playListProvider);

    final videoP = ref.watch(videoProvider);
    log("color------${videoP.isSelected}=====${int.parse(widget.index)}");
    log("color 222------${videoP.selectedItemId}=====${widget.seletedItemId})}");
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
                imgUrl: widget.model!.imgUrl ?? '',
                duration: widget.model!.duration!.toDuration,
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
                          Flexible(
                            child: Text(
                              isVideo ? widget.model?.category?.title ?? "" : widget.subTitle ?? '',
                              style: textStyle.copyWith(color: AppColors.categoryNameColor),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: widget.appStyle.scaleX(120)),
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
                            final getCat = ref.watch(courseProvider).downloadVideoResponse.any((element) => int.parse(element.videoId ?? "") == widget.model?.video?.id);
                            print('------------------>${getCat}');
                            ref.watch(courseProvider).downloadVideoResponse.any((e) {
                              print('------------------292>${e.videoId}');
                              return true;
                            });
                            print('------------------294>${widget.model?.video?.id}');
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
                                  onTap: () {
                                    print("download--${downloadP.isDownloading}---${widget.model!.id}---${downloadP.model?.id}----${downloadP.model}");
                                    if (downloadP.model == null) {
                                      downloadP.download(model: widget.model);
                                    } else if (widget.model!.id != downloadP.model!.id) {
                                      showCustomSnackBar('Another Video is in progress');
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
                            onPressed: () {
                              log("create playlist---${widget.model!.id!.toString()}---${widget.model!.video!.id!.toString()}");
                              bool isLoggedIn = ref.read(authProvider).isUserLoggedIn;
                              if (widget.model!.video != null && widget.model!.id != null && isLoggedIn) {
                                createPlaylist(context, videoId: widget.model?.id?.toString());
                              }else{
                                showCustomSnackBar(
                                  'Please login to create playlist.',
                                  action: SnackBarAction(
                                    label: 'Log In',
                                    backgroundColor:
                                    AppColors.primaryColor.withOpacity(0.8),
                                    textColor: Colors.brown.shade800,
                                    onPressed: () => appRouter.go(RoutePath.signIn),
                                  ),
                                  duration: const Duration(seconds: 5),
                                );
                              }
                            },
                            child: Text(
                              'Create Playlist',
                              style: widget.appStyle.text.font(mulishSemiBold600, sizePx: 12, color: AppColors.deleteMenuText),
                            ),
                          ),
                          SubmenuButton(
                            menuChildren: [
                              if (playlistP.playlistListResponse != null) ...[
                                ...List.generate(playlistP.playlistListResponse!.length, (index) {
                                  return PopupMenuItem(
                                    height: widget.appStyle.scaleX(24),
                                    onTap: () async {
                                      // log("add to playlist---${widget.model!.id!.toString()}---${widget.model!.video!.id!.toString()}");
                                      // await playlistP.addToPlaylist(playlistP.playlistListResponse![index].id.toString(), widget.model!.video!.id!.toString());
                                      await playlistP.addToPlaylist(playlistP.playlistListResponse![index].id.toString(), widget.model!.id!.toString(), widget.isAudio!);
                                    },
                                    child: Text(
                                      playlistP.playlistListResponse![index].title ?? '',
                                      style: widget.appStyle.text.font(mulishSemiBold600, sizePx: 12, color: AppColors.deleteMenuText),
                                    ),
                                  );
                                })
                              ]
                            ],
                            menuStyle: const MenuStyle(
                              padding: MaterialStatePropertyAll(EdgeInsets.zero),
                              backgroundColor: MaterialStatePropertyAll(AppColors.popupMenuItemColor),
                            ),
                            style: SubmenuButton.styleFrom(backgroundColor: AppColors.popupMenuItemColor, surfaceTintColor: AppColors.popupMenuItemColor, iconColor: Colors.grey),
                            child: Text(
                              'Add to Playlist',
                              style: widget.appStyle.text.font(mulishSemiBold600, sizePx: 12, color: AppColors.deleteMenuText),
                            ),
                          ),
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
            else if (!widget.isDownloaded)
              widget.isShow == true
                  ? Consumer(
                      builder: (context, ref, child) {
                        final downloadP = ref.watch(downloadProvider);
                        final getCat = ref.read(courseProvider).downloadPdfResponse.any((element) => int.parse(element.pdfId ?? "") == widget.pdfModel?.pdf?.id);

                        ref.watch(courseProvider).downloadPdfResponse.any((e) {
                          print('________))))))))))((((((((((4355(((${e.pdfId}');

                          return true;
                        });
                        // print('________))))))))))((((((((((4399(((${widget.pdfModel?.pdf?.id}');

                        // print('________*****************________442(((${widget.pdfModel?.categoryId}');
                        // print('________*****************________443(((${downloadP.pdfModel?.categoryId}');
                        // print('________*****************________444(((${downloadP.isPdfDownloading}');

                        if (getCat) {
                          return const SizedBox.shrink();
                        } else {
                          if (downloadP.isPdfDownloading && widget.pdfModel!.id == downloadP.pdfModel!.id) {
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
                              onTap: () {
                                print('---------------------?${downloadP.pdfModel?.categoryId ?? 0}');
                                if (downloadP.pdfModel == null) {
                                  print(widget.pdfModel?.categoryId ?? "");
                                  downloadP.pdfDownload(model: widget.pdfModel);
                                } else if (widget.pdfModel!.id != downloadP.pdfModel!.id) {
                                  showCustomSnackBar('Another PDF is in progress');
                                }
                              },
                            );
                          }
                        }
                      },
                    )
                  : const SizedBox.shrink(),
            SizedBox(width: widget.appStyle.scaleX(10)),
          ],
        ),
      ),
    );
  }

  void createPlaylist(BuildContext context, {String? videoId}) {
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
            ),
          ),
        );
      },
    );
  }
}
