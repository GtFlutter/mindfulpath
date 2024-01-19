import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/helper/route/route_paths.dart';
import 'package:meditation_app/helper/route/router.dart';
import 'package:meditation_app/provider/auth_provider.dart';
import 'package:meditation_app/theme/colors.dart';
import 'package:meditation_app/ui/common/custom_snackbar.dart';
import 'package:meditation_app/ui/screens/analytics/helper/analytics_enums.dart';

import '../../../theme/styles.dart';
import '../../../theme/text_style.dart';
import '../../../util/assets.dart';

class CoursesScreen extends ConsumerStatefulWidget {
  const CoursesScreen({super.key});

  @override
  ConsumerState<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends ConsumerState<CoursesScreen> {

  static AppStyle _style = AppStyle();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _style = AppStyle(screenSize: size);
    return SafeArea(
      bottom: false,
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: _style.scaleX(20),
            vertical: _style.scaleX(20),
          ),
          physics: const AlwaysScrollableScrollPhysics(),
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: ScreenTitles.toList.length,
            itemBuilder: (context, index) {
              return CoursesItem(
                title: ScreenTitles.toList[index].value,
                style: _style,
                onTap: () {
                  debugPrint('Is User Logged In :: ${ref.read(authProvider).isUserLoggedIn}');
                  if (!ref.read(authProvider).isUserLoggedIn) {
                    showCustomSnackBar(
                      'Please log in to bookmark.',
                      action: SnackBarAction(
                        label: 'Log In',
                        backgroundColor: AppColors.primaryColor.withOpacity(0.8),
                        textColor: Colors.brown.shade800,
                        onPressed: () => appRouter.go(RoutePath.signIn),
                      ),
                      duration: const Duration(seconds: 5),
                    );
                    return;
                  }
                  context.go(RoutePath.coursesListScreenPath, extra: ScreenTitles.toList[index].value);
                },
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(height: _style.scaleX(25));
            },
          ),
        ),
      ),
    );
  }
}

class CoursesItem extends StatelessWidget {
  final String title;
  final AppStyle style;
  final GestureTapCallback? onTap;

  const CoursesItem({super.key, required this.title, required this.style, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF2D251F),
      borderRadius: BorderRadius.circular(style.scaleX(25)),
      child: InkWell(
        borderRadius: BorderRadius.circular(style.scaleX(25)),
        splashFactory: InkSplash.splashFactory,
        splashColor: Colors.white.withOpacity(0.2),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: style.scaleX(46), vertical: style.scaleX(24)),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: style.text.font(mulishMedium500, sizePx: 15),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: style.scaleX(10)),
                    SvgPicture.asset(
                      SvgPaths.arrowGoRight,
                      height: style.scaleX(17.5),
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
              SizedBox(width: style.scaleX(15)),
              SvgPicture.asset(
                SvgPaths.bgShape,
                fit: BoxFit.contain,
                height: style.scaleX(50),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
