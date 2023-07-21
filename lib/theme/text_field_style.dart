import 'package:flutter/material.dart';
import 'package:meditation_app/theme/styles.dart';
import 'package:meditation_app/theme/text_style.dart';
import 'colors.dart';

class CustomeTextFieldStyle {
  static const Color cursorColor = Colors.white;

  static TextStyle valueStyle({
    double? spacingPc,
    required AppStyle style,
    bool? enabled,
    double valueSize = 15,
  }) {
    return style.text.font(
      mulishMedium500,
      sizePx: valueSize,
      color:
          enabled != null && !enabled ? AppColors.textFieldValueColor.withOpacity(0.54) : AppColors.textFieldValueColor,
      spacingPc: spacingPc,
    );
  }

  static InputDecoration inputDecoration({
    required AppStyle style,
    bool? enabled,
    double labelSize = 17,
    double floatingLabelSize = 16,
  }) {
    return InputDecoration(
      border: const OutlineInputBorder(),
      enabledBorder: _outlineInputBorder(style: style),
      focusedBorder: _outlineInputBorder(style: style),
      errorBorder: _outlineInputBorder(style: style),
      errorStyle: style.text.font(mulishRegular400, sizePx: 11, color: Colors.white),
      focusedErrorBorder: _outlineInputBorder(style: style),
      labelStyle: style.text.font(
        mulishSemiBold600,
        sizePx: labelSize,
        color: AppColors.textFieldLableColor,
      ),
      disabledBorder: _outlineInputBorder(style: style),
      floatingLabelStyle: style.text.font(
        mulishBold700,
        sizePx: floatingLabelSize,
        color: enabled != null && !enabled ? Colors.white54 : Colors.white,
      ),
      contentPadding: EdgeInsets.fromLTRB(
        style.scale * 36.5,
        style.scale * 13.5,
        style.scale * 12,
        style.scale * 13.5,
      ),
    );
  }

  static OutlineInputBorder _outlineInputBorder({required AppStyle style}) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.textFieldEnableBorderColor,
        width: style.scale * 0.9,
      ),
      borderRadius: BorderRadius.circular(style.scale * 10),
      gapPadding: style.scale * 12,
    );
  }
}
