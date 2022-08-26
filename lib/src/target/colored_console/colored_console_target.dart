import 'dart:convert';
import 'dart:io';

import 'package:flog3/src/condition/condition_expression.dart';
import 'package:flog3/src/configuration/configuration.dart';
import 'package:flog3/src/internal_logger/internal_logger.dart';
import 'package:flog3/src/string_builder.dart';
import 'package:flog3/src/target/colored_console/ansi_printer.dart';
import 'package:flog3/src/target/colored_console/colored_console_target_spec.dart';
import 'package:flog3/src/target/colored_console/console_row_highlighting_rule.dart';
import 'package:flog3/src/target/colored_console/icolored_console_printer.dart';
import 'package:flog3/src/target/colored_console/system_printer.dart';
import 'package:flog3/src/target/colored_console/color.dart';
import 'package:flog3/src/target/specs/target_spec.dart';
import 'package:flog3/src/target/target_with_layout_header_footer.dart';
import 'package:flog3/src/log_event_info.dart';
import 'package:flog3/src/utils.dart';

class ColoredConsoleTarget extends TargetWithLayoutHeaderAndFooter {
  /// string for character code 0x0007, aka (\a) aka the Alert Control character
  static final String escapeA = String.fromCharCode(0x0007);

  final Encoding encoding;
  final bool useStdErr;
  final bool detectConsoleAvailable;
  final List<HiighlightRow> rowHighlightingRules;
  final bool useDefaultRowHighlightingRules;
  final List<HighlightWord> wordHighlightingRules;
  final bool detectOutputRedirected;
  final bool enableANSIOutput;
  final bool autoFlush;
  bool _pauseLogging = false;
  Stdout _consoleStream;
  bool _disableColors = false;
  IColoredConsolePrinter _consolePrinter;

  ColoredConsoleTarget({
    required super.spec,
    required super.config,
    required Stdout sink,
    required this.encoding,
    required this.detectConsoleAvailable,
    required this.useStdErr,
    required this.rowHighlightingRules,
    required this.useDefaultRowHighlightingRules,
    required this.wordHighlightingRules,
    required this.detectOutputRedirected,
    required this.enableANSIOutput,
    required this.autoFlush,
  })  : _consoleStream = sink,
        _consolePrinter = _createConsolePrinter(enableANSIOutput, sink);

  factory ColoredConsoleTarget.fromSpec(TargetSpec spec, LogConfiguration config) {
    final xspec = spec as ColoredConsoleTargetSpec;
    return ColoredConsoleTarget(
      spec: xspec,
      config: config,
      sink: xspec.useStdErr ? stderr : stdout,
      detectConsoleAvailable: xspec.detectConsoleAvailable,
      encoding: xspec.encoding,
      useStdErr: xspec.useStdErr,
      rowHighlightingRules: xspec.rowHighlightingRules,
      useDefaultRowHighlightingRules: xspec.useDefaultRowHighlightingRules,
      wordHighlightingRules: xspec.wordHighlightingRules,
      detectOutputRedirected: xspec.detectOutputRedirected,
      enableANSIOutput: xspec.enableANSIOutput,
      autoFlush: xspec.autoFlush,
    );
  }

  static IColoredConsolePrinter _createConsolePrinter(bool enableAnsiOutput, IOSink sink) {
    if (!enableAnsiOutput) {
      return ColoredConsoleSystemPrinter(sink: sink);
    } else {
      return AnsiPrinter(sink: sink);
    }
  }

  @override
  void initializeTarget() {
    _pauseLogging = false;
    _disableColors = false;
    if (detectConsoleAvailable) {
      if ((useStdErr && !stderr.hasTerminal) || (!useStdErr && !stdout.hasTerminal)) {
        internalLogger.info("${this}: Colored Console has been detected as turned off. Disable DetectConsoleAvailable to skip detection. Reason: {1}");
        _pauseLogging = true;
      }
    } else {
      _consoleStream = useStdErr ? stderr : stdout;
      _consoleStream.encoding = encoding;
    }

    if (!enableANSIOutput || !_consoleStream.supportsAnsiEscapes) {
      internalLogger.info("${this}: Colored Console either has ANSIOutput disabled, or console doesnt support ANSI color codes. Will use a systen printer instad");
    }
    if (header != null) {
      _writeToOutput(LogEventInfo.nullEvent, header!.render(LogEventInfo.nullEvent));
    }
    super.initializeTarget();
  }

  @override
  void closeTarget() {
    if (footer != null) {
      _writeToOutput(LogEventInfo.nullEvent, footer!.render(LogEventInfo.nullEvent));
    }
    _explicitConsoleFlush();
    super.closeTarget();
  }

  @override
  void write(LogEventInfo logEvent) {
    if (_pauseLogging) {
      return;
    }
    String s = super.layout.render(logEvent);
    _writeToOutput(logEvent, s);
  }

  void _writeToOutput(LogEventInfo logEvent, String s) {
    if (_pauseLogging) {
      return;
    }
    _writeToOutputWithColor(logEvent, s);
  }

