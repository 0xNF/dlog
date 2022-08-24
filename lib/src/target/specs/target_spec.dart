import 'package:flog3/src/layout/layout_spec.dart';
import 'package:flog3/src/target/specs/target_type.dart';
import 'package:json_annotation/json_annotation.dart';

abstract class TargetSpec {
  @JsonKey(name: 'name', required: true)
  final String name;

  @JsonKey(name: "type", required: true)
  final TargetType type;

  @JsonKey(name: "layout")
  final LayoutSpec layout;

  @JsonKey(name: "footer")
  final LayoutSpec footer;

  @JsonKey(name: "header")
  final LayoutSpec header;

  TargetSpec({
    required this.name,
    required this.type,
    LayoutSpec? footer,
    LayoutSpec? header,
    LayoutSpec? layout,
  })  : footer = footer ?? LayoutSpec(layout: ''),
        header = header ?? LayoutSpec(layout: ''),
        layout = layout ?? LayoutSpec();
}
