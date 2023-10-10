import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:meditation_app/data/model/response/bookmark_list_response.dart';
import 'package:meditation_app/theme/colors.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/ui/common/custom_app_bar.dart';

import '../../../theme/styles.dart';
import '../bookmark/widget/bookmark_item.dart';
import '../category/temp_data_file.dart';
import '../category/widget/detail_item.dart';

class SubPlayListScreenData {
  int? id;
  String? title;

  SubPlayListScreenData({this.id, this.title});
}


class SubPlayListScreen extends StatefulWidget {
  final SubPlayListScreenData data;
  const SubPlayListScreen({super.key, required this.data});

  @override
  State<SubPlayListScreen> createState() => _SubPlayListScreenState();
}

class _SubPlayListScreenState extends State<SubPlayListScreen> {
  static AppStyle _style = AppStyle();
  late List<DIModel> _items;
  @override
  void initState() {
    _items = [];
    _items.addAll(TempData.listDiModel);
    super.initState();
  }

  Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
    const Color draggableItemColor = AppColors.primaryColor;

    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double elevation = lerpDouble(0, 6, animValue)!;

        return Padding(
          padding: EdgeInsets.only(bottom: _style.scaleX(12.5), top: _style.scaleX(12.5)),
          child: Material(
            elevation: elevation,
            color: draggableItemColor,
            shadowColor: draggableItemColor,
            borderRadius: BorderRadius.circular(_style.scaleX(25)),
            child: BookmarkItem.dragable(
              appStyle: _style,
              model: BookmarkListResponse(),
              index: '$index',
              dragging: true,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _style = AppStyle(screenSize: size);

    return Scaffold(
      appBar: CustomAppBar(
        screenSize: size,
        style: _style,
        title: widget.data.title ?? '',
      ),
      extendBodyBehindAppBar: true,
      body: BackgroundImage(
        child: SafeArea(
          bottom: false,
          child: ReorderableListView.builder(
            proxyDecorator: proxyDecorator,
            physics: const AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.only(
              bottom: _style.scale * 100,
              top: _style.scale * 12.5,
              right: _style.scale * 22,
              left: _style.scale * 22,
            ),
            itemCount: _items.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                key: Key('$index'),
                onTap: () {},
                child: BookmarkItem.dragable(
                  appStyle: _style,
                  model: BookmarkListResponse(),
                  index: '$index',
                ),
              );
            },
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final DIModel item = _items.removeAt(oldIndex);
                _items.insert(newIndex, item);
              });
            },
            // separatorBuilder: (BuildContext context, int index) => SizedBox(height: _style.scaleX(25)),
          ),
        ),
      ),
    );
  }
}