  void _writeToOutputWithColor(LogEventInfo logEvent, String message) {
    String colorMessage = message;
    ConsoleColor? newForegroundColor;
    ConsoleColor? newBackgroundColor;
    if (!_disableColors) {
      final matchingRule = _getMatchingRowHighlightRule(logEvent);
      if (wordHighlightingRules.isNotEmpty) {
        colorMessage = _generateColorEscapeSequences(logEvent, message);
      }
      newForegroundColor = matchingRule?.foregroundColor ?? ConsoleColor.noChange;
      newBackgroundColor = matchingRule?.backgroundColor ?? ConsoleColor.noChange;
    }

    if (colorMessage == message && newForegroundColor == null && newBackgroundColor == null) {
      _consoleStream.writeln(message);
    } else {
      bool wordHighlighting = colorMessage != message;
      if (!wordHighlighting && message.contains('\n')) {
        wordHighlighting = true; // Newlines requires additional handling when doing colors
        colorMessage = _escapeColorCodes(message);
      }
      _writeToOutputWithPrinter(_consoleStream, colorMessage, newForegroundColor, newBackgroundColor, wordHighlighting);
    }
  }

  void _writeToOutputWithPrinter(IOSink consoleStream, String colorMessage, ConsoleColor? newForegroundColor, ConsoleColor? newBackgroundColor, bool wordHighlighting) {
    final consoleWriter = _consolePrinter.acquireStringBuffer();

    ConsoleColor? oldForegroundColor;
    ConsoleColor? oldBackgroundColor;

    try {
      if (wordHighlighting) {
        oldForegroundColor = _consolePrinter.changeForegroundColor(consoleWriter, newForegroundColor, null);
        oldBackgroundColor = _consolePrinter.changeBackgroundColor(consoleWriter, newBackgroundColor, null);
        final rowForegroundColor = newForegroundColor ?? oldForegroundColor;
        final rowBackgroundColor = newBackgroundColor ?? oldBackgroundColor;
        _colorizeEscapeSequences(_consolePrinter, consoleWriter, colorMessage, oldForegroundColor, oldBackgroundColor, rowForegroundColor, rowBackgroundColor);
        _consolePrinter.writeLine(consoleWriter, "");
      } else {
        if (newBackgroundColor != null) {
          oldForegroundColor = _consolePrinter.changeForegroundColor(consoleWriter, newForegroundColor, null);
          if (oldForegroundColor == newForegroundColor) {
            oldForegroundColor = null; // no color restore is needed
          }

          oldBackgroundColor = _consolePrinter.changeBackgroundColor(consoleWriter, newBackgroundColor, null);
          if (oldBackgroundColor == newBackgroundColor) {
            oldBackgroundColor = null; // no color restore is needed
          }
        }
      }
    } finally {
      _consolePrinter.releaseStringBuffer(consoleWriter, oldForegroundColor, oldBackgroundColor, flush: autoFlush);
    }
  }

  ConsoleRowHighlightingRule? _getMatchingRowHighlightRule(LogEventInfo logEvent) {
    // TODO(nf) where to get initial rules from;
    ConsoleRowHighlightingRule? matchingRule = _getMatchingRowHighlightRuleFromRules([], logEvent);
    if (matchingRule == null && useDefaultRowHighlightingRules) {
      matchingRule = _getMatchingRowHighlightRuleFromRules(_consolePrinter.defaultConsoleRowHighlightingRules, logEvent);
    }
    return matchingRule ?? ConsoleRowHighlightingRule.defaultt;
  }

  ConsoleRowHighlightingRule? _getMatchingRowHighlightRuleFromRules(List<ConsoleRowHighlightingRule> rules, LogEventInfo logEvent) {
    for (int i = 0; i < rules.length; ++i) {
      var rule = rules[i];
      if (rule.checkCondition(logEvent)) {
        return rule;
      }
    }
    return null;
  }

  void _explicitConsoleFlush() {
    if (!_pauseLogging && !autoFlush) {
      _consoleStream.flush();
    }
  }

  String _generateColorEscapeSequences(LogEventInfo logEvent, String message) {
    if (message.isEmpty) {
      return message;
    }
    String m = _escapeColorCodes(message);
    final sb = StringBuffer();
    for (int i = 0; i < wordHighlightingRules.length; i++) {
      final hl = wordHighlightingRules[i];
      final matches = hl.matches(logEvent, m);
      if (matches?.isEmpty ?? true) {
        continue;
      }
      sb.clear();
      int previousIndex = 0;
      for (final match in matches!) {
        sb.writeSubstring(m, previousIndex, match.start - previousIndex);
        final foregroundCharCode = consoleColorMap[hl.foregroundColor]!.asciCode + 'A'.codeUnitAt(0);
        final backgroundCharCode = consoleColorMap[hl.backgroundColor]!.asciCode + 'A'.codeUnitAt(0);
        sb.writeAll([
          escapeA,
          String.fromCharCode(foregroundCharCode),
          String.fromCharCode(backgroundCharCode),
          match.group(0),
          escapeA,
          'X',
        ]);
        previousIndex = match.start + (match.end - match.start);
      }
      if (sb.isNotEmpty) {
        sb.writeSubstring(m, previousIndex, m.length - previousIndex);
        m = sb.toString();
      }
    }
    return m;
  }

