import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/data/model/response/pdfs_response.dart';
import 'package:meditation_app/helper/string_converter.dart';
import 'package:meditation_app/provider/download_provider.dart';
import 'package:meditation_app/provider/playlist_provider.dart';
import 'package:meditation_app/ui/common/custom_snackbar.dart';
import 'package:meditation_app/ui/screens/playlist/widget/create_playlist_dialog.dart';

import '../../../../data/model/body/resource_type.dart';
import '../../../../data/model/response/videos_response.dart';
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

  const DIModel({
    required this.videoType,
    required this.videoId,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.duration,
    required this.title,
    required this.categoryName,
  });

  DIModel copyWith() => DIModel(
        videoId: videoId,
        videoUrl: videoUrl,
        thumbnailUrl: thumbnailUrl,
        duration: duration,
        title: title,
        categoryName: categoryName,
        videoType: videoType,
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
    return data;
  }
}

class DetailItem extends ConsumerStatefulWidget {
  final AppStyle appStyle;
  final VideoResponse? model;
  final PdfResponse? pdfModel;
  final String? title;
  final String? subTitle;
  final String index;
  final bool isDownloaded;
  final GestureTapCallback? onToggleBookmark;

  const DetailItem.video({
    super.key,
    required this.appStyle,
    required VideoResponse this.model,
    required this.index,
    required this.onToggleBookmark,
    required this.isDownloaded,
  })  : title = null,
        subTitle = null,
        pdfModel = null;

