// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debug_target_spec.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DebugTargetSpec _$DebugTargetSpecFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['name', 'type'],
  );
  return DebugTargetSpec(
    name: json['name'] as String,
    layout: json['layout'] == null
        ? null
        : LayoutSpec.fromJson(json['layout'] as Map<String, dynamic>),
    footer: json['footer'] == null
        ? null
        : LayoutSpec.fromJson(json['footer'] as Map<String, dynamic>),
    header: json['header'] == null
        ? null
        : LayoutSpec.fromJson(json['header'] as Map<String, dynamic>),
    type: $enumDecodeNullable(_$TargetTypeEnumMap, json['type']) ??
        TargetType.debug,
  );
}

Map<String, dynamic> _$DebugTargetSpecToJson(DebugTargetSpec instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': _$TargetTypeEnumMap[instance.type]!,
      'layout': instance.layout,
      'footer': instance.footer,
      'header': instance.header,
    };

const _$TargetTypeEnumMap = {
  TargetType.console: 'Console',
  TargetType.coloredConsole: 'ColoredConsole',
  TargetType.file: 'File',
  TargetType.network: 'Network',
  TargetType.debug: 'Debug',
  TargetType.nil: 'Null',
};
