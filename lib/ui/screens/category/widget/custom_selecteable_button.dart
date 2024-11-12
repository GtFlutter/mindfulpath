import 'package:flutter/material.dart';

import '../../../../theme/colors.dart';
import '../../../../theme/text_style.dart';
import '../../../../util/dimensions.dart';

class CustomSelecteableButton extends StatelessWidget {
  final String text;
  final bool selected;
  final void Function() onTap;
  const CustomSelecteableButton({super.key, required this.text, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minWidth: 85),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_LARGE),
          border: Border.all(color: AppColors.primaryColor),
          color: selected ? AppColors.primaryColor : null,
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
        child: Text(
          text,
          style: mulishRegular400.copyWith(color: selected ? Colors.black : Colors.white),
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
