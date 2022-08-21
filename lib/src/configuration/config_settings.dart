import 'package:dart_ilogger/dart_ilogger.dart';
import 'package:flog3/src/rule/rule.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';

part 'config_settings.g.dart';

@JsonSerializable()
class ConfigSettings {
  /// Whether to throw exceptions instead of swallowing them when possible
  @JsonKey(name: "throwExceptions")
  final bool throwExceptions;

  /// Whether variables should be re-parsed or not on config reload
  @JsonKey(name: "keepVariablesOnReload")
  final bool keepVariablesOnReload;

  /// Minimum log level to log to the internal logger
  @JsonKey(name: "internalLogLevel", fromJson: _fromJson, toJson: toLogLevel)
  final LogLevel internalLogLevel;

  @JsonKey(name: "internalLogToConsole")
  final bool internalLogToConsole;

  @JsonKey(name: "internalLogToFile")
  final String? internalLogToFile;

  ConfigSettings({
    this.throwExceptions = false,
    this.keepVariablesOnReload = false,
    LogLevel? internalLogLevel,
    this.internalLogToConsole = true,
    this.internalLogToFile,
  }) : internalLogLevel = internalLogLevel ?? LogLevel.trace;

  Map<String, dynamic> toJson() => _$ConfigSettingsToJson(this);
  factory ConfigSettings.fromJson(Map<String, dynamic> json) => _$ConfigSettingsFromJson(json);
}

LogLevel _fromJson(dynamic json) {
  if (json == null) {
    throw Exception("Got null for LogLevel");
  }
  if (json is String) {
    final ll = LogLevel.values.firstWhereOrNull((x) => x.name == json);
    if (ll == null) {
      throw Exception("Got invalid LogLevel: $json");
    } else {
      return ll;
    }
  } else {
    throw Exception("Got invalid type for LogLevel: $json");
  }
}
