import 'package:flutter/material.dart';

import '../../../../theme/text_field_style.dart';
import 'custom_country_code_picker.dart';

class ContactNumberTextField extends StatelessWidget {
  final String initialCountryCodeSelection;
  final ValueChanged<String> onCountryCodeChanged;
  final TextEditingController controller;

  /// Default [labelText] is 'Number'
  final String? labelText;

  const ContactNumberTextField({
    super.key,
    required this.onCountryCodeChanged,
    required this.controller,
    required this.initialCountryCodeSelection,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: CustomeTextFieldStyle.cursorColor,
      decoration: CustomeTextFieldStyle.inputDecoration().copyWith(
        labelText: labelText ?? 'Number',
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
