import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/helper/navigation.dart';
import 'package:meditation_app/helper/route/route_paths.dart';
import 'package:meditation_app/provider/course_provider.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/ui/common/custom_app_bar.dart';

import '../../../theme/styles.dart';
import 'widget/course_item.dart';

List<CITempModel> list = [
  CITempModel(
    'Anticancer Foods and Their Benefits',
    'https://images.pexels.com/photos/1640770/pexels-photo-1640770.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
  ),
  CITempModel(
    'Exercise and Mental Well-being',
    'https://images.pexels.com/photos/7353048/pexels-photo-7353048.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
  ),
  CITempModel(
    'Transcendental Meditation ',
    'https://images.pexels.com/photos/1034940/pexels-photo-1034940.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
  ),
  CITempModel(
    'Creating a Personalized Cancer Prevention Plan',
    'https://images.pexels.com/photos/4058411/pexels-photo-4058411.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
  ),
  CITempModel(
    'Understanding Meditation',
    'https://images.pexels.com/photos/5807630/pexels-photo-5807630.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
  ),
];

class CoursesListScreen extends ConsumerStatefulWidget {
  final String title;
  final bool isAudio;

  const CoursesListScreen({super.key, required this.title, required this.isAudio});

  @override
  ConsumerState<CoursesListScreen> createState() => _CoursesListScreenState();
}

class _CoursesListScreenState extends ConsumerState<CoursesListScreen> {
  static AppStyle _style = AppStyle();

  @override
  void initState() {
    final courseP = ref.read(courseProvider);

    print("========${widget.title}");
    if (isPurchased) {
      Future.delayed(Duration.zero, () {
        courseP.getPurchasedList();
      });
      // } else if (widget.title == ScreenTitles.currentlyProgress.value) {
    } else if (widget.title == "Currently Progress") {
      Future.delayed(Duration.zero, () {
        courseP.getCurrentlyProgressList();
      });
    } else if (widget.isAudio) {
      Future.delayed(
        Duration.zero,
        () {
          courseP.getAudioCategoryFromDatabase();
        },
      );
    } else {
      Future.delayed(
        Duration.zero,
        () {
          courseP.getCategoryFromDatabase();
        },
      );
    }

    super.initState();
  }

  // bool get isPurchased => widget.title == ScreenTitles.purchased.value;
  bool get isPurchased => widget.title == "Purchased";

  // bool get isCurrentlyProgress => widget.title == ScreenTitles.currentlyProgress.value;
  bool get isCurrentlyProgress => widget.title == "Currently Progress";

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _style = AppStyle(screenSize: size);
    const double ratio = 30;
    double maxWidth = _style.scaleX(16 * ratio);
    double maxHeight = _style.scaleX(8.2 * ratio);
    print('--downloadVideoResponse.length---${ref.read(courseProvider).downloadVideoResponse.length}');
    print('--downloadAudioResponse.length---${ref.read(courseProvider).downloadAudioResponse.length}');
    if (ref.watch(courseProvider).pushData == true) {
      Future.delayed(
        Duration.zero,
        () {
          ref.read(courseProvider.notifier).pushData = false;
          Navigator.pop(context);
        },
      );
    }

    final courseP = ref.watch(courseProvider);

    return Scaffold(
      appBar: isPurchased
          ? null
          : CustomAppBar(
              screenSize: size,
              style: _style,
              title: widget.title,
            ),
      extendBodyBehindAppBar: true,
      body: BackgroundImage(
        child: SafeArea(
          bottom: false,
          child: courseP.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    mainAxisSpacing: _style.scale * 25,
                    crossAxisSpacing: _style.scale * 25,
                    maxCrossAxisExtent: maxWidth,
                    childAspectRatio: maxWidth / maxHeight,
                  ),
                  itemCount: isPurchased
                      ? courseP.purchasedVideoResponse.length
                      : isCurrentlyProgress
                          ? courseP.cpVideoResponse.length
                          : widget.isAudio
                              ? courseP.downloadAudioCategoryResponse.length
                              : courseP.downloadResponse.length,
                  padding: EdgeInsets.fromLTRB(_style.scale * 25, _style.scaleX(20), _style.scale * 25, _style.scaleX(100)),
                  itemBuilder: (context, index) {
                    CITempModel item;
                    if (isPurchased) {
                      item = CITempModel(courseP.purchasedVideoResponse[index].title ?? '', courseP.purchasedVideoResponse[index].categoryResponse!.imageResponse!.imageUrl ?? '');
                    } else if (isCurrentlyProgress) {
                      item = CITempModel(courseP.cpVideoResponse[index].title ?? '', courseP.cpVideoResponse[index].categoryResponse!.imageResponse!.imageUrl ?? '');
                    } else if (widget.isAudio) {
                      item = CITempModel(courseP.downloadAudioCategoryResponse[index].categoryName!, courseP.downloadAudioCategoryResponse[index].categoryImage!);
                    } else {
                      item = CITempModel(courseP.downloadResponse[index].categoryName!, courseP.downloadResponse[index].categoryImage!);
                    }
                    return CourseItem(
                      model: item,
                      style: _style,
                      onPressed: () {
                        if (isPurchased) {
                          context.goToDetailCategoryScreen(courseP.purchasedVideoResponse[index].categoryResponse!, isAudio: false);
                        } else if (isCurrentlyProgress) {
                          context.goToDetailCategoryScreen(courseP.cpVideoResponse[index].categoryResponse!, isAudio: false);
                        } else if (widget.isAudio) {
                          context.push(RoutePath.downloadDetailCategoryScreenPath, extra: (courseP.downloadAudioCategoryResponse[index], true));
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => DetailCategoryScreen(categoryListResponse: , isAudio: widget.isAudio ? true : false)));
                        } else {
                          context.push(RoutePath.downloadDetailCategoryScreenPath, extra: (courseP.downloadResponse[index], false));
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => DetailCategoryScreen(categoryListResponse: , isAudio: widget.isAudio ? true : false)));
                        }
                      },
                    );
                  },
                ),
        ),
      ),
    );
  }
}
