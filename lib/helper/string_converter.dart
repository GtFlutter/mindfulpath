extension OnString on String {
  /// This is use for masking string
  /// Like Input 9687899885 Output would be 96******85
  String mask() {
    if (length <= 1) return this;

    /// Get First Two Character Or Less
    var start = length >= 3
        ? substring(0, 2)
        : isNotEmpty
            ? substring(0, 1)
            : this;

    /// Get First Last Character Or Less
    var end = length >= 4
        ? substring(length - 2, length)
        : length == 3 || length == 2
            ? substring(length - 1, length)
            : '';

    int remaningLength = length - start.length - end.length;
    String fillChar = '*' * remaningLength;

    return '$start$fillChar$end';
  }

  bool get isEmail => RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(this);

  String firstWord() {
    List<String> words = split(' ');
    return words.isNotEmpty ? "${words.first} " : '';
  }

  String removeFirstWord() {
    List<String> words = split(' ');
    return words.length > 1 ? words.sublist(1).join(' ') : '';
  }

  String get capitalizeFirstLetter {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
  
  
  String get toDuration {
    Duration duration = Duration(
      hours: int.parse(split(':')[0]),
      minutes: int.parse(split(':')[1]),
      seconds: int.parse(split(':')[2].split('.')[0]),
      milliseconds: int.parse(split(':')[2].split('.')[1]),
    );
    if (duration.inHours > 0) {
      return '${duration.inHours} ${duration.inHours > 1 ? 'Hours' : 'Hour'}';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} Min';
    } else {
      return '${duration.inSeconds} Sec';
    }
  }
}
