import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme/colors.dart';
import '../../theme/styles.dart';
import '../../theme/text_style.dart';
import '../../util/assets.dart';

class CustomDropDownButton extends StatelessWidget {
  final List<String> items;
  final String? value;
  final String hint;
  final AppStyle appStyle;
  final ValueChanged<String?>? onChanged;
  final double maxHeight;
  final double? width;

  const CustomDropDownButton({
    super.key,
    required this.value,
    required this.appStyle,
    required this.items,
    this.onChanged,
    required this.maxHeight,
    this.width,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        customButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  value ?? hint,
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
            thickness: MaterialStateProperty.all(appStyle.scaleX(1)),
            interactive: true,
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
        ),
      ),
    );
  }
}
