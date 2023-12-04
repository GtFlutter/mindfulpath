import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/helper/string_converter.dart';
import 'package:meditation_app/provider/playlist_provider.dart';
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
  final String imgUrl;
  final String duration;
  final String title;
  final String category;
  final ResourceType videoType;

  const DIModel({
    required this.videoType,
    required this.videoId,
    required this.imgUrl,
    required this.duration,
    required this.title,
    required this.category,
  });

  DIModel copyWith() => DIModel(
        videoId: videoId,
        imgUrl: imgUrl,
        duration: duration,
        title: title,
        category: category,
        videoType: videoType,
      );
}

class DetailItem extends ConsumerWidget {
  final AppStyle appStyle;
  final VideoResponse? model;
  final String? title;
  final String? subTitle;
  final String index;
  final GestureTapCallback? onToggleBookmark;

  const DetailItem.video({
    super.key,
    required this.appStyle,
    required VideoResponse this.model,
    required this.index,
    required this.onToggleBookmark,
  })  : title = null,
        subTitle = null;

  const DetailItem.pdf({
    super.key,
    required this.appStyle,
    required this.index,
    required String this.title,
    required String this.subTitle,
  })  : model = null,
        onToggleBookmark = null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextStyle textStyle = appStyle.text.font(mulishRegular400, sizePx: 9);
    var radius = appStyle.scaleX(10);
    var dimension = appStyle.scaleX(97);
    bool isVideo = model != null;
    var pdfIconSize = isVideo ? 0.0 : appStyle.scaleX(30);
    return Container(
      decoration: ShapeDecoration(
        color: const Color(0xFF1B1B1B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(appStyle.scaleX(10)),
        ),
      ),
      alignment: Alignment.center,
      child: IntrinsicHeight(
        child: Row(
          children: [
            if (isVideo)
              MediaImageCard(
                appStyle: appStyle,
                imgUrl: model!.imgUrl ?? '',
                duration: model!.duration!.toDuration,
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
            SizedBox(width: appStyle.scaleX(20)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isVideo ? '${model!.title}' : title ?? '',
                    style: appStyle.text.font(mulishSemiBold600, sizePx: 14, color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: appStyle.scaleX(12)),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: appStyle.scaleX(10),
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '●',
                            style: appStyle.text.font(mulishSemiBold600, sizePx: 14, color: AppColors.primaryColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(width: appStyle.scaleX(5)),
                          Flexible(
                            child: Text(
                              isVideo ? '${model!.categoryTitle}' : subTitle ?? '',
                              style: textStyle.copyWith(color: AppColors.categoryNameColor),
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
                children: [
                  const Spacer(),
                  OutlinedIconButton.svg(
                    model!.bookmarked != null && model!.bookmarked!
                        ? SvgPaths.bookmarkSelected
                        : SvgPaths.bookmarkUnselected,
                    appStyle: appStyle,
                    // svgIconSrc: SvgPaths.bookmarkSelected,
                    onTap: onToggleBookmark,
                  ),
                  // const Spacer(),
                  PopupMenuButton(
                    padding: EdgeInsets.zero,
                    position: PopupMenuPosition.under,
                    iconSize: 15,
                    splashRadius: 1,
                    tooltip: '',
                    icon: OutlinedIconButton.svg(
                      SvgPaths.addToPlaylist,
                      appStyle: appStyle,
                      onTap: null,
                    ),
                    constraints: BoxConstraints(maxWidth: appStyle.scaleX(200), maxHeight: appStyle.scaleX(204)),
                    // onOpened: () async {
                    //   await ref.read(playListProvider).getPlaylistList();
                    // },
                    color: AppColors.popupMenuItemColor,
                    itemBuilder: (context) {
                      final playlistP = ref.read(playListProvider);
                      playlistP.getPlaylistList();
                      return [
                        PopupMenuItem(
                          height: appStyle.scaleX(24),
                          onTap: () {
                            if (model!.video != null && model!.video!.id != null) {
                              createPlaylist(context, videoId: model!.video?.id?.toString());
                            }
                          },
                          child: Text(
                            'Create Playlist',
                            style: appStyle.text.font(mulishSemiBold600, sizePx: 12, color: AppColors.deleteMenuText),
                          ),
                        ),
                        if (playlistP.playlistListResponse != null) ...[
                          ...List.generate(playlistP.playlistListResponse!.length, (index) {
                            return PopupMenuItem(
                              height: appStyle.scaleX(24),
                              onTap: () {},
                              child: Text(
                                playlistP.playlistListResponse![index].title ?? '',
                                style:
                                    appStyle.text.font(mulishSemiBold600, sizePx: 12, color: AppColors.deleteMenuText),
                              ),
                            );
                          })
                        ]
                      ];
                    },
                  ),
                ],
              ),
            SizedBox(width: appStyle.scaleX(10)),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(appStyle.scaleX(10))),
            child: CreatePlaylistDialog(
              appStyle,
              videoId: videoId,
            ),
          ),
        );
      },
    );
  }
}
