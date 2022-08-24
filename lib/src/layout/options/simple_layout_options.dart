import 'package:flog3/src/layout/options/layout_spec_options.dart';
import 'package:json_annotation/json_annotation.dart';

part 'simple_layout_options.g.dart';

@JsonSerializable()
class SimpleLayoutSpecOptions implements LayoutSpecOptions {
  const SimpleLayoutSpecOptions();

  Map<String, dynamic> toJson() => _$SimpleLayoutSpecOptionsToJson(this);
  factory SimpleLayoutSpecOptions.fromJson(Map<String, dynamic> json) => _$SimpleLayoutSpecOptionsFromJson(json);
}
