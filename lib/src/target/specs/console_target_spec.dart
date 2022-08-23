import 'dart:convert';
import 'package:flog3/src/target/specs/target_spec.dart';
import 'package:flog3/src/target/specs/target_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'console_target_spec.g.dart';

@JsonSerializable()
class ConsoleTargetSpec extends TargetSpec {
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

  const ConsoleTargetSpec({
    required super.name,
    super.layout,
    super.type = TargetType.console,
    this.encoding = const Utf8Codec(),
    this.useStdErr = false,
    this.detectConsoleAvailable = false,
  });

  Map<String, dynamic> toJson() => _$ConsoleTargetSpecToJson(this);
  factory ConsoleTargetSpec.fromJson(Map<String, dynamic> json) => _$ConsoleTargetSpecFromJson(json);
}

String encodingToJson(Encoding json) {
  return json.name;
}

Encoding encodingFromJson(String json) {
  return Encoding.getByName(json) ?? const Utf8Codec();
}
