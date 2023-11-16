import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/data/model/response/category_list_reponse.dart';
import 'package:meditation_app/provider/auth_provider.dart';
import 'package:meditation_app/provider/bookmark_provider.dart';
import 'package:meditation_app/provider/dashboard_provider.dart';
import 'package:meditation_app/theme/colors.dart';
import 'package:meditation_app/theme/text_style.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/ui/common/custom_app_bar.dart';
import 'package:meditation_app/ui/common/custom_snackbar.dart';
import 'package:meditation_app/ui/screens/category/widget/detail_item.dart';

import '../../../helper/route/route_paths.dart';
import '../../../theme/styles.dart';
import '../../common/media_player/app_video_player.dart';

class DetailCategoryScreen extends ConsumerStatefulWidget {
  final CategoryListResponse categoryListResponse;
  const DetailCategoryScreen({super.key, required this.categoryListResponse});

  @override
  ConsumerState<DetailCategoryScreen> createState() => _DetailCategoryScreenState();
}

class _DetailCategoryScreenState extends ConsumerState<DetailCategoryScreen> {
  static AppStyle _style = AppStyle();
  ScrollController controller = ScrollController();

  DIModel? _videoDetail;

  String placeHolder =
      'https://images.pexels.com/photos/6740518/pexels-photo-6740518.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';

  @override
  void initState() {
    final dashboardNotifier = ref.read(dashboardProvider);
    Future.delayed(Duration.zero, () {
      dashboardNotifier.getVideoList(widget.categoryListResponse.id ?? 0);
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;

    var size = MediaQuery.of(context).size;
    _style = AppStyle(screenSize: size);
    TextStyle textStyle = _style.text.font(mulishRegular400, sizePx: 14);

    final dashboardNotifier = ref.watch(dashboardProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _videoDetail != null ? null : CustomAppBar(screenSize: size, style: _style),
      body: BackgroundImage.network(
        imgUrl: widget.categoryListResponse.imageResponse?.imageUrl ?? placeHolder,
        hideImage: isLandscape && _videoDetail != null,
        child: SafeArea(
          left: false,
          right: false,
          bottom: false,
          child: Padding(
            padding: isLandscape && _videoDetail != null
                ? EdgeInsets.zero
                : EdgeInsets.symmetric(horizontal: _style.scaleX(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (_videoDetail != null) ...[
                  if (!isLandscape) SizedBox(height: _style.scaleX(25)),
                  Flexible(
                    flex: isLandscape ? 1 : 0,
                    child: Container(
                      width: !isLandscape ? null : double.infinity,
                      height: !isLandscape ? null : double.infinity,
                      alignment: !isLandscape ? null : Alignment.topCenter,
                      constraints: !isLandscape ? BoxConstraints(maxHeight: size.height * 0.4) : null,
                      child: AppVideoPlayer(
                        key: const ValueKey('value'),
                        videoId: _videoDetail!.videoId,
                        url: _videoDetail!.imgUrl,
                        style: _style,
                        isLandscape: isLandscape,
                        onBackPress: () {
                          if (_videoDetail != null) {
                            setState(() => _videoDetail = null);
                          }
                        },
                      ),
                    ),
                  ),
                  if (_videoDetail != null && (_videoDetail == null || !isLandscape)) ...[
                    SizedBox(height: _style.scaleX(15)),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          _videoDetail!.title,
                          style: _style.text.font(mulishSemiBold600, sizePx: 20, color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: _style.scaleX(7)),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: _style.scaleX(10),
                          children: [
                            // Text(
                            //   _videoDetail!.auther,
                            //   maxLines: 1,
                            //   overflow: TextOverflow.ellipsis,
                            //   style: textStyle.copyWith(color: AppColors.autherNameColor),
                            // ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '●',
                                  style: _style.text.font(mulishSemiBold600, sizePx: 14, color: AppColors.primaryColor),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(width: _style.scaleX(5)),
                                Flexible(
                                  child: Text(
                                    _videoDetail!.category,
                                    style: textStyle.copyWith(color: AppColors.autherNameColor),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: _style.scaleX(30)),
                      ],
                    ),
                  ],
                ] else
                  Expanded(
                    flex: 2,
                    child: IntroWidget(
                      description: '',
                      title: widget.categoryListResponse.title ?? '',
                      style: _style,
                    ),
                  ),
                if (!isLandscape)
                  Expanded(
                    flex: 3,
                    child: dashboardNotifier.isVideoLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : dashboardNotifier.videosResponse == null || dashboardNotifier.videosResponse!.list == null
                            ? const Center(
                                child: Text('Unable to find data!'),
                              )
                            : ListView.separated(
                                physics: const AlwaysScrollableScrollPhysics(),
                                controller: controller,
                                scrollDirection: Axis.vertical,
                                padding: EdgeInsets.only(
                                  bottom: _style.scale * 100,
                                  top: _style.scale * 10,
                                ),
                                itemCount: dashboardNotifier.videosResponse!.list!.length,
                                itemBuilder: (context, index) {
                                  var model = dashboardNotifier.videosResponse!.list![index];
                                  return GestureDetector(
                                    onTap: () {
                                      if (!ref.read(authProvider).isUserLoggedIn) {
                                        showCustomSnackBar('Login to access video', type: false);
                                        context.go(RoutePath.signIn);
                                        return;
                                      }
                                      if (_videoDetail == null) {
                                        setState(() {
                                          _videoDetail = DIModel(
                                            imgUrl: model.videoUrl!,
                                            // imgUrl: model.thumbnailImage ?? '',
                                            duration: model.duration ?? '',
                                            title: model.title ?? '',
                                            category: widget.categoryListResponse.title ?? '', videoId: model.id!,
                                          );
                                        });
                                      }
                                    },
                                    child: DetailItem(
                                      appStyle: _style,
                                      model: model,
                                      index: '$index',
                                      onToggleBookmark: () {
                                        if (model.id == null) return;
                                        ref.read(bookmarkProvider).toggleBookmark(model.id!);
                                      },
                                    ),
                                  );
                                },
                                separatorBuilder: (BuildContext context, int index) => SizedBox(
                                  height: _style.scaleX(25),
                                ),
                              ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class IntroWidget extends StatelessWidget {
  final String title;
  final String description;
  final AppStyle style;

  const IntroWidget({
    super.key,
    required this.title,
    required this.description,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: style.scaleX(15)),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Spacer(flex: 3),
          Text(
            title,
            style: style.text.font(
              brandonMedium500,
              sizePx: 30,
              color: AppColors.primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: style.scaleX(25)),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}
