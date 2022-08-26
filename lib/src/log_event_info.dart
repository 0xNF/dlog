import 'dart:convert';

import 'package:dart_ilogger/dart_ilogger.dart';
import 'package:flog3/src/configuration/configuration.dart';
import 'package:flog3/src/exception/flog_exception.dart';
import 'package:flog3/src/internal_logger/internal_logger.dart';

class LogEventInfo {
  static int _globalSequenceId = 0;

  static final DateTime zeroDate = DateTime.now();

  static final LogEventInfo nullEvent = LogEventInfo.createNullEvent();

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
      _formattedMessage = _formatMessage();
    } on Exception catch (e) {
      internalLogger.error('Failed to calculate formatetd message', exception: e);
      if (mustRethrowExceptionImmediately(e)) {
        rethrow;
      }
      _formattedMessage = "";
    }
  }

  String _formatMessage() {
    if (eventProperties.isEmpty) {
      return message;
    }

    String m = message;

    for (final kvp in eventProperties.entries) {
      String vl;
      if (kvp.value is String) {
        vl = kvp.value as String;
      } else {
        vl = const JsonEncoder().convert(kvp.value);
      }

      m = m.replaceAll('{${kvp.key}}', vl);
    }
    return m;
  }

  void appendFormattedMessage(StringBuffer target) {
    target.write(formattedMessage);
  }

  @override
  String toString() {
    return "Log Event: Logger='$loggerName' Level=$level Message='$formattedMessage'";
  }
}
