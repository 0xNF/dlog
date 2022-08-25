import 'package:flog3/src/target/colored_console/console_row_highlighting_rule.dart';
import 'package:flog3/src/target/specs/color.dart';

abstract class IColoredConsolePrinter {
  /// Creates a TextWriter for the console to start building a colored text message
  StringBuffer acquireStringBuffer();

  /// Releases the TextWriter for the console after having built a colored text message (Restores console colors)
  void releaseStringBuffer(StringBuffer buffer, ConsoleColor? oldForegroundColor, ConsoleColor? oldBackgroundColor, {bool flush = false});

  /// Changes foreground color for the Colored TextWriter
  ///
  /// Returns the previous foreground color for the console
  ConsoleColor? changeForegroundColor(StringBuffer buffer, ConsoleColor? foregroundColor, ConsoleColor? oldForegroundcolor);

  /// Changes background color for the Colored TextWriter
  ///
  /// Returns the previous background color for the console
  ConsoleColor? changeBackgroundColor(StringBuffer buffer, ConsoleColor? backgroundColor, ConsoleColor? oldBackgroundColor);

  /// Restores console colors back to their original state
  void resetDefaultColors(StringBuffer buffer, ConsoleColor? foregroundColor, ConsoleColor? backgroundColor);

  /// Writes multiple characters to the buffer
  void writeSubString(StringBuffer buffer, String text, int index, int endIndex);

  /// Writes a single character to the buffer
  void writeChar(StringBuffer buffer, int charCode);

  /// Writes whole string and completes with newline
  void writeLine(StringBuffer buffer, String text);

  List<ConsoleRowHighlightingRule> get defaultConsoleRowHighlightingRules;

  const IColoredConsolePrinter();
}