  const DetailItem.pdf({
    super.key,
    required this.appStyle,
    required this.index,
    required PdfResponse this.pdfModel,
    required String this.title,
    required String this.subTitle,
    required this.isDownloaded,
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
    Future.delayed(
      Duration.zero,
      () {
        if (playlistP.playlistListResponse != null &&
            playlistP.playlistListResponse!.isNotEmpty) {
          playlistP.getPlaylistList();
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle =
        widget.appStyle.text.font(mulishRegular400, sizePx: 9);
    var radius = widget.appStyle.scaleX(10);
    var dimension = widget.appStyle.scaleX(97);
    bool isVideo = widget.model != null;
    var pdfIconSize = isVideo ? 0.0 : widget.appStyle.scaleX(30);

    final playlistP = ref.watch(playListProvider);


    return Container(
      decoration: ShapeDecoration(
        color: const Color(0xFF1B1B1B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.appStyle.scaleX(10)),
        ),
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
                    style: widget.appStyle.text.font(mulishSemiBold600,
                        sizePx: 14, color: Colors.white),
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
                            style: widget.appStyle.text.font(mulishSemiBold600,
                                sizePx: 14, color: AppColors.primaryColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(width: widget.appStyle.scaleX(5)),
                          Flexible(
                            child: Text(
                              isVideo
                                  ? '${widget.model!.categoryTitle}'
                                  : widget.subTitle ?? '',
                              style: textStyle.copyWith(
                                  color: AppColors.categoryNameColor),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isVideo)
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Spacer(),
                  OutlinedIconButton.svg(
                    widget.model!.bookmarked != null &&
                            widget.model!.bookmarked!
                        ? SvgPaths.bookmarkSelected
                        : SvgPaths.bookmarkUnselected,
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
                            if (downloadP.isDownloading &&
                                widget.model!.id == downloadP.model!.id) {
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
                                  print(
                                      "download--${downloadP.isDownloading}---${widget.model!.id}---${downloadP.model?.id}----${downloadP.model}");
                                  if (downloadP.model == null) {
                                    downloadP.download(model: widget.model);
                                  } else if (widget.model!.id !=
                                      downloadP.model!.id) {
                                    showCustomSnackBar(
                                        'Another Video is in progress');
                                  }
                                },
                              );
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
                              if (widget.model!.video != null &&
                                  widget.model!.video!.id != null) {
                                createPlaylist(context,
                                    videoId:
                                        widget.model!.video?.id?.toString());
                              }
                            },
                            child: Text(
                              'Create Playlist',
                              style: widget.appStyle.text.font(
                                  mulishSemiBold600,
                                  sizePx: 12,
                                  color: AppColors.deleteMenuText),
                            ),
                          ),
                          SubmenuButton(
                            menuChildren: [
                              if (playlistP.playlistListResponse != null) ...[
                                ...List.generate(
                                    playlistP.playlistListResponse!.length,
                                    (index) {
                                  return PopupMenuItem(
                                    height: widget.appStyle.scaleX(24),
                                    onTap: () async {
                                      await playlistP.addToPlaylist(
                                          playlistP
                                              .playlistListResponse![index].id
                                              .toString(),
                                          widget.model!.video!.id!.toString());
                                    },
                                    child: Text(
                                      playlistP.playlistListResponse![index]
                                              .title ??
                                          '',
                                      style: widget.appStyle.text.font(
                                          mulishSemiBold600,
                                          sizePx: 12,
                                          color: AppColors.deleteMenuText),
                                    ),
                                  );
                                })
                              ]
                            ],
                            menuStyle: const MenuStyle(
                              padding:
                                  MaterialStatePropertyAll(EdgeInsets.zero),
                              backgroundColor: MaterialStatePropertyAll(
                                  AppColors.popupMenuItemColor),
                            ),
                            style: SubmenuButton.styleFrom(
                                backgroundColor: AppColors.popupMenuItemColor,
                                surfaceTintColor: AppColors.popupMenuItemColor,
                                iconColor: Colors.grey),
                            child: Text(
                              'Add to Playlist',
                              style: widget.appStyle.text.font(
                                  mulishSemiBold600,
                                  sizePx: 12,
                                  color: AppColors.deleteMenuText),
                            ),
                          ),
                        ],
                        style: const MenuStyle(
                          // padding: MaterialStatePropertyAll(EdgeInsets.zero),
                          backgroundColor: MaterialStatePropertyAll(
                              AppColors.popupMenuItemColor),
                          visualDensity: VisualDensity(vertical: -4),
                          surfaceTintColor: MaterialStatePropertyAll(
                              AppColors.popupMenuItemColor),
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
                  // if (downloadP.isDownloading)...[
                  //   SizedBox(
                  //     height: 15,
                  //     width: 15,
                  //     child: CircularProgressIndicator(
                  //       strokeCap: StrokeCap.butt,
                  //       strokeWidth: 2,
                  //       value: downloadP.progress,
                  //     ),
                  //   ),
                  // ] else...[
                  //   MenuAnchor(
                  //     menuChildren: [
                  //       MenuItemButton(
                  //         child: Text(
                  //           'Download',
                  //           style: widget.appStyle.text.font(mulishSemiBold600, sizePx: 12, color: AppColors.deleteMenuText),
                  //         ),
                  //         onPressed: () => downloadP.download(model: widget.model),
                  //       ),
                  //       MenuItemButton(
                  //         child: Text(
                  //           'Create Playlist',
                  //           style: widget.appStyle.text.font(mulishSemiBold600, sizePx: 12, color: AppColors.deleteMenuText),
                  //         ),
                  //       ),
                  //       SubmenuButton(
                  //         menuChildren: [
                  //           if (playlistP.playlistListResponse != null) ...[
                  //             ...List.generate(playlistP.playlistListResponse!.length, (index) {
                  //               return PopupMenuItem(
                  //                 height: widget.appStyle.scaleX(24),
                  //                 onTap: () {},
                  //                 child: Text(
                  //                   playlistP.playlistListResponse![index].title ?? '',
                  //                   style:
                  //                   widget.appStyle.text.font(mulishSemiBold600, sizePx: 12, color: AppColors.deleteMenuText),
                  //                 ),
                  //               );
                  //             })
                  //           ]
                  //         ],
                  //         menuStyle: const MenuStyle(
                  //           padding: MaterialStatePropertyAll(EdgeInsets.zero),
                  //           backgroundColor: MaterialStatePropertyAll(AppColors.popupMenuItemColor),
                  //         ),
                  //         style: SubmenuButton.styleFrom(
                  //             backgroundColor: AppColors.popupMenuItemColor,
                  //             surfaceTintColor: AppColors.popupMenuItemColor,
                  //             iconColor: Colors.grey
                  //         ),
                  //         child: Text(
                  //           'Add to Playlist',
                  //           style: widget.appStyle.text.font(mulishSemiBold600, sizePx: 12, color: AppColors.deleteMenuText),
                  //         ),
                  //       ),
                  //     ],
                  //     style: const MenuStyle(
                  //       // padding: MaterialStatePropertyAll(EdgeInsets.zero),
                  //       backgroundColor: MaterialStatePropertyAll(AppColors.popupMenuItemColor),
                  //       visualDensity: VisualDensity(vertical: -4),
                  //       surfaceTintColor: MaterialStatePropertyAll(AppColors.popupMenuItemColor),
                  //     ),
                  //     builder: (context, controller, child) {
                  //       return OutlinedIconButton.svg(
                  //         SvgPaths.addToPlaylist,
                  //         appStyle: widget.appStyle,
                  //         onTap: () {
                  //           if (controller.isOpen) {
                  //             controller.close();
                  //           } else {
                  //             controller.open();
                  //           }
                  //         },
                  //       );
                  //     },
                  //   ),
                  // ],
                  const Spacer(),
                ],
              )
            else
              Consumer(
                builder: (context, ref, child) {
                  final downloadP = ref.watch(downloadProvider);
                  if (downloadP.isPdfDownloading &&
                      widget.pdfModel!.id == downloadP.pdfModel!.id) {
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
                        if (downloadP.pdfModel == null) {
                          downloadP.pdfDownload(model: widget.pdfModel);
                        } else if (widget.pdfModel!.id !=
                            downloadP.pdfModel!.id) {
                          showCustomSnackBar('Another PDF is in progress');
                        }
                      },
                    );
                  }
                },
              ),
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
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(widget.appStyle.scaleX(10))),
            child: CreatePlaylistDialog(
              widget.appStyle,
              videoId: videoId,
            ),
          ),
        );
      },
    );
  }

