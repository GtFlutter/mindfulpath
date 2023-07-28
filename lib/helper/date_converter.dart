import 'package:intl/intl.dart' as intl;

extension OnDateTime on DateTime {
  /// [DateTime] to [String] as [dd mm yyyy]
  String get toStringFormat1 {
    return intl.DateFormat('MM - dd - yyyy').format(this);
    return intl.DateFormat('dd / MM / yyyy').format(this);
  }

  /// [DateTime] to [String] as [May 4 , 2023 10.08 AM]
  String get toStringFormat2 {
    return intl.DateFormat('MM - dd - yyyy hh:mm a').format(this);
    return intl.DateFormat('MMM d, y hh:mm a').format(this);
  }
}
