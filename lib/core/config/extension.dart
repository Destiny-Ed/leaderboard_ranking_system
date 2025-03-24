extension EllipsisExtension on String {
  String ellipsis({int? max}) {
    if (max == 0) return this;
    if (length > (max ?? 19)) {
      final getFirst14String = substring(0, (max ?? 19));
      return '$getFirst14String...';
    }
    return this;
  }
}
