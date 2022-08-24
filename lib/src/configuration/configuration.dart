import 'dart:convert';
import 'dart:io';

import 'package:dart_ilogger/dart_ilogger.dart';
import 'package:flog3/src/configuration/config_settings.dart';
import 'package:flog3/src/configuration/configuration_spec.dart';
import 'package:flog3/src/internal_logger/internal_logger.dart';
import 'package:flog3/src/layout/layout.dart';
import 'package:flog3/src/log_event_info.dart';
import 'package:flog3/src/rule/rule.dart';
import 'package:flog3/src/target/target.dart';
import 'package:flog3/src/variable/variable.dart';

class LogConfiguration {
  late final Set<Layout> layouts;
  late final List<Target> targets;
  final List<Rule> rules;
  final List<Variable> variables;
  final ConfigSettings settings;

  static late LogConfiguration defaultt;

  LogConfiguration({
    required this.rules,
    required this.variables,
    required this.settings,
  });

  factory LogConfiguration.loadFromFile(String filename) {
    internalLogger.info("Loading new config from file", eventProperties: {'filename': filename});
    try {
      final f = File(filename);
      final s = f.readAsStringSync();
      final obj = const JsonDecoder().convert(s) as Map<String, dynamic>;
      final spec = ConfigurationSpec.fromJson(obj);
      final conf = LogConfiguration.loadFromSpec(spec);
      defaultt = conf;
      return conf;
    } on Exception catch (e) {
      internalLogger.error("Failed to load config from file", exception: e);
      rethrow;
    }
  }

  factory LogConfiguration.loadFromSpec(ConfigurationSpec spec) {
    internalLogger.info("Loading new config from spec");
    try {
      final conf = LogConfiguration(
        rules: spec.rules,
        variables: spec.variables.map((e) => Variable.fromSpec(e)).toList(),
        settings: spec.settings,
      );
      conf.targets = spec.targets.map((e) => Target.fromSpec(e, conf)).toList();

      conf._initializeAll(firstInitializeAll: true);

      defaultt = conf;
      return conf;
    } on Exception catch (e) {
      internalLogger.error("Failed to load config from spec", exception: e);
      rethrow;
    }
  }

  void _initializeAll({bool firstInitializeAll = false}) {
    if (firstInitializeAll && settings.throwExceptions) {
      internalLogger.info("LogManager.throwExceptions = true can crash your application. Use only for unit-testing and last resort troubleshooting");
    }

    _validateConfig();

    if (firstInitializeAll && targets.isNotEmpty) {
      _checkUnusedTargets();
    }

    for (final t in targets) {
      internalLogger.debug("initializing target", eventProperties: {'target': t.spec.name});
      t.initializeTarget();
    }
    for (final l in rules) {
      // l.t
    }
    // for(final l in ) // TODO(nf): place layouts in central list, have all targets reference thsoe const layouts; init them here
  }

  void _validateConfig() {}

  void _checkUnusedTargets() {}
}

abstract class MessageFormatter {
  static String formatDefault(LogEventInfo logEvent) {
    return "";
  }
}
