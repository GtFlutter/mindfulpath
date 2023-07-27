import 'package:flutter/material.dart';
import 'package:meditation_app/ui/common/background_image.dart';
import 'package:meditation_app/ui/common/custom_app_bar.dart';

import '../../../theme/styles.dart';
import 'widget/course_item.dart';

List<CITempModel> list = [
  CITempModel(
    'Anticancer Foods and Their Benefits',
    '10 Day Course',
    'https://images.pexels.com/photos/1640770/pexels-photo-1640770.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
  ),
  CITempModel(
    'Exercise and Mental Well-being',
    '22 Day Course',
    'https://images.pexels.com/photos/7353048/pexels-photo-7353048.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
  ),
  CITempModel(
    'Transcendental Meditation ',
    '18 Day Course',
    'https://images.pexels.com/photos/1034940/pexels-photo-1034940.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
  ),
  CITempModel(
    'Creating a Personalized Cancer Prevention Plan',
    '25 Day Course',
    'https://images.pexels.com/photos/4058411/pexels-photo-4058411.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
  ),
  CITempModel(
    'Understanding Meditation',
    '26 Day Course',
    'https://images.pexels.com/photos/5807630/pexels-photo-5807630.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
  ),
];

class CoursesListScreen extends StatefulWidget {
  final String title;
  const CoursesListScreen({super.key, required this.title});

  @override
  State<CoursesListScreen> createState() => _CoursesListScreenState();
}

class _CoursesListScreenState extends State<CoursesListScreen> {
  static AppStyle _style = AppStyle();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _style = AppStyle(screenSize: size);
    const double ratio = 30;
    double maxWidth = _style.scaleX(16 * ratio);
    double maxHeight = _style.scaleX(8.2 * ratio);
    return Scaffold(
      appBar: CustomAppBar(
        screenSize: size,
        style: _style,
        title: widget.title,
      ),
      extendBodyBehindAppBar: true,
      body: BackgroundImage(
        child: SafeArea(
          bottom: false,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              mainAxisSpacing: _style.scale * 25,
              crossAxisSpacing: _style.scale * 25,
              maxCrossAxisExtent: maxWidth,
              childAspectRatio: maxWidth / maxHeight,
            ),
            itemCount: list.length,
            padding: EdgeInsets.fromLTRB(_style.scale * 25, _style.scaleX(20), _style.scale * 25, _style.scaleX(100)),
            itemBuilder: (context, index) {
              return CourseItem(
                model: list[index],
                style: _style,
                onPressed: () {},
              );
            },
          ),
        ),
      ),
    );
  }
}
