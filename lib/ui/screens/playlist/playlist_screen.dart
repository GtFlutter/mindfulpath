import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/ui/screens/playlist/widget/create_playlist_dialog.dart';
import 'package:meditation_app/ui/screens/playlist/widget/playlist_item.dart';

import '../../../helper/route/route_paths.dart';
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PlaylistItem.create(
                title: 'Create New Playlist',
                style: _style,
                onTap: () => createPlaylist(),
              ),
              SizedBox(height: _style.scaleX(25)),
              ListView.separated(
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
                separatorBuilder: (BuildContext context, int index) => SizedBox(height: _style.scaleX(25)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void createPlaylist() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) {
        Size size = MediaQuery.of(c).size;
        AppStyle style = AppStyle(screenSize: size);
        return ProviderScope(
          parent: ProviderScope.containerOf(context),
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(style.scaleX(10))),
            child: CreatePlaylistDialog(style),
          ),
        );
      },
    );
  }
}
