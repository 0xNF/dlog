import 'dart:convert';

class Stack<T> {
  final List<T> _items = [];

  void push(T item) {
    _items.add(item);
  }

  T? pop() {
    if (_items.isEmpty) {
      return null;
    } else {
      return _items.removeLast();
    }
  }

  T? peek() {
    if (_items.isEmpty) {
      return null;
    } else {
      return _items.last;
    }
  }

  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;
}

String encodingToJson(Encoding json) {
  return json.name;
}

Encoding encodingFromJson(String json) {
  return Encoding.getByName(json) ?? const Utf8Codec();
}
