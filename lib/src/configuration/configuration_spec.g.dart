// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configuration_spec.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfigurationSpec _$ConfigurationSpecFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    requiredKeys: const ['targets', 'rules'],
  );
  return ConfigurationSpec(
    targets: ConfigurationSpec.targetsFromJson(json['targets']),
    rules: (json['rules'] as List<dynamic>)
        .map((e) => Rule.fromJson(e as Map<String, dynamic>))
        .toList(),
    settings: json['settings'] == null
        ? null
        : ConfigSettings.fromJson(json['settings'] as Map<String, dynamic>),
    variables: (json['variables'] as List<dynamic>?)
            ?.map((e) => VariableSpec.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const [],
  );
}

Map<String, dynamic> _$ConfigurationSpecToJson(ConfigurationSpec instance) =>
    <String, dynamic>{
      'targets': ConfigurationSpec.targetsToString(instance.targets),
      'rules': instance.rules,
      'variables': instance.variables,
      'settings': instance.settings,
    };
