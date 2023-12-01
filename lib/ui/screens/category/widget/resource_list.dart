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
import '../../../common/custom_dropdown_button.dart';
import 'custom_selecteable_button.dart';
import 'detail_item.dart';

/// TODO ::: Working On It
class ResourceDetailCategory extends StatefulWidget {
  final int categoryId;
  final String categoryTitle;

  const ResourceDetailCategory({super.key, required this.categoryId, required this.categoryTitle});

  @override
  State<ResourceDetailCategory> createState() => _ResourceListState();
}

class _ResourceListState extends State<ResourceDetailCategory> with TickerProviderStateMixin {
  late TabController _tabController;
  final List<ItemName> _filters = [ItemName(id: 0, title: 'Video'), ItemName(id: 1, title: 'PDF')];

  static AppStyle _style = AppStyle();

  /// Either 0 = [Video] or 1 = [PDF]
  late int filterIndex;

  /// Either 0 = [Free] or 1 = [Paid]
  late int courseIndex;

  @override
  void initState() {
    super.initState();
    filterIndex = 0;
    courseIndex = 0;
    _tabController = TabController(
      initialIndex: courseIndex,
      length: 4,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _changeTab(int filterIndex, int courseTypeIndex) {
    int currentTabIndex = _tabController.index;
    late int animateTo;
    if (filterIndex == 0 && courseTypeIndex == 0) {
      animateTo = 0;
    } else if (filterIndex == 0 && courseTypeIndex == 1) {
      animateTo = 1;
    } else if (filterIndex == 1 && courseTypeIndex == 0) {
      animateTo = 2;
    } else if (filterIndex == 1 && courseTypeIndex == 1) {
      animateTo = 3;
    } else {
      animateTo = throw ArgumentError();
    }
    if (currentTabIndex == animateTo) return;
    _tabController.animateTo(animateTo);
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
              onTap: () => _changeCourseType(1),
            ),
            const Spacer(),
            Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_style.scaleX(40)),
                  side: const BorderSide(color: AppColors.primaryColor, width: 0.5),
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
            children: const [
              DemoWIdget1(title: 'Free Videos'),
              // VideoListWidget(
              //   key: const ValueKey<String>('videolisting'),
              //   widget.style,
              //   resourceCtrl,
              //   categoryTitle: widget.categoryTitle,
              // ),
              DemoWIdget1(title: 'Paid Videos'),
              DemoWIdget1(title: 'Free PDF'),
              DemoWIdget1(title: 'Paid PDF'),
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

class VideoListWidget extends ConsumerStatefulWidget {
  final int categoryId;
  final String categoryTitle;

  const VideoListWidget({
    super.key,
    required this.categoryTitle,
    required this.categoryId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VideoListWidgetState();
}

class _VideoListWidgetState extends ConsumerState<VideoListWidget> with AutomaticKeepAliveClientMixin {
  final ScrollController _controller = ScrollController();
  static AppStyle _style = AppStyle();

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
    _style = AppStyle(screenSize: MediaQuery.sizeOf(context));
    var provider = ref.watch(videoResourceProvider);

    // TODO :::
    if (provider.isFreeVideoLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // TODO :::::
    if (provider.freeVideosResponse == null || provider.freeVideosResponse!.list == null) {
      return const Center(child: Text('Unable to find data!'));
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: _controller,
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.only(
        bottom: _style.scale * 100,
        top: _style.scale * 10,
      ),
      itemCount: provider.freeVideosResponse!.list!.length,
      itemBuilder: (context, index) {
        var model = provider.freeVideosResponse!.list![index];
        return GestureDetector(
          onTap: () => playVideo(model),
          child: DetailItem(
            appStyle: _style,
            model: model,
            index: '$index',
            onToggleBookmark: () => toggleItemBookmark(model.id),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => SizedBox(height: _style.scaleX(25)),
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
