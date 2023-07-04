import 'package:flutter/material.dart';

import '../../../../main.dart';
import '../../../../theme/text_style.dart';

class DashboardHeader extends StatelessWidget {
  final String title;
  const DashboardHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        $style.scale * 22,
        $style.scale * 30,
        $style.scale * 22,
        $style.scale * 20,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: $style.text.font(
            mulishMedium500,
            sizePx: 15,
            color: Colors.white,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
