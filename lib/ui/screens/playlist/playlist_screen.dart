import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meditation_app/theme/text_style.dart';
import 'package:meditation_app/util/assets.dart';

import '../../../theme/styles.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  List<String> list = [
    'Healing Meditations',
    'Nutrition and Cancer',
    'Mindful Meditations',
    'Cancer Survivorship',
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
            horizontal: _style.scaleX(42),
            vertical: _style.scaleX(20),
          ),
          physics: const AlwaysScrollableScrollPhysics(),
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: (context, index) {
              return PlaylistItem(
                title: list[index],
                style: _style,
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

class PlaylistItem extends StatelessWidget {
  final String title;
  final AppStyle style;
  const PlaylistItem({super.key, required this.title, required this.style});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(style.scaleX(40)),
      color: const Color(0xFFD9D9D9).withOpacity(0.1),
      child: InkWell(
        borderRadius: BorderRadius.circular(style.scaleX(40)),
        splashFactory: InkSplash.splashFactory,
        splashColor: Colors.white.withOpacity(0.2),
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: style.scaleX(20), vertical: style.scaleX(6)),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: style.text.font(mulishMedium500, sizePx: 15),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: style.scaleX(15)),
              SvgPicture.asset(
                SvgPaths.arrowRight,
                height: style.scaleX(17.5),
                fit: BoxFit.contain,
              ),
              SizedBox(width: style.scaleX(15)),
              SvgPicture.asset(
                SvgPaths.bgShape,
                fit: BoxFit.contain,
                height: style.scaleX(37.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
