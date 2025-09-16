// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/theme/styles.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/ui/screens/bookmark/bookmark_screen.dart';
import 'package:meditation_app/ui/screens/courses/courses_list_screen.dart';
import 'package:meditation_app/ui/screens/courses/courses_screen.dart';
import 'package:meditation_app/ui/screens/playlist/playlist_screen.dart';

import '../../../provider/bookmark_provider.dart';
import '../../../theme/colors.dart';
import '../../../theme/text_style.dart';
import '../../common/custom_tab.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> with TickerProviderStateMixin {
  static AppStyle _style = AppStyle();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;

    _style = AppStyle(screenSize: size);
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: ref.read(bookmarkProvider.notifier).islandScap == true
          ? null
          : AppBar(
              backgroundColor: Colors.transparent,
              flexibleSpace: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TabBar(
                    padding: EdgeInsets.symmetric(horizontal: 2.0),
                    labelPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    controller: _tabController,
                    isScrollable: true,
                    indicatorPadding: EdgeInsets.symmetric(vertical: _style.scaleX(12)),
                    tabAlignment: TabAlignment.center,
                    indicatorWeight: 1,
                    // labelColor: AppColors.primaryThemeColor2,
                    labelStyle: _style.text.font(
                      mulishRegular400,
                      // sizePx: 13.5,
                      sizePx: 11.5,
                      color: AppColors.primaryThemeColor2,
                    ),
                    tabs: [
                      Tab(child: CustomTab.small(text: 'Bookmarked', style: _style)),
                      Tab(child: CustomTab.small(text: 'Playlist', style: _style)),
                      Tab(child: CustomTab.small(text: 'Downloaded', style: _style)),
                      Tab(child: CustomTab.small(text: 'Plus', style: _style)),
                    ],
                  ),
                ],
              ),
            ),
      body: BackgroundImage(
        child: TabBarView(
          physics: BouncingScrollPhysics(),
          controller: _tabController,
          children: const [BookmarkScreen(), PlaylistScreen(), CoursesScreen(), CoursesListScreen(title: "Purchased", isAudio: false)],
        ),
      ),
    );
  }
}
