import 'dart:convert';

import 'package:dart_ilogger/dart_ilogger.dart';
import 'package:flog3/src/target/target.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rule.g.dart';

@JsonSerializable()
class Rule {
  /// Match logger-name of the Logger-object - may include wildcard characters (* and ?)
  @JsonKey(name: "name", required: true)
  final String loggerName;

  /// minimal level to log
  @JsonKey(name: "minLevel", toJson: toLogLevel, fromJson: fromLogLevel, defaultValue: null)
  final LogLevel? minLevel;

  /// maximum level to log
  @JsonKey(name: "maxLevel", toJson: toLogLevel, fromJson: fromLogLevel, defaultValue: null)
  final LogLevel? maxLevel;

  /// single level to log
  @JsonKey(name: "level", toJson: toLogLevel, fromJson: fromLogLevel, defaultValue: null)
  final LogLevel? level;

  @JsonKey(name: "levels", fromJson: fromLogLevelList, toJson: toLogLevelList)
  final List<LogLevel>? levels;

  // /// list of levels to log
  // @JsonKey(name: "levels", required: false, toJson: toLogLevel, fromJson: fromLogLevel)
  // final List<LogLevel>? levels;

  /// no rules are processed after a final rule matche
  @JsonKey(name: "final", defaultValue: false)
  final bool isFinal;

  /// set to false to disable the rule without deleting it
  @JsonKey(name: "enabled", defaultValue: true)
  final bool isEnabled;

  /// rule identifier to allow rule lookup with Configuration.FindRuleByName and Configuration.RemoveRuleByName
  @JsonKey(name: "ruleName")
  final String? ruleName;

  /// Loggers matching will be restricted to specified minimum level for following rules.
  @JsonKey(name: "finalMinLevel", toJson: toLogLevel, fromJson: fromLogLevel, defaultValue: null)
  final LogLevel? finalMinLevel;

  @JsonKey(name: "writeTo", required: true)
  final String writeTo;

  @JsonKey(ignore: true)
  final Target? target;

  const Rule({
    required this.loggerName,
    this.minLevel,
    this.maxLevel,
    this.level,
    this.isFinal = false,
    this.isEnabled = true,
    this.ruleName,
    this.finalMinLevel,
    required this.writeTo,
    this.levels,
    this.target,
  });

  bool canWrite(LogLevel lvl) {
    if (!isEnabled) {
      return false;
    } else if (lvl == LogLevel.off) {
      return false;
    } else if (level != null && level == lvl) {
      return true;
    } else if (levels != null) {
      return levels!.contains(lvl);
    } else {
      final mnLevel = minLevel ?? LogLevel.minLevel;
      final mxLevel = maxLevel ?? LogLevel.maxLevel;
      return lvl.ordinal >= mnLevel.ordinal && lvl.ordinal <= mxLevel.ordinal;
    }
  }

  Map<String, dynamic> toJson() => _$RuleToJson(this);
  factory Rule.fromJson(Map<String, dynamic> json) => _$RuleFromJson(json);
}

String? toLogLevel(dynamic obj) {
  if (obj is LogLevel) {
    return obj.name;
  }
  return null;
}

String? toLogLevelList(dynamic obj) {
  if (obj is List<String>) {
    List<LogLevel> levels = [];
    for (final s in obj) {
      final ll = LogLevel.fromString(s);
      if (ll != null) {
        levels.add(ll);
      }
    }
    return JsonEncoder().convert(levels);
  }
  return null;
}

LogLevel? fromLogLevel(dynamic json) {
  if (json == null) {
    return null;
  }
  return LogLevel.fromString(json);
}

List<LogLevel>? fromLogLevelList(dynamic json) {
  if (json == null) {
    return null;
  }
  final lst = <LogLevel>[];
  if (json is List) {
    final d = json.map((e) => e as String);
    for (final obj in d) {
      final ll = fromLogLevel(obj);
      if (ll != null) {
        lst.add(ll);
      }
    }
  }
}