  static String _escapeColorCodes(String message) {
    if (message.contains(escapeA)) {
      return message.replaceAll(r"\a", r"\a\a");
    }
    return message;
  }

  void _colorizeEscapeSequences(
    IColoredConsolePrinter consolePrinter,
    StringBuffer consoleWriter,
    String message,
    ConsoleColor? defaultForegroundColor,
    ConsoleColor? defaultBackgroundColor,
    ConsoleColor? rowForegroundColor,
    ConsoleColor? rowBackgroundColor,
  ) {
    // TODO(nf)
    final colorStack = Stack<MapEntry<ConsoleColor?, ConsoleColor?>>();

    colorStack.push(MapEntry<ConsoleColor?, ConsoleColor?>(rowForegroundColor, rowBackgroundColor));

    int p0 = 0;

    while (p0 < message.length) {
      int p1 = p0;
      while (p1 < message.length && message[p1].codeUnitAt(0) >= 32) {
        p1++;
      }

      // text
      if (p1 != p0) {
        consolePrinter.writeSubString(consoleWriter, message, p0, p1);
      }

      if (p1 >= message.length) {
        p0 = p1;
        break;
      }

      // Control Characters
      final c1 = message[p1];
      if (c1 == '\r' || c1 == '\n') {
        // Newline control characters
        final currentColorConfig = colorStack.peek();
        final resetForegroundColor = currentColorConfig?.key != defaultForegroundColor ? defaultForegroundColor : null;
        final resetBackgroundColor = currentColorConfig?.value != defaultBackgroundColor ? defaultBackgroundColor : null;
        consolePrinter.resetDefaultColors(consoleWriter, resetForegroundColor, resetBackgroundColor);
        if ((p1 + 1) < message.length && message[p1 + 1] == '\n') {
          consolePrinter.writeSubString(consoleWriter, message, p1, p1 + 2);
          p0 = p1 + 2;
        } else {
          consolePrinter.writeChar(consoleWriter, c1.codeUnitAt(0));
          p0 = p1 + 1;
        }
        consolePrinter.changeForegroundColor(consoleWriter, currentColorConfig!.key, defaultForegroundColor);
        consolePrinter.changeBackgroundColor(consoleWriter, currentColorConfig.value, defaultBackgroundColor);
        continue;
      }

      if (c1 == escapeA) {
        consolePrinter.writeChar(consoleWriter, escapeA.codeUnitAt(0));
        p0 = p1 + 2;
        continue;
      }

      final c2 = message[p1 + 1];
      if (c2 == escapeA) {
        consolePrinter.writeChar(consoleWriter, escapeA.codeUnitAt(0));
        p0 = p1 + 1;
        continue;
      }

      if (c2 == 'X') {
        final oldColorConfig = colorStack.pop();
        final newColorConfig = colorStack.peek();
        if ((newColorConfig?.key != oldColorConfig?.key) || (newColorConfig?.value != oldColorConfig?.value)) {
          if ((oldColorConfig?.key != null && newColorConfig?.key != null) || (oldColorConfig?.value != null && newColorConfig?.value != null)) {
            consolePrinter.resetDefaultColors(consoleWriter, defaultForegroundColor, defaultBackgroundColor);
          }
          consolePrinter.changeForegroundColor(consoleWriter, newColorConfig?.key, oldColorConfig?.key);
          consolePrinter.changeForegroundColor(consoleWriter, newColorConfig?.value, oldColorConfig?.value);
        }
        p0 = p1 + 2;
        continue;
      }

      ConsoleColor? currentForegroundColor = colorStack.peek()?.key;
      ConsoleColor? currentBackgroundColor = colorStack.peek()?.value;

      final foregroundChar = c2.codeUnitAt(0) - 'A'.codeUnitAt(0);
      final backgroundChar = message[p1 + 2].codeUnitAt(0) - 'A'.codeUnitAt(0);
      final foreground = consoleColors.firstWhere((element) => element.asciCode == foregroundChar);
      final background = consoleColors.firstWhere((element) => element.asciCode == backgroundChar);

      if (foreground.color != ConsoleColor.noChange) {
        currentForegroundColor = foreground.color;
        consolePrinter.changeForegroundColor(consoleWriter, currentForegroundColor, null);
      }

      if (background.color != ConsoleColor.noChange) {
        currentBackgroundColor = background.color;
        consolePrinter.changeBackgroundColor(consoleWriter, currentBackgroundColor, null);
      }

      colorStack.push(MapEntry(currentForegroundColor, currentBackgroundColor));
      p0 = p1 + 3;
    }

    if (p0 < message.length) {
      consolePrinter.writeSubString(consoleWriter, message, p0, message.length);
    }
  }
}
