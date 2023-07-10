import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/helper/screen_paths.dart';
import 'package:meditation_app/theme/styles.dart';
import 'package:meditation_app/ui/screens/discover/widget/discover_item.dart';

List<DBTempModel> list = [
  DBTempModel(
    'Mindful',
    'Moments',
    'https://images.pexels.com/photos/4151865/pexels-photo-4151865.jpeg?auto=compress&cs=tinysrgb&w=1920&h=1280&dpr=1',
    'Meditation',
  ),
  DBTempModel(
    'Ketogenic',
    'Diet',
    'https://images.pexels.com/photos/6740518/pexels-photo-6740518.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'Diet',
  ),
  DBTempModel(
    'Therapeutic ',
    'Nutrition',
    'https://images.pexels.com/photos/1034940/pexels-photo-1034940.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'Nutrition',
  ),
  DBTempModel(
    'Flexibility',
    'Training',
    'https://images.pexels.com/photos/841128/pexels-photo-841128.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'Exercise',
  ),
  DBTempModel(
    'Lifestyle',
    'Changes',
    'https://images.pexels.com/photos/4553618/pexels-photo-4553618.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'Cancer prevention',
  ),
];

class DiscoverLayout extends StatelessWidget {
  final AppStyle style;
  const DiscoverLayout({super.key, required this.style});

  @override
  Widget build(BuildContext context) {
    const double ratio = 30;
    double maxWidth = style.scaleX(16 * ratio);
    double maxHeight = style.scaleX(9 * ratio);

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        mainAxisSpacing: style.scale * 25,
        crossAxisSpacing: style.scale * 25,
        maxCrossAxisExtent: maxWidth,
        childAspectRatio: maxWidth / maxHeight,
      ),
      itemCount: list.length,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: style.scale * 22),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return DiscoverItem(
          model: list[index],
          style: style,
          onPressed: () {
            context.go(ScreenPaths.detailScreenPath);
          },
        );
      },
    );
  }
}
