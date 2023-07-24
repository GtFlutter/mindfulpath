import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meditation_app/theme/colors.dart';
import 'package:meditation_app/util/assets.dart';

import '../../../theme/styles.dart';
import '../../../theme/text_style.dart';
import '../../common/background_image.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  static AppStyle _style = AppStyle();
  final List<String> items = [
    'Nutrition',
    'Meditation',
    'Cancer preventation',
    'Diet',
    'Boosting your Immunity',
    'Nutrition1',
    'Meditation1',
    'Cancer preventation1',
    'Diet1',
    'Boosting your Immunity1',
    'Nutrition2',
    'Meditation2',
    'Cancer preventation2',
    'Diet',
    'Boosting your Immunity2',
    'Nutrition3',
    'Meditation3',
    'Cancer preventation3',
    'Diet3',
    'Boosting your Immunity3',
  ];
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _style = AppStyle(screenSize: size);
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        title: const Text('Analytics'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        titleTextStyle: _style.text.font(mulishSemiBold600, sizePx: 15, color: Colors.white),
      ),
      // appBar:
      //  CustomAppBar(
      //   screenSize: size,
      //   style: _style,
      //   title: 'Analytics',
      // ),
      body: BackgroundImage(
        alignment: Alignment.topCenter,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: _style.scaleX(20)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: CustomDropDownButton(
                        value: selectedValue,
                        mainAxisAlignment: MainAxisAlignment.start,
                        appStyle: _style,
                        items: items,
                        maxHeight: size.height * 0.6,
                        width: size.shortestSide * 0.5,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: CustomDropDownButton(
                        value: selectedValue,
                        mainAxisAlignment: MainAxisAlignment.center,
                        appStyle: _style,
                        items: items,
                        maxHeight: size.height * 0.6,
                        width: size.shortestSide * 0.5,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: CustomDropDownButton(
                        value: selectedValue,
                        appStyle: _style,
                        items: items,
                        mainAxisAlignment: MainAxisAlignment.end,
                        width: size.shortestSide * 0.5,
                        maxHeight: size.height * 0.6,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                // DropdownButtonHideUnderline(
                //   child: DropdownButton2<String>(
                //     isExpanded: true,
                //     customButton: Row(
                //       children: [
                //         Text(
                //           selectedValue ?? 'Category',
                //           style: _style.text.font(mulishMedium500, sizePx: 12.5, color: Colors.white),
                //         ),
                //         SizedBox(width: _style.scaleX(5)),
                //         SvgPicture.asset(
                //           SvgPaths.arrowDown,
                //           width: _style.scaleX(17.5),
                //           fit: BoxFit.fitWidth,
                //           color: AppColors.primaryColor,
                //         ),
                //       ],
                //     ),
                //     items: items
                //         .map((String item) => DropdownMenuItem<String>(
                //               value: item,
                //               child: Text(
                //                 item,
                //                 style: _style.text.font(mulishMedium500, sizePx: 10, color: Colors.white),
                //                 maxLines: 2,
                //                 overflow: TextOverflow.ellipsis,
                //               ),
                //             ))
                //         .toList(),
                //     value: selectedValue,
                //     onChanged: (String? value) {
                //       setState(() {
                //         selectedValue = value;
                //       });
                //     },
                //     dropdownStyleData: DropdownStyleData(
                //       maxHeight: size.height * 0.6,
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(_style.scaleX(10)),
                //         color: Color(0xFF2D251F),
                //       ),
                //       scrollbarTheme: ScrollbarThemeData(
                //         radius: const Radius.circular(40),
                //         thickness: MaterialStateProperty.all(6),
                //         thumbVisibility: MaterialStateProperty.all(true),
                //       ),
                //     ),
                //     buttonStyleData: const ButtonStyleData(
                //       padding: EdgeInsets.symmetric(horizontal: 16),
                //       height: 40,
                //       width: 140,
                //     ),
                //     menuItemStyleData: const MenuItemStyleData(
                //       height: 40,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomDropDownButton extends StatelessWidget {
  final List<String> items;
  final String? value;
  final AppStyle appStyle;
  final ValueChanged<String?>? onChanged;
  final double maxHeight;
  final double? width;
  final MainAxisAlignment mainAxisAlignment;

  const CustomDropDownButton({
    super.key,
    required this.value,
    required this.appStyle,
    required this.items,
    this.onChanged,
    required this.maxHeight,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        customButton: Row(
          mainAxisAlignment: mainAxisAlignment,
          children: [
            Flexible(
              child: Text(
                value ?? 'Category',
                style: appStyle.text.font(mulishMedium500, sizePx: 12.5, color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: appStyle.scaleX(5)),
            SvgPicture.asset(
              SvgPaths.arrowDown,
              width: appStyle.scaleX(17.5),
              fit: BoxFit.fitWidth,
              color: AppColors.primaryColor,
            ),
          ],
        ),
        items: items
            .map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: appStyle.text.font(mulishMedium500, sizePx: 12.5, color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        value: value,
        onChanged: onChanged,
        dropdownStyleData: DropdownStyleData(
          maxHeight: maxHeight,
          width: width,
          // maxHeight: size.height * 0.6,
          offset: Offset(0, -appStyle.scaleX(10)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(appStyle.scaleX(10)),
            color: const Color(0xFF2D251F),
            boxShadow: const [
              BoxShadow(
                color: Color(0x47000000),
                blurRadius: 14,
                offset: Offset(4, 6),
                spreadRadius: 0,
              )
            ],
          ),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: MaterialStateProperty.all(6),
            thumbVisibility: MaterialStateProperty.all(true),
          ),
        ),
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.symmetric(horizontal: 16),
          height: 40,
          width: 140,
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
        ),
      ),
    );
  }
}
