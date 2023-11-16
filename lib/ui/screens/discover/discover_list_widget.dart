import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/helper/route/route_paths.dart';
import 'package:meditation_app/theme/styles.dart';
import 'package:meditation_app/ui/screens/discover/widget/discover_item.dart';
import '../../../provider/dashboard_provider.dart';

class DiscoverLayout extends ConsumerStatefulWidget {
  const DiscoverLayout({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DiscoverLayoutState();
}

class _DiscoverLayoutState extends ConsumerState<DiscoverLayout> {
  static AppStyle _style = AppStyle();

  @override
  void initState() {
    Future.delayed(Duration.zero, ref.read(dashboardProvider).init);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _style = AppStyle(screenSize: size);
    final dashboardNotifier = ref.watch(dashboardProvider);
    if (dashboardNotifier.isLoading || dashboardNotifier.categoryListResponse == null) {
      return SizedBox(
        width: double.infinity,
        height: size.shortestSide,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    const double ratio = 30;
    double maxWidth = _style.scaleX(16 * ratio);
    double maxHeight = _style.scaleX(9 * ratio);

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        mainAxisSpacing: _style.scale * 25,
        crossAxisSpacing: _style.scale * 25,
        maxCrossAxisExtent: maxWidth,
        childAspectRatio: maxWidth / maxHeight,
      ),
      itemCount: dashboardNotifier.categoryListResponse!.length,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: _style.scale * 22),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return DiscoverItem(
          item: dashboardNotifier.categoryListResponse![index],
          style: _style,
          onPressed: () {
            context.go(
              RoutePath.detailCategoryScreenPath,
              extra: dashboardNotifier.categoryListResponse![index],
            );
          },
        );
      },
    );
  }
}
