import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../theme/styles.dart';
import '../../../../theme/text_field_style.dart';
import 'custom_country_code_picker.dart';

class MobileNumberTextField extends StatelessWidget {
  final String initialCountryCodeSelection;
  final ValueChanged<String> onCountryCodeChanged;
  final TextEditingController controller;

  /// Default [labelText] is 'Number'
  final String? labelText;

  final String? errorText;
  final ValueChanged<String>? onChanged;
  final Function()? onTap;

  final TextInputAction? textInputAction;
  final AppStyle style;

  const MobileNumberTextField({
    super.key,
    required this.onCountryCodeChanged,
    required this.controller,
    required this.initialCountryCodeSelection,
    this.labelText,
    this.errorText,
    this.onChanged,
    this.onTap,
    this.textInputAction,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: CustomeTextFieldStyle.cursorColor,
      onChanged: onChanged,
      onTap: onTap,
      textInputAction: textInputAction,
      decoration: CustomeTextFieldStyle.inputDecoration(style: style).copyWith(
        labelText: labelText ?? 'Number',
        errorText: errorText,
        prefix: CustomCountryCodePicker(
          showDropDown: true,
          initialSelection: initialCountryCodeSelection,
          textStyle: CustomeTextFieldStyle.valueStyle(style: style),
          onChanged: onCountryCodeChanged,
          style: style,
        ),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      style: CustomeTextFieldStyle.valueStyle(style: style),
    );
  }
}
