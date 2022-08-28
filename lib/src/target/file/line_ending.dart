import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

enum LineEnding {
  @JsonValue("CR")
  cr,
  @JsonValue("CRLF")
  crLf,
  @JsonValue("LF")
  lf,
  @JsonValue("Default")
  platform,
  @JsonValue("None")
  none;

  String chars() {
    switch (this) {
      case LineEnding.cr:
        return "\r";
      case LineEnding.crLf:
        return "\r\n";
      case LineEnding.lf:
        return "\n";
      case LineEnding.platform:
        return Platform.isWindows ? LineEnding.crLf.chars() : LineEnding.lf.chars();
      case LineEnding.none:
      default:
        return "";
    }
  }
}
