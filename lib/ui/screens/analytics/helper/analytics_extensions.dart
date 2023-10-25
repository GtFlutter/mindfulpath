extension OnDouble on double? {
  String formatInDuration() {
    if (this != null) {
      // Calculate the days, hours, minutes, and seconds.
      int days = (this! / 24).floor();
      int hours = (this! % 24).floor();
      int minutes = ((this! - (days * 24 + hours)) * 60).floor();
      int seconds = ((this! - (days * 24 + hours + minutes / 60)) * 60 * 60).floor();

      // Construct the formatted string.
      String formattedString = '';
      if (days > 0) formattedString += '${days}d ';
      if (hours > 0) formattedString += '${hours}h ';
      if (minutes > 0) formattedString += '${minutes}m ';
      if (seconds > 0) formattedString += '${seconds.toString()}s';

      if (formattedString.isNotEmpty) {
        return formattedString;
      }
    }
    return '_';
  }
}
