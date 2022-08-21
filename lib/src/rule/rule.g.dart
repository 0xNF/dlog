// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rule _$RuleFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['name', 'writeTo'],
  );
  return Rule(
    loggerName: json['name'] as String,
    minLevel: fromLogLevel(json['minLevel']),
    maxLevel: fromLogLevel(json['maxLevel']),
    level: fromLogLevel(json['level']),
    isFinal: json['final'] as bool? ?? false,
    isEnabled: json['enabled'] as bool? ?? true,
    ruleName: json['ruleName'] as String?,
    finalMinLevel: fromLogLevel(json['finalMinLevel']),
    writeTo: json['writeTo'] as String,
    levels: fromLogLevelList(json['levels']),
  );
}

Map<String, dynamic> _$RuleToJson(Rule instance) => <String, dynamic>{
      'name': instance.loggerName,
      'minLevel': toLogLevel(instance.minLevel),
      'maxLevel': toLogLevel(instance.maxLevel),
      'level': toLogLevel(instance.level),
      'levels': toLogLevelList(instance.levels),
      'final': instance.isFinal,
      'enabled': instance.isEnabled,
      'ruleName': instance.ruleName,
      'finalMinLevel': toLogLevel(instance.finalMinLevel),
      'writeTo': instance.writeTo,
    };
