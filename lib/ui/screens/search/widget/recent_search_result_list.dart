import 'package:flutter/material.dart';

import '../../../../theme/styles.dart';
import '../../../../theme/text_style.dart';
import '../search_screen.dart';

class RecentSearchResultList extends StatelessWidget {
  final ValueChanged<String> onRecentSearchTap;
  const RecentSearchResultList({
    super.key,
    required AppStyle style,
    required this.onRecentSearchTap,
  }) : _style = style;

  final AppStyle _style;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return MaterialButton(
          onPressed: () => onRecentSearchTap(recentSearchHistory[index]),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              recentSearchHistory[index],
              textAlign: TextAlign.start,
              style: _style.text.font(mulishRegular400, sizePx: 12.5),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
      itemCount: recentSearchHistory.length,
    );
  }
}
