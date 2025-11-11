import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_app/theme/styles.dart';

class CupertinoDatePickerWidget extends StatefulWidget {
  final DateTime lastDate;
  final DateTime firstDate;
  final DateTime initialDate;
  final AppStyle style;

  const CupertinoDatePickerWidget({
    super.key,
    required this.lastDate,
    required this.firstDate,
    required this.initialDate,
    required this.style,
  });

  @override
  State<CupertinoDatePickerWidget> createState() => _CupertinoDatePickerWidgetState();
}

class _CupertinoDatePickerWidgetState extends State<CupertinoDatePickerWidget> {
  DateTime? _date;
  @override
  void initState() {
    _date = widget.initialDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.only(top: widget.style.scale * 6.0),
        margin: EdgeInsets.only(bottom: widget.style.scale * MediaQuery.of(context).viewInsets.bottom),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  child: const Text('Cancle'),
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    }
                  },
                ),
                CupertinoButton(
                  child: const Text('Done'),
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop(_date);
                    }
                  },
                ),
              ],
            ),
            SizedBox(
              height: widget.style.scale * 216,
              child: CupertinoDatePicker(
                initialDateTime: widget.initialDate,
                minimumDate: widget.firstDate,
                maximumDate: widget.lastDate,
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (DateTime newDate) {
                  setState(() => _date = newDate);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
