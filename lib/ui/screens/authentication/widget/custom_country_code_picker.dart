import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/main.dart';
import 'package:meditation_app/theme/colors.dart';
import 'package:meditation_app/theme/text_style.dart';

class CustomCountryCodePicker extends StatelessWidget {
  final bool showDropDown;

  final TextStyle? style;
  final String? initialSelection;
  final ValueChanged<String> onChanged;

  const CustomCountryCodePicker({
    super.key,
    this.showDropDown = true,
    this.style,
    required this.onChanged,
    this.initialSelection,
  });

  @override
  Widget build(BuildContext context) {
    return CountryCodePicker(
      showFlag: false,
      showFlagDialog: true,
      dialogBackgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      boxDecoration: const BoxDecoration(),
      onChanged: (CountryCode value) {
        if (value.dialCode != null) onChanged(value.dialCode!);
      },
      onInit: (CountryCode? value) {
        if (value != null && value.dialCode != null) {
          onChanged(value.dialCode!);
        }
      },
      initialSelection: initialSelection,
      flagWidth: 32,
      dialogTextStyle: $style.text.font(mulishRegular400, sizePx: 15, color: AppColors.textFieldValueColor),
      searchStyle: $style.text.font(mulishRegular400, sizePx: 15, color: AppColors.textFieldValueColor),
      searchDecoration: const InputDecoration(
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.secondaryColor)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.secondaryColor)),
      ),
      builder: (selectedCode) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedCode!.dialCode.toString(),
              style: style,
            ),
            if (showDropDown)
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: style != null ? style!.color : Colors.white,
                size: $style.scale * 20,
              ),
            SizedBox(width: $style.scale * 10),
          ],
        );
      },
    );
  }
}
