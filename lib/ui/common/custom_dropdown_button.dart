import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meditation_app/helper/string_converter.dart';
import 'package:meditation_app/ui/screens/analytics/data/model/response/category_and_video_name_model.dart';
import 'package:meditation_app/ui/screens/analytics/helper/analytics_enums.dart';

import '../../theme/colors.dart';
import '../../theme/styles.dart';
import '../../theme/text_style.dart';
import '../../util/assets.dart';

class CustomDropDownButton<T> extends StatelessWidget {
  final List<T> items;
  final T? value;
  final String hint;
  final AppStyle appStyle;
  final ValueChanged<T?>? onChanged;
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
    String error = 'Error';
    String? title;
    if (value != null && value is ItemName) {
      title = (value as ItemName).title;
    } else if (value != null && value is FilterDuration) {
      title = (value as FilterDuration).name.capitalizeFirstLetter;
    } else if (value != null) {
      title = error;
    }

    return DropdownButtonHideUnderline(
      child: DropdownButton2<T>(
        isExpanded: true,
        customButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  title ?? hint,
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
                colorFilter: const ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn),
              ),
            ],
          ),
        ),
        items: items.map(
          (T item) {
            String lable = item is ItemName
                ? item.title
                : item is FilterDuration
                    ? item.name.capitalizeFirstLetter
                    : error;
            return DropdownMenuItem<T>(
              value: item,
              child: Text(
                lable,
                style: appStyle.text.font(mulishMedium500, sizePx: 12.5, color: Colors.white),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            );
          },
        ).toList(),
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
              BoxShadow(color: Color(0x47000000), blurRadius: 14, offset: Offset(4, 6), spreadRadius: 0)
            ],
          ),
          scrollbarTheme: ScrollbarThemeData(
            thickness: MaterialStateProperty.all(appStyle.scaleX(1)),
            interactive: true,
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(height: 40),
      ),
    );
  }
}
