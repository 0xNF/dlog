import 'dart:convert';
import 'package:flog3/src/layout/layout_spec.dart';
import 'package:flog3/src/target/specs/color.dart';
import 'package:flog3/src/target/specs/target_spec.dart';
import 'package:flog3/src/target/specs/target_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'colored_console_target_spec.g.dart';

@JsonSerializable()
class ColoredConsoleTargetSpec extends TargetSpec {
  static const kind = TargetType.console;

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
  });

  Map<String, dynamic> toJson() => _$ColoredConsoleTargetSpecToJson(this);
  factory ColoredConsoleTargetSpec.fromJson(Map<String, dynamic> json) => _$ColoredConsoleTargetSpecFromJson(json);
}

String encodingToJson(Encoding json) {
  return json.name;
}

Encoding encodingFromJson(String json) {
  return Encoding.getByName(json) ?? const Utf8Codec();
}

@JsonSerializable()
class HiighlightRow {
  @JsonKey(name: "backgroundColor")
  final ColorEnum backgroundColor;
  @JsonKey(name: "foregroundColor")
  final ColorEnum foregroundColor;
  @JsonKey(name: "condition")
  final Condition condition;

  HiighlightRow({
    this.backgroundColor = ColorEnum.noChange,
    this.foregroundColor = ColorEnum.noChange,
    required this.condition,
  });

  Map<String, dynamic> toJson() => _$HiighlightRowToJson(this);
  factory HiighlightRow.fromJson(Map<String, dynamic> json) => _$HiighlightRowFromJson(json);
}

@JsonSerializable()
class HighlightWord {
  ///  Background color. Color Enum Default: NoChange
  @JsonKey(name: "backgroundColor")
  final ColorEnum backgroundColor;

  ///  Foreground color. Color Enum Default: NoChange
  @JsonKey(name: "foregroundColor")
  final ColorEnum foregroundColor;

  /// Condition that must be met before scanning for words to highlight.
  @JsonKey(name: "condition")
  final Condition? condition;

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
    this.backgroundColor = ColorEnum.noChange,
    this.foregroundColor = ColorEnum.noChange,
    this.text,
    this.regex,
    this.ignoreCase = false,
    this.wholeWords = false,
    required this.condition,
  }) {
    if ((text != null) ^ (regex != null)) {
      throw Exception('Text or Regex must be specified. Not both, and not neither');
    }
  }

  Map<String, dynamic> toJson() => _$HighlightWordToJson(this);
  factory HighlightWord.fromJson(Map<String, dynamic> json) => _$HighlightWordFromJson(json);
}

@JsonSerializable()
class Condition {
  const Condition();
  Map<String, dynamic> toJson() => _$ConditionToJson(this);
  factory Condition.fromJson(Map<String, dynamic> json) => _$ConditionFromJson(json);
}
