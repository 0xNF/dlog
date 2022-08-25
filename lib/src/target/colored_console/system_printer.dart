import 'dart:io';

import 'package:dart_console/dart_console.dart' as c;
import 'package:flog3/src/target/colored_console/console_row_highlighting_rule.dart';
import 'package:flog3/src/target/colored_console/icolored_console_printer.dart';
import 'package:flog3/src/target/colored_console/color.dart';

class ColoredConsoleSystemPrinter implements IColoredConsolePrinter {
  final console = c.Console();
  final IOSink sink;
  ColoredConsoleSystemPrinter({required this.sink});

  @override
  StringBuffer acquireStringBuffer() {
    return StringBuffer();
  }

  @override
  void releaseStringBuffer(StringBuffer buffer, ConsoleColor? oldForegroundColor, ConsoleColor? oldBackgroundColor, {bool flush = false}) {
    final s = buffer.toString();
    console.writeLine(s);
    if (flush) {
      sink.flush();
    }
  }

  @override
  ConsoleColor? changeBackgroundColor(StringBuffer buffer, ConsoleColor? backgroundColor, ConsoleColor? oldBackgroundColor) {
    final cc = c.ConsoleColor.values.firstWhere((element) => element.name.toLowerCase() == backgroundColor?.name.toLowerCase(), orElse: () => c.ConsoleColor.black);
    console.setBackgroundColor(cc);
    return oldBackgroundColor;
  }

  @override
  ConsoleColor? changeForegroundColor(StringBuffer buffer, ConsoleColor? foregroundColor, ConsoleColor? oldForegroundcolor) {
    final previousForegroundColor = oldForegroundcolor ?? ConsoleColor.noChange;
    if (foregroundColor == null && previousForegroundColor != foregroundColor) {
      final cc = c.ConsoleColor.values.firstWhere((element) => element.name.toLowerCase() == foregroundColor?.name.toLowerCase(), orElse: () => c.ConsoleColor.white);
      console.setForegroundColor(cc);
    }
    return previousForegroundColor;
  }

  @override
  // TODO: implement defaultConsoleRowHighlightingRules
  List<ConsoleRowHighlightingRule> get defaultConsoleRowHighlightingRules => [];

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

  @override
  void resetDefaultColors(StringBuffer buffer, ConsoleColor? foregroundColor, ConsoleColor? backgroundColor) {
    console.resetColorAttributes();
  }
}
