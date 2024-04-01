import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/provider/bookmark_provider.dart';
import 'package:meditation_app/provider/playlist_provider.dart';
import 'package:meditation_app/provider/video_provider.dart';
import 'package:meditation_app/ui/screens/playlist/sub_playlist_screen.dart';
import 'package:meditation_app/ui/screens/playlist/widget/create_playlist_dialog.dart';
import 'package:meditation_app/ui/screens/playlist/widget/playlist_item.dart';

import '../../../theme/styles.dart';

class PlaylistScreen extends ConsumerStatefulWidget {
  const PlaylistScreen({super.key});

  @override
  ConsumerState<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends ConsumerState<PlaylistScreen> {
  static AppStyle _style = AppStyle();

  @override
  void initState() {
    final playlistProvider = ref.read(playListProvider);
    Future.delayed(Duration.zero, () {
      playlistProvider.getPlaylistList(showProgress: true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _style = AppStyle(screenSize: size);
    _style = AppStyle(screenSize: size);
    bool isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;


    final playlistProvider = ref.watch(playListProvider);

    return SafeArea(
      bottom: false,
      child: playlistProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
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
                    if (playlistProvider.playlistListResponse == null ||
                        playlistProvider.playlistListResponse!.isEmpty) ...[
                      const SizedBox.shrink()
                    ] else ...[
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount:
                            playlistProvider.playlistListResponse!.length,
                        itemBuilder: (context, index) {
                          return PlaylistItem(
                            title: playlistProvider
                                    .playlistListResponse![index].title ??
                                '',
                            style: _style,
                            onTap: () {
                              //SubPlayListScreenData data = SubPlayListScreenData(id: playlistProvider.playlistListResponse![index].id!.toInt(), title: playlistProvider.playlistListResponse![index].title);
                              //context.go(RoutePath.subPlaylistScreenPath, extra: playlistProvider.playlistListResponse?[index].id??0,title: playlistProvider.playlistListResponse![index].title);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SubPlayListScreen(
                                          id: playlistProvider.playlistListResponse?[index].id as int,
                                          title: playlistProvider
                                              .playlistListResponse![index]
                                              .title??"")));
                            },
                            onDelete: () {
                              playlistProvider.deletePlaylist(playlistProvider
                                  .playlistListResponse![index].id!
                                  .toString());
                            },
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            SizedBox(height: _style.scaleX(25)),
                      )
                    ],
                  ],
                ),
              ),
            ),
    );
  }

  void createPlaylist() {
    showDialog(
      context: context,
      // barrierDismissible: false,
      builder: (c) {
        return ProviderScope(
          parent: ProviderScope.containerOf(context, listen: false),
          child: Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_style.scaleX(10))),
            child: CreatePlaylistDialog(_style),
          ),
        );
      },
    );
  }
}
