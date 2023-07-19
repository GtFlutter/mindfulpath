import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/helper/screen_paths.dart';

import '../../../theme/styles.dart';
import '../../../theme/text_style.dart';
import '../../../util/assets.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  List<String> list = [
    'Purchased',
    'Downloaded',
    'Currently Progress',
  ];
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
            itemCount: list.length,
            itemBuilder: (context, index) {
              return CoursesItem(
                title: list[index],
                style: _style,
                onTap: () {
                  context.go(ScreenPaths.coursesListScreenPath, extra: list[index]);
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
                      SvgPaths.arrowRight,
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
