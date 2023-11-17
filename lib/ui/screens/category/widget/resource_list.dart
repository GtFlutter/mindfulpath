import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/data/model/body/resource_type.dart';
import 'package:meditation_app/theme/styles.dart';
import 'package:meditation_app/ui/screens/analytics/data/model/response/category_and_video_name_model.dart';
import 'package:meditation_app/util/dimensions.dart';

import '../../../../data/model/response/videos_response.dart';
import '../../../../helper/route/route_paths.dart';
import '../../../../provider/auth_provider.dart';
import '../../../../provider/bookmark_provider.dart';
import '../../../../provider/dashboard_provider.dart';
import '../../../../theme/colors.dart';
import '../../../../theme/text_style.dart';
import '../../../common/custom_dropdown_button.dart';
import '../../../common/custom_snackbar.dart';
import '../../../common/custom_tab.dart';
import 'detail_item.dart';

/// TODO ::: Working On It

class ResourceList extends ConsumerStatefulWidget {
  final AppStyle style;
  final Function(VideoResponse model) playVideo;

  const ResourceList({super.key, required this.style, required this.playVideo});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResourceListState();
}

class _ResourceListState extends ConsumerState<ResourceList> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void toggleItemBookmark(int? itemId) {
    if (itemId == null) return;
    ref.read(bookmarkProvider).toggleBookmark(itemId);
  }

  void playVideoWithAuth(VideoResponse model) {
    if ((model.videoType == null || model.videoType == ResourceType.paid) && !ref.read(authProvider).isUserLoggedIn) {
      showCustomSnackBar('Login to access video', type: false);
      context.go(RoutePath.signIn);
      return;
    }
    widget.playVideo(model);
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(dashboardProvider);

    if (provider.isVideoLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.videosResponse == null || provider.videosResponse!.list == null) {
      return const Center(child: Text('Unable to find data!'));
    }

    var items2 = [ItemName(id: 0, title: 'Video'), ItemName(id: 1, title: 'PDF')];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                indicatorPadding: EdgeInsets.symmetric(vertical: widget.style.scaleX(8)),
                padding: EdgeInsets.zero,
                labelPadding: EdgeInsets.only(right: widget.style.scaleX(Dimensions.PADDING_SIZE_DEFAULT)),
                indicatorWeight: 1,
                labelStyle: widget.style.text.font(mulishRegular400, sizePx: 12.5),
                tabs: [
                  Tab(child: CustomTab(text: 'Free', style: widget.style)),
                  Tab(child: CustomTab(text: '30 Days', style: widget.style)),
                ],
              ),
            ),
            Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(widget.style.scaleX(40)),
                  side: const BorderSide(color: AppColors.primaryColor, width: 0.5),
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: widget.style.scaleX(10),
                vertical: widget.style.scaleX(3.5),
              ),
              child: CustomDropDownButton<ItemName>(
                key: const ValueKey<int>(3),
                value: null,
                appStyle: widget.style,
                items: items2,
                width: widget.style.scaleX(120),
                maxHeight: widget.style.scaleX(150),
                onChanged: (ItemName? value) {},
                // hint: 'PDF',
                hint: 'Filter',
              ),
            ),
          ],
        ),
        SizedBox(height: widget.style.scaleX(Dimensions.PADDING_SIZE_DEFAULT)),
        Expanded(
          child: TabBarView(
            physics: const BouncingScrollPhysics(),
            controller: _tabController,
            children: [
              VideoListWidget(key: const ValueKey<String>('121'), widget.style, provider),
              VideoListWidget(key: const ValueKey<String>('123'), widget.style, provider)
            ],
          ),
        ),
      ],
    );
  }
}

class VideoListWidget extends ConsumerStatefulWidget {
  final AppStyle style;
  final DashboardNotifier provider;

  const VideoListWidget(this.style, this.provider, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VideoListWidgetState();
}

class _VideoListWidgetState extends ConsumerState<VideoListWidget> {
  final ScrollController _controller = ScrollController();
  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: _controller,
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.only(
        bottom: widget.style.scale * 100,
        top: widget.style.scale * 10,
      ),
      itemCount: widget.provider.videosResponse!.list!.length,
      itemBuilder: (context, index) {
        var model = widget.provider.videosResponse!.list![index];
        return GestureDetector(
          /// TODO:::: Working On It
          // onTap: () => playVideoWithAuth(model),
          child: DetailItem(
            appStyle: widget.style,
            model: model,
            index: '$index',

            /// TODO ::::  Working On It
            // onToggleBookmark: () => toggleItemBookmark(model.id!),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => SizedBox(
        height: widget.style.scaleX(25),
      ),
    );
  }
}
