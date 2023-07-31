import 'package:intl/intl.dart' as intl;

extension OnDateTime on DateTime {
  /// [DateTime] to [String] as [12 - 24 - 2023]
  String get toStringFormat1 {
    return intl.DateFormat('MM - dd - yyyy').format(this);
  }

  /// [DateTime] to [String] as [12 - 24 - 2023 10.08 AM]
  String get toStringFormat2 {
    return intl.DateFormat('MM - dd - yyyy hh:mm a').format(this);
  }

  /// [DateTime] to [String] as [2000-06-15]
  String get toStringFormat3 {
    return intl.DateFormat('yyyy-MM-dd').format(this);
  }
}
