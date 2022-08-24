import 'package:json_annotation/json_annotation.dart';
import 'package:json_serializable/json_serializable.dart';

part 'layout_spec.g.dart';

@JsonSerializable()
class LayoutSpec {
  static const String defaultLayout = r"${longdate}|${level:uppercase=true}|${loggerName}|${message:withexception=true}|${all-event-properties}";

  @JsonKey(name: 'type', defaultValue: LayoutKind.simple)
  final LayoutKind kind;

  @JsonKey(name: 'layout', defaultValue: defaultLayout)
  final String layout;

  const LayoutSpec({
    this.kind = LayoutKind.simple,
    this.layout = defaultLayout,
  });

  Map<String, dynamic> toJson() => _$LayoutSpecToJson(this);
  factory LayoutSpec.fromJson(Map<String, dynamic> json) => _$LayoutSpecFromJson(json);
}

enum LayoutKind {
  @JsonValue("Simple")
  simple,

  @JsonValue("JSON")
  json,

  @JsonValue("CSV")
  csv,
}
