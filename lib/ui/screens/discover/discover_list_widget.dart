import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/data/model/response/category_list_reponse.dart';
import 'package:meditation_app/helper/route/route_paths.dart';
import 'package:meditation_app/theme/styles.dart';
import 'package:meditation_app/ui/screens/discover/widget/discover_item.dart';

class DiscoverLayout extends StatelessWidget {
  final List<CategoryListResponse> categoryListResponse;
  final AppStyle style;
  const DiscoverLayout({super.key, required this.style, required this.categoryListResponse});

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
      itemCount: categoryListResponse.length,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: style.scale * 22),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return DiscoverItem(
          item: categoryListResponse[index],
          style: style,
          onPressed: () {
            context.go(RoutePath.detailCategoryScreenPath, extra: categoryListResponse[index]);
          },
        );
      },
    );
  }
}
