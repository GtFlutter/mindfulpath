// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meditation_app/theme/styles.dart';
import 'package:meditation_app/theme/text_style.dart';
import 'package:meditation_app/ui/common/background_image.dart';

import '../../../util/assets.dart';
import '../category/temp_data_file.dart';
import '../category/widget/detail_item.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  static AppStyle _style = AppStyle();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _style = AppStyle(screenSize: size);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BackgroundImage(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: _style.scaleX(20),
                  vertical: _style.scaleX(10),
                ),
                child: SearchBar(
                  focusNode: _focusNode,
                  controller: _controller,
                  onTap: () {
                    if (!_focusNode.hasFocus) {
                      _focusNode.requestFocus();
                    }
                  },
                  onChanged: (value) {},
                  leading: SvgPicture.asset(
                    SvgPaths.search,
                    height: _style.scale * 20,
                    fit: BoxFit.contain,
                    color: Colors.white,
                  ),
                  constraints: BoxConstraints(
                    maxHeight: _style.scaleX(40),
                  ),
                  hintText: 'Hinted search text',
                  hintStyle: MaterialStateProperty.all(
                    _style.text.font(mulishMedium500, sizePx: 10, color: Colors.white.withOpacity(0.5)),
                  ),
                  textStyle: MaterialStateProperty.all(
                    _style.text.font(mulishMedium500, sizePx: 11, color: Colors.white, spacingPc: 10),
                  ),
                  elevation: MaterialStateProperty.all(2),
                  shadowColor: MaterialStateProperty.all(Color(0xFF2D251F).withOpacity(0.2)),
                  backgroundColor: MaterialStateProperty.all(Color(0xFF2D251F)),
                  shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(_style.scaleX(22.5)))),
                  padding: MaterialStateProperty.all(
                    EdgeInsets.only(
                      left: _style.scaleX(15),
                      right: _style.scaleX(15),
                      bottom: _style.scaleX(3),
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.only(
                  bottom: _style.scale * 100,
                  top: _style.scale * 20,
                  left: _style.scaleX(20),
                  right: _style.scaleX(20),
                ),
                itemCount: TempData.listDiModel.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {},
                    child: DetailItem(
                      appStyle: _style,
                      model: TempData.listDiModel[index],
                      index: '$index',
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => SizedBox(
                  height: _style.scaleX(25),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
