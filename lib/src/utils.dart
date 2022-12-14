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

/// These methods were lifted from the https://github.com/leisim/logger package
extension Callsite on StackTrace {
  String? formatStackTrace(int methodCount) {
    final formatted = relevantTraceLines(methodCount);
    if (formatted.isEmpty) {
      return null;
    } else {
      return formatted.join('\n');
    }
  }

  List<String> relevantTraceLines(int methodCount) {
    const int stackTraceBeginIndex = 0;
    var lines = toString().split('\n');
    if (stackTraceBeginIndex > 0 && stackTraceBeginIndex < lines.length - 1) {
      lines = lines.sublist(stackTraceBeginIndex);
    }
    var formatted = <String>[];
    var count = 0;
    for (var line in lines) {
      if (_discardDeviceStacktraceLine(line) || _discardWebStacktraceLine(line) || _discardBrowserStacktraceLine(line) || line.isEmpty) {
        continue;
      }
      formatted.add(line.replaceFirst(RegExp(r'#\d+\s+'), ''));
      if (++count == methodCount) {
        break;
      }
    }
    return formatted;
  }

  String getFileName(String traceLine) {
    final lastCol = traceLine.lastIndexOf(_lineAndColNumberRegex);
    final s2 = traceLine.substring(0, lastCol);
    final lastSlash = s2.lastIndexOf(r'/');
    final s4 = traceLine.substring(lastSlash + 1, lastCol);
    return s4.replaceFirst('.dart', '');
  }

  static final _lineAndColNumberRegex = RegExp(r':\d+:\d+');

  /// Matches a stacktrace line as generated on Android/iOS devices.
  /// For example:
  /// #1      Logger.log (package:logger/src/logger.dart:115:29)
  static final _deviceStackTraceRegex = RegExp(r'#[0-9]+[\s]+(.+) \(([^\s]+)\)');

  /// Matches a stacktrace line as generated by Flutter web.
  /// For example:
  /// packages/logger/src/printers/pretty_printer.dart 91:37
  static final _webStackTraceRegex = RegExp(r'^((packages|dart-sdk)\/[^\s]+\/)');

  /// Matches a stacktrace line as generated by browser Dart.
  /// For example:
  /// dart:sdk_internal
  /// package:logger/src/logger.dart
  static final _browserStackTraceRegex = RegExp(r'^(?:package:)?(dart:[^\s]+|[^\s]+)');

  static bool _discardDeviceStacktraceLine(String line) {
    var match = _deviceStackTraceRegex.matchAsPrefix(line);
    if (match == null) {
      return false;
    }
    return match.group(2)!.startsWith('package:flog');
  }

  static bool _discardWebStacktraceLine(String line) {
    var match = _webStackTraceRegex.matchAsPrefix(line);
    if (match == null) {
      return false;
    }
    return match.group(1)!.startsWith('packages/flog') || match.group(1)!.startsWith('dart-sdk/lib');
  }

  static bool _discardBrowserStacktraceLine(String line) {
    var match = _browserStackTraceRegex.matchAsPrefix(line);
    if (match == null) {
      return false;
    }
    return match.group(1)!.startsWith('package:flog') || match.group(1)!.startsWith('dart:');
  }
}
