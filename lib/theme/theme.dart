import 'package:flutter/material.dart';
import 'colors.dart';

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
  useMaterial3: true,
  tabBarTheme: TabBarTheme(
    labelColor: Colors.black,
    unselectedLabelColor: Colors.white,
    indicator: ShapeDecoration(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      color: AppColors.primaryColor,
    ),
    indicatorSize: TabBarIndicatorSize.label,
    overlayColor: const MaterialStatePropertyAll(Colors.transparent),
    //
    dividerColor: Colors.transparent,
    dividerHeight: 0,
  ),

  // disabledColor: const Color(0xFFA0A4A8),
  // hintColor: const Color(0xFF9F9F9F),
  // cardColor: Colors.white,
  // textButtonTheme: TextButtonThemeData(
  //   style: TextButton.styleFrom(foregroundColor: _color),
  // ),
  // scaffoldBackgroundColor: Colors.white,
);
