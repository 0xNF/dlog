import 'package:flog3/src/target/specs/target_type.dart';
import 'package:json_annotation/json_annotation.dart';

abstract class TargetSpec {
  @JsonKey(name: 'name', required: true)
  final String name;

  @JsonKey(name: "type", required: true)
  final TargetType type;

  @JsonKey(name: "layout")
  final String layout;

  @JsonKey(name: "footer")
  final String footer;

  @JsonKey(name: "header")
  final String header;

  const TargetSpec({
    required this.name,
    required this.type,
    this.footer = "",
    this.header = "",
    this.layout = r"${longdate}|${level:uppercase=true}|${loggerName}|${message:withexception=true}|${all-event-properties}",
  });
}
