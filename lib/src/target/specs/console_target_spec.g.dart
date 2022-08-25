// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'console_target_spec.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConsoleTargetSpec _$ConsoleTargetSpecFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['name', 'type'],
  );
  return ConsoleTargetSpec(
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
        TargetType.console,
    encoding: json['encoding'] == null
        ? const Utf8Codec()
        : encodingFromJson(json['encoding'] as String),
    useStdErr: json['stdErr'] as bool? ?? false,
    detectConsoleAvailable: json['detectConsoleAvailable'] as bool? ?? false,
  );
}

Map<String, dynamic> _$ConsoleTargetSpecToJson(ConsoleTargetSpec instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': _$TargetTypeEnumMap[instance.type]!,
      'layout': instance.layout,
      'footer': instance.footer,
      'header': instance.header,
      'encoding': encodingToJson(instance.encoding),
      'stdErr': instance.useStdErr,
      'detectConsoleAvailable': instance.detectConsoleAvailable,
    };

const _$TargetTypeEnumMap = {
  TargetType.console: 'Console',
  TargetType.coloredConsole: 'ColoredConsole',
  TargetType.file: 'File',
  TargetType.network: 'Network',
  TargetType.debug: 'Debug',
  TargetType.nil: 'Null',
};
