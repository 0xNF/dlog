import 'package:json_annotation/json_annotation.dart';

part 'variable_spec.g.dart';

@JsonSerializable()
class VariableSpec {
  @JsonKey(name: "name")
  final String name;
  @JsonKey(name: "value")
  final String value;
  const VariableSpec({
    required this.value,
    required this.name,
  });

  Map<String, dynamic> toJson() => _$VariableSpecToJson(this);
  factory VariableSpec.fromJson(Map<String, dynamic> json) => _$VariableSpecFromJson(json);
}
