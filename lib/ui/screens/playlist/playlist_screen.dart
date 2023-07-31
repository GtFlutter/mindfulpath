import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/theme/text_style.dart';
import 'package:meditation_app/ui/screens/playlist/widget/playlist_item.dart';
import 'package:meditation_app/util/assets.dart';

import '../../../helper/route/route_paths.dart';
import '../../../theme/styles.dart';
import '../courses/courses_list_screen.dart';

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
                onTap: () {
                  context.go(RoutePath.subPlaylistScreenPath, extra: list[index]);
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
