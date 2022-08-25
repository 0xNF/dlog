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
