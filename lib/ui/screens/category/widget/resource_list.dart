import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/data/model/body/resource_type.dart';
import 'package:meditation_app/provider/resource_provider/resource_provider.dart';
import 'package:meditation_app/theme/styles.dart';
import 'package:meditation_app/ui/screens/analytics/data/model/response/category_and_video_name_model.dart';
import 'package:meditation_app/util/dimensions.dart';

import '../../../../data/model/response/videos_response.dart';
import '../../../../provider/bookmark_provider.dart';
import '../../../../provider/video_provider.dart';
import '../../../../theme/colors.dart';
import '../../../../theme/text_style.dart';
import '../../../common/custom_dropdown_button.dart';
import '../../../common/custom_tab.dart';
import 'detail_item.dart';

/// TODO ::: Working On It

class ResourceDetailCategory extends ConsumerStatefulWidget {
  final AppStyle style;
  final String categoryTitle;

  const ResourceDetailCategory({
    super.key,
    required this.style,
    required this.categoryTitle,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResourceListState();
}

class _ResourceListState extends ConsumerState<ResourceDetailCategory> with TickerProviderStateMixin {
  late TabController _tabController;
  late ResourceType _currentCourseType;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    _currentCourseType = ResourceType.free;
    _tabController.addListener(tabListner);
  }

  @override
  void dispose() {
    _tabController.removeListener(tabListner);
    _tabController.dispose();
    super.dispose();
  }

  void tabListner() {
    switch (_tabController.index) {
      case 0:
        setState(() => _currentCourseType = ResourceType.free);
        break;
      case 1:
        setState(() => _currentCourseType = ResourceType.paid);
        break;
      default:
    }
  }

  void _changeFilter(ItemName? value) {
    if (value == null) return;
    ref.read(resourceProvider).chnageFilter(_currentCourseType, CourseFilter.fromInt(value.id));
  }

  @override
  Widget build(BuildContext context) {
    final resourceCtrl = ref.watch(resourceProvider);

    var filterValue = resourceCtrl.filter(_currentCourseType);
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
                  Tab(child: CustomTab(text: 'Paid', style: widget.style)),
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
                value: filterValue,
                appStyle: widget.style,
                items: resourceCtrl.filters,
                width: widget.style.scaleX(120),
                maxHeight: widget.style.scaleX(150),
                onChanged: _changeFilter,
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
              const DemoWIdget1(),
              VideoListWidget(
                key: const ValueKey<String>('videolisting'),
                widget.style,
                resourceCtrl,
                categoryTitle: widget.categoryTitle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DemoWIdget1 extends StatefulWidget {
  const DemoWIdget1({super.key});

  @override
  State<DemoWIdget1> createState() => _DemoWIdget1State();
}

class _DemoWIdget1State extends State<DemoWIdget1> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const SizedBox.expand(
      child: Center(
        child: Text('Free'),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class VideoListWidget extends ConsumerStatefulWidget {
  final String categoryTitle;
  final AppStyle style;
  final ResourceNotifier provider;

  const VideoListWidget(this.style, this.provider, {super.key, required this.categoryTitle});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VideoListWidgetState();
}

class _VideoListWidgetState extends ConsumerState<VideoListWidget> with AutomaticKeepAliveClientMixin {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    debugPrint('initState: VideoListWidget');
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // TODO :::
    if (widget.provider.isVideoLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // TODO :::::
    if (widget.provider.videosResponse == null || widget.provider.videosResponse!.list == null) {
      return const Center(child: Text('Unable to find data!'));
    }

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
          onTap: () => playVideo(model),
          child: DetailItem(
            appStyle: widget.style,
            model: model,
            index: '$index',
            onToggleBookmark: () => toggleItemBookmark(model.id),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => SizedBox(height: widget.style.scaleX(25)),
    );
  }

  void toggleItemBookmark(int? itemId) {
    if (itemId == null) return;
    ref.read(bookmarkProvider).toggleBookmark(itemId);
  }

  void playVideo(VideoResponse model) {
    ref.read(videoProvider).playVideo(
          DIModel(
            // imgUrl: model.thumbnailImage ?? '',
            imgUrl: model.videoUrl!,
            duration: model.duration ?? '',
            title: model.title ?? '',
            category: widget.categoryTitle,
            videoId: model.id!,
            videoType: model.videoType ?? ResourceType.paid,
          ),
        );
  }

  @override
  bool get wantKeepAlive => true;
}
