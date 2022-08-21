// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfigSettings _$ConfigSettingsFromJson(Map<String, dynamic> json) =>
    ConfigSettings(
      throwExceptions: json['throwExceptions'] as bool? ?? false,
      keepVariablesOnReload: json['keepVariablesOnReload'] as bool? ?? false,
      internalLogLevel: _fromJson(json['internalLogLevel']),
      internalLogToConsole: json['internalLogToConsole'] as bool? ?? true,
      internalLogToFile: json['internalLogToFile'] as String?,
    );

Map<String, dynamic> _$ConfigSettingsToJson(ConfigSettings instance) =>
    <String, dynamic>{
      'throwExceptions': instance.throwExceptions,
      'keepVariablesOnReload': instance.keepVariablesOnReload,
      'internalLogLevel': toLogLevel(instance.internalLogLevel),
      'internalLogToConsole': instance.internalLogToConsole,
      'internalLogToFile': instance.internalLogToFile,
    };
