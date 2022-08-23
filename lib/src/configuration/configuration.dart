import 'dart:convert';
import 'dart:io';

import 'package:dart_ilogger/dart_ilogger.dart';
import 'package:flog3/src/configuration/config_settings.dart';
import 'package:flog3/src/configuration/configuration_spec.dart';
import 'package:flog3/src/internal_logger/internal_logger.dart';
import 'package:flog3/src/rule/rule.dart';
import 'package:flog3/src/target/target.dart';
import 'package:flog3/src/variable/variable.dart';

class LogConfiguration {
  late final List<Target> targets;
  final List<Rule> rules;
  final List<Variable> variables;
  final ConfigSettings settings;

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
      return LogConfiguration.loadFromSpec(spec);
    } on Exception catch (e) {
      internalLogger.error("Failed to load config from file", exception: e);
      rethrow;
    }
  }

  factory LogConfiguration.loadFromSpec(ConfigurationSpec spec) {
    internalLogger.info("Loading new config from spec");
    try {
      final lc = LogConfiguration(
        rules: spec.rules,
        variables: spec.variables.map((e) => Variable.fromSpec(e)).toList(),
        settings: spec.settings,
      );
      lc.targets = spec.targets.map((e) => Target.fromSpec(e, lc)).toList();
      return lc;
    } on Exception catch (e) {
      internalLogger.error("Failed to load config from spec", exception: e);
      rethrow;
    }
  }
}

abstract class MessageFormatter {
  static String formatDefault(LogEventInfo logEvent) {
    return "";
  }
}

class LogEventInfo {
  static int _globalSequenceId = 0;

  static final DateTime zeroDate = DateTime.now();

  int _sequenceId = 0;
  int get sequenceId {
    if (_sequenceId == 0) {
      // TODO(nf): ensure threadlocked
      _globalSequenceId += 1;
      _sequenceId = _globalSequenceId;
    }
    return _sequenceId;
  }

  final LogLevel level;

  final DateTime timeStamp;

  final StackTrace? stackTrace;

  final Exception? exception;

  final String loggerName;

  final Map<String, dynamic> eventProperties;

  final MessageFormatter? messageFormatter;

  final String message;

  String? _formattedMessage;
  String get formattedMessage {
    if (_formattedMessage == null) {
      _calcFormattedMessage();
    }
    return _formattedMessage!;
  }

  LogEventInfo({
    required this.level,
    required this.loggerName,
    required this.timeStamp,
    required this.stackTrace,
    required this.exception,
    required this.eventProperties,
    required this.messageFormatter,
    required this.message,
  });

  factory LogEventInfo.createNullEvent() {
    return LogEventInfo(
      loggerName: "",
      eventProperties: {},
      exception: null,
      level: LogLevel.off,
      stackTrace: null,
      timeStamp: DateTime.utc(1970, 01, 01),
      messageFormatter: null,
      message: "",
    );
  }

  void _calcFormattedMessage() {
    try {
      _formattedMessage = MessageFormatter.formatDefault(this);
    } on Exception catch (e) {
      // TODO(nf): internal logger
      _formattedMessage = "";
    }
  }

  @override
  String toString() {
    return "Log Event: Logger='$loggerName' Level=$level Message='$formattedMessage'";
  }
}
