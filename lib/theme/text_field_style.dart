import 'package:flutter/material.dart';
import 'package:meditation_app/theme/text_style.dart';

import '../main.dart';
import 'colors.dart';

class CustomeTextFieldStyle {
  static const Color cursorColor = Colors.white;

  static TextStyle valueStyle({double? spacingPc}) {
    return $style.text.font(
      mulishMedium500,
      sizePx: 15,
      color: AppColors.textFieldValueColor,
      spacingPc: spacingPc,
    );
  }

  static InputDecoration inputDecoration() {
    return InputDecoration(
      border: const OutlineInputBorder(),
      enabledBorder: _outlineInputBorder(),
      focusedBorder: _outlineInputBorder(),
      errorBorder: _outlineInputBorder(),
      errorStyle: $style.text.font(mulishRegular400, sizePx: 11, color: Colors.white),
      focusedErrorBorder: _outlineInputBorder(),
      labelStyle: $style.text.font(
        mulishSemiBold600,
        sizePx: 17,
        color: AppColors.textFieldLableColor,
      ),
      floatingLabelStyle: $style.text.font(
        mulishBold700,
        sizePx: 16,
        color: Colors.white,
      ),
      contentPadding: EdgeInsets.fromLTRB(
        $style.scale * 36.5,
        $style.scale * 13.5,
        $style.scale * 12,
        $style.scale * 13.5,
      ),
    );
  }

  static OutlineInputBorder _outlineInputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.textFieldEnableBorderColor,
        width: $style.scale * 0.9,
      ),
      borderRadius: BorderRadius.circular($style.scale * 10),
      gapPadding: $style.scale * 12,
    );
  }
}
