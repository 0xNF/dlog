import 'dart:convert';
import 'package:flog3/src/condition/condition_expression.dart';
import 'package:flog3/src/layout/layout_spec.dart';
import 'package:flog3/src/log_event_info.dart';
import 'package:flog3/src/target/console/console_target_spec.dart';
import 'package:flog3/src/target/colored_console/color.dart';
import 'package:flog3/src/target/specs/target_spec.dart';
import 'package:flog3/src/target/specs/target_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'colored_console_target_spec.g.dart';

@JsonSerializable()
class ColoredConsoleTargetSpec extends TargetSpec {
  static const kind = TargetType.coloredConsole;

  /// File encoding name like "utf-8", "ascii" or "utf-16"
  @JsonKey(name: "encoding", fromJson: encodingFromJson, toJson: encodingToJson)
  final Encoding encoding;

  ///  Indicates whether the error stream (stderr) should be used instead of the output stream (stdout).
  @JsonKey(name: "stdErr")
  final bool useStdErr;

  ///  Indicates whether the console target should disable itself when no console detected.
  @JsonKey(name: "detectConsoleAvailable")
  final bool detectConsoleAvailable;

  /// The row highlighting rules
  @JsonKey(name: "rowHighlightingRules")
  final List<HiighlightRow> rowHighlightingRules;

  ///  Indicates whether to use default row highlighting rules
  ///  Default colors are:
  ///
  /// [Condition]|[Foreground]|[Background]
  /// ---
  /// Level == Fatal | Red      | --
  /// Level == Error | Yellow   | --
  /// Level == Warn  | Magenta  | --
  /// Level == Info  | White    | --
  /// Level == Debug | Grey     | --
  /// Level == Trace | DarkGray | --
  @JsonKey(name: "useDefaultRowHighlightingRules")
  final bool useDefaultRowHighlightingRules;

  /// The word highlighting rules.
  @JsonKey(name: "wordHighlightingRules")
  final List<HighlightWord> wordHighlightingRules;

  /// Indicated whether to auto-check if the console has been redirected to file
  /// disables colored output if detected
  @JsonKey(name: "detectOutputRedirected")
  final bool detectOutputRedirected;

  /// Enables output using ANSI Color Codes
  @JsonKey(name: "enableANSIOutput")
  final bool enableANSIOutput;

  @JsonKey(name: "autoFlush")
  final bool autoFlush;

  ColoredConsoleTargetSpec({
    required super.name,
    super.layout,
    super.footer,
    super.header,
    super.type = TargetType.console,
    this.encoding = const Utf8Codec(),
    this.useStdErr = false,
    this.detectConsoleAvailable = false,
    this.useDefaultRowHighlightingRules = true,
    this.rowHighlightingRules = const [],
    this.wordHighlightingRules = const [],
    this.detectOutputRedirected = true,
    this.enableANSIOutput = false,
    this.autoFlush = false,
  });

  Map<String, dynamic> toJson() => _$ColoredConsoleTargetSpecToJson(this);
  factory ColoredConsoleTargetSpec.fromJson(Map<String, dynamic> json) => _$ColoredConsoleTargetSpecFromJson(json);
}

@JsonSerializable()
class HiighlightRow {
  @JsonKey(name: "backgroundColor")
  final ConsoleColor backgroundColor;
  @JsonKey(name: "foregroundColor")
  final ConsoleColor foregroundColor;
  @JsonKey(name: "condition")
  final String condition;

  const HiighlightRow({
    this.backgroundColor = ConsoleColor.noChange,
    this.foregroundColor = ConsoleColor.noChange,
    required this.condition,
  });

  Map<String, dynamic> toJson() => _$HiighlightRowToJson(this);
  factory HiighlightRow.fromJson(Map<String, dynamic> json) => _$HiighlightRowFromJson(json);
}

@JsonSerializable()
class HighlightWord {
  @JsonKey(ignore: true)
  late final RegExp _regexp;

  ///  Background color. Color Enum Default: NoChange
  @JsonKey(name: "backgroundColor")
  final ConsoleColor backgroundColor;

  ///  Foreground color. Color Enum Default: NoChange
  @JsonKey(name: "foregroundColor")
  final ConsoleColor foregroundColor;

  /// Condition that must be met before scanning for words to highlight.
  @JsonKey(name: "condition")
  final ConditionExpression? condition;

  /// Text to be matched. You must specify either text or regex.
  @JsonKey(name: "text")
  final String? text;

  /// Regular expression to be matched. You must specify either text or regex.
  @JsonKey(name: "regex")
  final String? regex;

  /// Indicates whether to ignore case when comparing texts.
  @JsonKey(name: "ignoreCase")
  final bool ignoreCase;

  /// Indicates whether to match whole words only.
  @JsonKey(name: "wholeWords")
  final bool wholeWords;

  HighlightWord({
    this.backgroundColor = ConsoleColor.noChange,
    this.foregroundColor = ConsoleColor.noChange,
    this.text,
    this.regex,
    this.ignoreCase = false,
    this.wholeWords = false,
    required this.condition,
  }) {
    if ((text != null) ^ (regex != null)) {
      throw Exception('Text or Regex must be specified. Not both, and not neither');
    }
    _regexp = RegExp(text ?? regex ?? '', caseSensitive: !ignoreCase);
  }

  Iterable<Match>? matches(LogEventInfo logEvent, String message) {
    if (condition != null || (condition?.evaluate(logEvent) == false)) {
      return null;
    } else {
      return _regexp.allMatches(message);
    }
  }

  Map<String, dynamic> toJson() => _$HighlightWordToJson(this);
  factory HighlightWord.fromJson(Map<String, dynamic> json) => _$HighlightWordFromJson(json);
}
