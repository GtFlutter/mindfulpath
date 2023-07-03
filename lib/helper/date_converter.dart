import 'package:intl/intl.dart' as intl;

extension OnDateTime on DateTime {
  /// [DateTime] to [String] as [dd mm yyyy]
  String get toStringFormat1 {
    return intl.DateFormat('dd / MM / yyyy').format(this);
  }
}
