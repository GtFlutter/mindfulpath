import 'package:flutter/material.dart';

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

  final TextInputAction? textInputAction;

  const MobileNumberTextField({
    super.key,
    required this.onCountryCodeChanged,
    required this.controller,
    required this.initialCountryCodeSelection,
    this.labelText,
    this.errorText,
    this.onChanged,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: CustomeTextFieldStyle.cursorColor,
      onChanged: onChanged,
      textInputAction: textInputAction,
      decoration: CustomeTextFieldStyle.inputDecoration().copyWith(
        labelText: labelText ?? 'Number',
        errorText: errorText,
        prefix: CustomCountryCodePicker(
          showDropDown: true,
          initialSelection: initialCountryCodeSelection,
          style: CustomeTextFieldStyle.valueStyle(),
          onChanged: onCountryCodeChanged,
        ),
      ),
      keyboardType: TextInputType.phone,
      style: CustomeTextFieldStyle.valueStyle(),
    );
  }
}
