// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'null_target_spec.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NullTargetSpec _$NullTargetSpecFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['name', 'type'],
  );
  return NullTargetSpec(
    name: json['name'] as String,
    layout: json['layout'] as String? ??
        r"${longdate}|${level:uppercase=true}|${loggerName}|${message:withexception=true}|${all-event-properties}",
    type: $enumDecodeNullable(_$TargetTypeEnumMap, json['type']) ??
        TargetType.nil,
  );
}

Map<String, dynamic> _$NullTargetSpecToJson(NullTargetSpec instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': _$TargetTypeEnumMap[instance.type]!,
      'layout': instance.layout,
    };

const _$TargetTypeEnumMap = {
  TargetType.console: 'Console',
  TargetType.file: 'File',
  TargetType.network: 'Network',
  TargetType.debug: 'Debug',
  TargetType.nil: 'Null',
};
