// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'layout_spec.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LayoutSpec _$LayoutSpecFromJson(Map<String, dynamic> json) => LayoutSpec(
      kind: $enumDecodeNullable(_$LayoutKindEnumMap, json['type']) ??
          LayoutKind.simple,
      layout: json['layout'] as String? ??
          r'${longdate}|${level:uppercase=true}|${loggerName}|${message:withexception=true}|${all-event-properties}',
    );

Map<String, dynamic> _$LayoutSpecToJson(LayoutSpec instance) =>
    <String, dynamic>{
      'type': _$LayoutKindEnumMap[instance.kind]!,
      'layout': instance.layout,
    };

const _$LayoutKindEnumMap = {
  LayoutKind.simple: 'Simple',
  LayoutKind.json: 'JSON',
  LayoutKind.csv: 'CSV',
};
