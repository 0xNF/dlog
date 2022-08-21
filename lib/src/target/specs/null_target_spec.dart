import 'package:flog3/src/target/specs/target_spec.dart';
import 'package:flog3/src/target/specs/target_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'null_target_spec.g.dart';

@JsonSerializable()
class NullTargetSpec extends TargetSpec {
  static const kind = TargetType.nil;

  const NullTargetSpec({
    required super.name,
    super.layout,
    super.type = TargetType.nil,
  });

  Map<String, dynamic> toJson() => _$NullTargetSpecToJson(this);
  factory NullTargetSpec.fromJson(Map<String, dynamic> json) => _$NullTargetSpecFromJson(json);
}
