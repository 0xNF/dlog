import 'package:json_annotation/json_annotation.dart';

enum TargetType {
  @JsonValue("Console")
  console,
  @JsonValue("ColoredConsole")
  coloredConsole,
  @JsonValue("File")
  file,
  @JsonValue("Network")
  network,
  @JsonValue("Debug")
  debug,
  @JsonValue("Null")
  nil,
}

TargetType targetTypefromString(String s) {
  s = s.trim().toLowerCase();
  return TargetType.values.firstWhere((element) => element.name.toLowerCase() == s, orElse: () => TargetType.nil);
}
