enum ResourceType {
  free(0),
  paid(1);

  final int value;
  const ResourceType(this.value);

  static ResourceType? fromJson(int? value) {
    if (value == free.value) {
      return free;
    } else if (value == paid.value) {
      return paid;
    }
    return null;
  }

  int toInt() => value;
}
