extension StringBuilder on StringBuffer {
  int indexOf(Pattern string, [int startPosition = 0]) {
    return toString().indexOf(string, startPosition);
  }

  int indexOfAny(Iterable<String> chars, [int startPosition = 0]) {
    for (final pattern in chars) {
      final i = indexOf(pattern, startPosition);
      if (i > -1) {
        return i;
      }
    }
    return -1;
  }

  void truncate(int len) {
    final sub = substring(0, len);
    clear();
    write(sub);
  }

  String substring(int start, int length) {
    return toString().substring(start, length);
  }

  void writeSubstring(String message, int start, int length) {
    return write(message.substring(start, length));
  }
}
