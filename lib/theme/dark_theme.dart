import 'package:flutter/material.dart';
import 'package:meditation_app/theme/app_styles.dart';
import 'package:meditation_app/theme/text_style.dart';
import '../util/app_colors.dart';

Color _color = AppColors.primaryColor;

ThemeData darkTheme = ThemeData(
  fontFamily: 'Mulish',
  primaryColor: _color,
  // secondaryHeaderColor: const Color(0xFF000743),
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: _color,
    // secondary: _color,
    // error: const Color(0xFFE84D4F),
  ),
  // disabledColor: const Color(0xFFA0A4A8),
  // hintColor: const Color(0xFF9F9F9F),
  // cardColor: Colors.white,
  // textButtonTheme: TextButtonThemeData(
  //   style: TextButton.styleFrom(foregroundColor: _color),
  // ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    // iconTheme: IconThemeData(color: AppColors.secondaryClr),
    elevation: 0,
    titleTextStyle: mulishMedium500.copyWith(fontSize: AppStyle().common.size(22.5)),
    toolbarHeight: kToolbarHeight + AppStyle().common.size(28.5),
  ),
  // scaffoldBackgroundColor: Colors.white,
);
