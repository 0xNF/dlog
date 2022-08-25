import 'package:flog3/src/configuration/config_settings.dart';
import 'package:flog3/src/rule/rule.dart';
import 'package:flog3/src/target/specs/colored_console_target_spec.dart';
import 'package:flog3/src/target/specs/console_target_spec.dart';
import 'package:flog3/src/target/specs/debug_target_spec.dart';
import 'package:flog3/src/target/specs/file_target_spec.dart';
import 'package:flog3/src/target/specs/target_spec.dart';
import 'package:flog3/src/target/specs/target_type.dart';
import 'package:flog3/src/variable/variable_spec.dart';
import 'package:json_annotation/json_annotation.dart';

part 'configuration_spec.g.dart';

@JsonSerializable()
class ConfigurationSpec {
  @JsonKey(name: "targets", required: true, toJson: targetsToString, fromJson: targetsFromJson)
  final List<TargetSpec> targets;

  @JsonKey(name: "rules", required: true)
  final List<Rule> rules;

  @JsonKey(name: "variables")
  final List<VariableSpec> variables;

  @JsonKey(name: "settings")
  final ConfigSettings settings;

  ConfigurationSpec({
    required this.targets,
    required this.rules,
    ConfigSettings? settings,
    this.variables = const [],
  }) : settings = settings ?? ConfigSettings();

  static String targetsToString(List<TargetSpec> targets) {
    List<String> lst = [];
    for (dynamic t in targets) {
      String s = t.toJson();
      lst.add(s);
    }
    return '[${lst.join(',')}]';
  }

  static List<TargetSpec> targetsFromJson(dynamic obj) {
    final lst = <TargetSpec>[];
    if (obj is List<dynamic>) {
      final m = obj.map((e) => e as Map<String, dynamic>);
      for (final d in m) {
        final tType = targetTypefromString(d["type"]);
        switch (tType) {
          case FileTargetSpec.kind:
            lst.add(FileTargetSpec.fromJson(d));
            break;
          case ConsoleTargetSpec.kind:
            lst.add(ConsoleTargetSpec.fromJson(d));
            break;
          case ColoredConsoleTargetSpec.kind:
            lst.add(ColoredConsoleTargetSpec.fromJson(d));
            break;
          case DebugTargetSpec.kind:
            lst.add(DebugTargetSpec.fromJson(d));
            break;
          default:
            break;
        }
      }
    }

    return lst;
  }

  Map<String, dynamic> toJson() => _$ConfigurationSpecToJson(this);
  factory ConfigurationSpec.fromJson(Map<String, dynamic> json) => _$ConfigurationSpecFromJson(json);
}
