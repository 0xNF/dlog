import 'package:flog3/src/layout/options/layout_spec_options.dart';
import 'package:json_annotation/json_annotation.dart';

part 'null_options.g.dart';

/// An empty set of layout options
@JsonSerializable()
class NullOptions implements LayoutSpecOptions {
  const NullOptions();

  Map<String, dynamic> toJson() => _$NullOptionsToJson(this);
  factory NullOptions.fromJson(Map<String, dynamic> json) => _$NullOptionsFromJson(json);
}