// void _download() async {
//   if (!ref.read(authProvider).isUserLoggedIn) {
//     showCustomSnackBar(
//       'Please log in to bookmark.',
//       action: SnackBarAction(
//         label: 'Log In',
//         backgroundColor: AppColors.primaryColor.withOpacity(0.8),
//         textColor: Colors.brown.shade800,
//         onPressed: () => appRouter.go(RoutePath.signIn),
//       ),
//       duration: const Duration(seconds: 5),
//     );
//     return;
//   }
//   if (!widget.model!.category!.isPurchased!) {
//     buyNow(context, categoryId: widget.model!.category!.id.toString());
//     return;
//   }
//   await _checkDirectory();
//   String path = await PathHelper.getDownloadDirectoryPath();
//   debugPrint('File Path :: $path/${widget.model!.video!.fileName!}');
//   bool result = await PathHelper.fileExists('$path/${widget.model!.video!.fileName!}');
//   if (result) {
//     debugPrint('True');
//     getSingleVideo('$path/${widget.model!.video!.fileName!}');
//     showCustomSnackBar('File Already Exists', type: true);
//   } else {
//     debugPrint('False');
//     await DownloadHelper.instance.download(
//       widget.model!.videoUrl!,
//       '$path/${widget.model!.video!.fileName!}',
//       onReceiveProgress: (count, total) {
//         debugPrint('Count :: $count --*-- Total :: $total');
//         if (total != -1) {
//           _progress = ((count / total * 100).roundToDouble())/100;
//           if (!_isDownloadComplete) if (!_isDownloading) _isDownloading = true;
//           if (_progress == 1.0) {
//             if (!_isDownloadComplete) {
//               _isDownloadComplete = true;
//               _isDownloading = false;
//               debugPrint('Is Downloading == $_isDownloading --*-*-- Is Download Complete == $_isDownloadComplete');
//               _saveCategoryAndVideo('$path/${widget.model!.video!.fileName!}');
//             }
//           }
//           if (context.mounted) setState(() {});
//           debugPrint("Total Progress 1 :: $_progress%");
//         }
//       },
//     );
//   }
// }
//
// Future<void> _checkDirectory() async {
//   String path = await PathHelper.getDownloadDirectoryPath();
//   debugPrint('Path :: $path');
//   bool result = await PathHelper.directoryExits(path);
//   if (!result) {
//     Directory directory = await PathHelper.createDirectory(path, recursive: true);
//     debugPrint('Directory Path :: ${directory.path}');
//   }
// }
//
// Future<void> getSingleVideo(String videoFile) async {
//   final dbHelper = ref.read(databaseProvider);
//   VideoModal? res = await dbHelper.getSingleVideo(widget.model!.id!.toString());
//   if (res == null) {
//     _saveCategoryAndVideo(videoFile);
//   }
// }
//
// Future<void> _saveCategoryAndVideo(String videoFile) async {
//   final dbHelper = ref.read(databaseProvider);
//   CategoryModal? res = await dbHelper.getSingleCategory(widget.model!.categoryId!.toString());
//   if (res != null) {
//     VideoModal vModal = VideoModal(categoryId: res.id, videoId: widget.model!.id!.toString(),videoName: widget.model!.title, videoFile: videoFile, videoDuration: widget.model!.duration);
//     int vRes = await dbHelper.saveVideo(vModal);
//     if (vRes == 1) showCustomSnackBar('Video Save Successfully download');
//   } else {
//     CategoryModal modal = CategoryModal(categoryId: widget.model!.categoryId!.toString(), categoryName: widget.model!.categoryTitle, categoryImage: widget.model!.category!.imageResponse!.imageUrl);
//     int cRes = await dbHelper.saveCategory(modal);
//     if (cRes == 1) {
//       CategoryModal? res = await dbHelper.getSingleCategory(widget.model!.categoryId!.toString());
//       if (res != null) {
//         VideoModal vModal = VideoModal(categoryId: res.id, videoId: widget.model!.id!.toString(),videoName: widget.model!.title, videoFile: videoFile, videoDuration: widget.model!.duration);
//         int vRes = await dbHelper.saveVideo(vModal);
//         if (vRes == 1) showCustomSnackBar('Video Save Successfully download');
//       }
//     }
//   }
// }
}
