import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/theme/styles.dart';

import 'cupertino_date_picker.dart';

class AdaptiveDatePicker {
  static Future<DateTime?> pick(BuildContext context, {DateTime? initialDate}) async {
    const int minAge = 16;
    const int maxAge = 150;

    DateTime currentDate = DateTime.now();
    DateTime lastDate = DateTime(currentDate.year - minAge, currentDate.month, currentDate.day);
    DateTime firstDate = DateTime(currentDate.year - maxAge, currentDate.month, currentDate.day);

    if (Platform.isIOS) {
      return await showCupertinoModalPopup<DateTime?>(
          context: context,
          builder: (BuildContext context) {
            AppStyle style = AppStyle(screenSize: MediaQuery.of(context).size);
            return CupertinoDatePickerWidget(
              firstDate: firstDate,
              lastDate: lastDate,
              initialDate: initialDate ?? lastDate,
              style: style,
            );
          });
    } else {
      return await showDatePicker(
        context: context,
        initialDate: initialDate ?? lastDate,
        firstDate: firstDate,
        lastDate: lastDate,
      );
    }
  }
}
