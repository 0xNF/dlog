import 'package:flog3/src/layout/layout_spec.dart';
import 'package:flog3/src/target/specs/target_spec.dart';
import 'package:flog3/src/target/specs/target_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'debug_target_spec.g.dart';

@JsonSerializable()
class DebugTargetSpec extends TargetSpec {
  static const kind = TargetType.debug;

  DebugTargetSpec({
    required super.name,
    super.layout,
    super.type = TargetType.debug,
  });

  Map<String, dynamic> toJson() => _$DebugTargetSpecToJson(this);
  factory DebugTargetSpec.fromJson(Map<String, dynamic> json) => _$DebugTargetSpecFromJson(json);
}
