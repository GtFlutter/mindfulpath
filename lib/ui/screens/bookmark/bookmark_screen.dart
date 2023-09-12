import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/provider/bookmark_provider.dart';
import 'package:meditation_app/ui/screens/bookmark/widget/bookmark_item.dart';

import '../../../theme/styles.dart';

class BookmarkScreen extends ConsumerStatefulWidget {
  const BookmarkScreen({super.key});

  @override
  ConsumerState<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends ConsumerState<BookmarkScreen> {
  static AppStyle _style = AppStyle();

  @override
  void initState() {
    final bookmarkNotifier = ref.read(bookmarkProvider);
    Future.delayed(Duration.zero, () {
      bookmarkNotifier.getBookmarkList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _style = AppStyle(screenSize: size);
    final bookmarkNotifier = ref.watch(bookmarkProvider);
    return SafeArea(
      bottom: false,
      child: bookmarkNotifier.isLoading ? const Center(child: CircularProgressIndicator(),) : SizedBox.expand(
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.only(
            bottom: _style.scale * 100,
            top: _style.scale * 12.5,
            right: _style.scale * 22,
            left: _style.scale * 22,
          ),
          itemCount: bookmarkNotifier.bookmarkListResponse!.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {},
              child: BookmarkItem(
                appStyle: _style,
                model: bookmarkNotifier.bookmarkListResponse![index],
                index: '$index',
                onBookmarkRemove: () async {
                  if(bookmarkNotifier.bookmarkListResponse![index].videoId == null) return;
                  await ref.read(bookmarkProvider).toggleBookmark(bookmarkNotifier.bookmarkListResponse![index].videoId!, isRemove: true);
                  bookmarkNotifier.bookmarkListResponse!.removeAt(index);
                },
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) => SizedBox(height: _style.scaleX(25)),
        ),
      ),
    );
  }
}
