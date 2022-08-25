import 'dart:io';

import 'package:flog3/src/target/colored_console/console_row_highlighting_rule.dart';
import 'package:flog3/src/target/colored_console/icolored_console_printer.dart';
import 'package:flog3/src/target/specs/color.dart';

class AnsiPrinter extends IColoredConsolePrinter {
  static const String _terminalDefaultColorEscapeCode = "\x1B[0m";

  final IOSink sink;

  const AnsiPrinter({required this.sink});

  @override
  List<ConsoleRowHighlightingRule> get defaultConsoleRowHighlightingRules => [
        ConsoleRowHighlightingRule(conditionExpression: "level == LogLevel.Fatal", foregroundColor: ConsoleColor.darkRed, backgroundColor: ConsoleColor.noChange),
        ConsoleRowHighlightingRule(conditionExpression: "level == LogLevel.Error", foregroundColor: ConsoleColor.darkYellow, backgroundColor: ConsoleColor.noChange),
        ConsoleRowHighlightingRule(conditionExpression: "level == LogLevel.Warn", foregroundColor: ConsoleColor.darkMagenta, backgroundColor: ConsoleColor.noChange),
        ConsoleRowHighlightingRule(conditionExpression: "level == LogLevel.Info", foregroundColor: ConsoleColor.noChange, backgroundColor: ConsoleColor.noChange),
        ConsoleRowHighlightingRule(conditionExpression: "level == LogLevel.Debug", foregroundColor: ConsoleColor.noChange, backgroundColor: ConsoleColor.noChange),
        ConsoleRowHighlightingRule(conditionExpression: "level == LogLevel.Trace", foregroundColor: ConsoleColor.noChange, backgroundColor: ConsoleColor.noChange),
      ];

  @override
  StringBuffer acquireStringBuffer() {
    return StringBuffer();
  }

  @override
  void releaseStringBuffer(StringBuffer buffer, ConsoleColor? oldForegroundColor, ConsoleColor? oldBackgroundColor, {bool flush = false}) {
    buffer.write(_terminalDefaultColorEscapeCode);
    final s = buffer.toString();
    sink.write(s);
    if (flush) {
      buffer.clear();
    }
  }

  @override
  ConsoleColor? changeForegroundColor(StringBuffer buffer, ConsoleColor? foregroundColor, ConsoleColor? oldForegroundcolor) {
    if (foregroundColor != null) {
      buffer.write(_getForegroundColorEscapeCode(foregroundColor));
    }
    /* there is no 'old' console color */
    return null;
  }

  @override
  ConsoleColor? changeBackgroundColor(StringBuffer buffer, ConsoleColor? backgroundColor, ConsoleColor? oldBackgroundColor) {
    if (backgroundColor != null) {
      buffer.write(_getBackgroundColorEscapeCode(backgroundColor));
    }
    /* there is no 'old' console color */
    return null;
  }

  @override
  void resetDefaultColors(StringBuffer buffer, ConsoleColor? foregroundColor, ConsoleColor? backgroundColor) {
    buffer.write(consoleColorMap[ConsoleColor.noChange]!.ansiForeground);
  }

  @override
  void writeChar(StringBuffer buffer, int charCode) {
    buffer.writeCharCode(charCode);
  }

  @override
  void writeLine(StringBuffer buffer, String text) {
    buffer.writeln(text);
  }

  @override
  void writeSubString(StringBuffer buffer, String text, int index, int endIndex) {
    for (int i = index; i < endIndex; i++) {
      int charCode = text.codeUnitAt(i);
      writeChar(buffer, charCode);
    }
  }

  static String _getForegroundColorEscapeCode(ConsoleColor? color) {
    final c = color ?? ConsoleColor.noChange;
    return consoleColorMap[c]!.ansiForeground;
  }

  static String _getBackgroundColorEscapeCode(ConsoleColor? color) {
    final c = color ?? ConsoleColor.noChange;
    return consoleColorMap[c]!.ansiBackground;
  }
}
