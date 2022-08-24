import 'package:flog3/src/layout/options/layout_spec_options.dart';
import 'package:json_annotation/json_annotation.dart';

part 'json_layout_options.g.dart';

@JsonSerializable()
class JSONLayoutOptions implements LayoutSpecOptions {
  const JSONLayoutOptions();

  Map<String, dynamic> toJson() => _$JSONLayoutOptionsToJson(this);
  factory JSONLayoutOptions.fromJson(Map<String, dynamic> json) => _$JSONLayoutOptionsFromJson(json);
}
