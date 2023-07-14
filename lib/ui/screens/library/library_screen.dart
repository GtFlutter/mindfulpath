// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:meditation_app/theme/colors.dart';
import 'package:meditation_app/theme/styles.dart';
import 'package:meditation_app/theme/text_style.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/ui/screens/bookmark/bookmark_screen.dart';
import 'package:meditation_app/ui/screens/courses/courses_screen.dart';
import 'package:meditation_app/ui/screens/playlist/playlist_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> with TickerProviderStateMixin {
  static AppStyle _style = AppStyle();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _style = AppStyle(screenSize: size);
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TabBar(
              controller: _tabController,
              isScrollable: true,
              dividerColor: Colors.transparent,
              indicatorPadding: EdgeInsets.symmetric(vertical: _style.scaleX(9)),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.white,
              indicator: ShapeDecoration(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                color: AppColors.primaryColor,
              ),
              labelStyle: _style.text.font(mulishRegular400, sizePx: 12.5),
              indicatorSize: TabBarIndicatorSize.label,
              overlayColor: MaterialStatePropertyAll(Colors.transparent),
              tabs: [
                Tab(child: CustomTab(text: 'Bookmark', style: _style)),
                Tab(child: CustomTab(text: 'Playlist', style: _style)),
                Tab(child: CustomTab(text: 'Courses', style: _style)),
              ],
            ),
          ],
        ),
      ),
      body: BackgroundImage(
        child: TabBarView(
          physics: BouncingScrollPhysics(),
          controller: _tabController,
          children: const [
            BookmarkScreen(),
            PlaylistScreen(),
            CoursesScreen(),
          ],
        ),
      ),
    );
  }
}

class CustomTab extends StatelessWidget {
  final AppStyle style;
  final String text;
  const CustomTab({
    super.key,
    required this.text,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(style.scaleX(40)),
          side: BorderSide(color: AppColors.primaryColor),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: style.scaleX(12.5),
        vertical: style.scaleX(5),
      ),
      child: Text(text),
    );
  }
}
