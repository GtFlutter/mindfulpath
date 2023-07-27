import 'package:flutter/material.dart';
import 'package:meditation_app/ui/screens/bookmark/widget/bookmark_item.dart';

import '../../../theme/styles.dart';
import '../category/temp_data_file.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  static AppStyle _style = AppStyle();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _style = AppStyle(screenSize: size);
    return SafeArea(
      bottom: false,
      child: SizedBox.expand(
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.only(
            bottom: _style.scale * 100,
            top: _style.scale * 12.5,
            right: _style.scale * 22,
            left: _style.scale * 22,
          ),
          itemCount: TempData.listDiModel.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {},
              child: BookmarkItem(
                appStyle: _style,
                model: TempData.listDiModel[index],
                index: '$index',
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) => SizedBox(height: _style.scaleX(25)),
        ),
      ),
    );
  }
}
