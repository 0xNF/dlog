import 'dart:convert';

import 'package:dart_ilogger/dart_ilogger.dart';

const ILogger internalLogger = _InternalLogger();

class _InternalLogger implements ILogger {
  static const _name = "FlogInternalLogger";

  const _InternalLogger();

  @override
  void debug(message, {Exception? exception, Map<String, dynamic>? eventProperties}) {
    log(LogLevel.debug, message, exception: exception, eventProperties: eventProperties);
  }

  @override
  void error(message, {Exception? exception, Map<String, dynamic>? eventProperties}) {
    log(LogLevel.error, message, exception: exception, eventProperties: eventProperties);
  }

  @override
  void fatal(message, {Exception? exception, Map<String, dynamic>? eventProperties}) {
    log(LogLevel.error, message, exception: exception, eventProperties: eventProperties);
  }

  @override
  void info(message, {Exception? exception, Map<String, dynamic>? eventProperties}) {
    log(LogLevel.info, message, exception: exception, eventProperties: eventProperties);
  }

  @override
  bool get isDebugEnabled => true;
  @override
  bool isEnabled(LogLevel level) {
    return true;
  }

  @override
  bool get isErrorEnabled => true;
  @override
  bool get isFatalEnabled => true;

  @override
  bool get isInfoEnabled => true;

  @override
  bool get isTraceEnabled => true;

  @override
  bool get isWarnEnabled => true;

  @override
  void log(LogLevel level, message, {Exception? exception, Map<String, dynamic>? eventProperties}) {
    String err = "";
    if (exception != null) {
      err = "| {exception: $exception}";
    }
    String eprops = "";
    if (eventProperties != null) {
      eprops = "| ${JsonEncoder().convert(eventProperties)}";
    }
    print("[${DateTime.now()}] [$name] [${level.name}] $message$err$eprops");
  }

  @override
  String get name => _name;

  @override
  Stream<LoggerReconfigured> onLoggerReconfigured() {
    // TODO: implement onLoggerReconfigured
    throw UnimplementedError();
  }

  @override
  void swallow(Function() action) {
    // TODO: implement swallow
  }

  @override
  Future<void> swallowAsync(Function() action) async {
    // TODO: implement swallowAsync
  }

  @override
  T? swallowResult<T>(T? Function() action, T? fallbackValue) {
    // TODO: implement swallowResult
    return fallbackValue;
  }

  @override
  Future<T?> swallowResultAsync<T>(Future<T?> Function() action, T? fallbackValue) async {
    // TODO: implement swallowResultAsync
    return fallbackValue;
  }

  @override
  void trace(message, {Exception? exception, Map<String, dynamic>? eventProperties}) {
    log(LogLevel.trace, message, exception: exception, eventProperties: eventProperties);
  }

  @override
  void warn(message, {Exception? exception, Map<String, dynamic>? eventProperties}) {
    log(LogLevel.warn, message, exception: exception, eventProperties: eventProperties);
  }
}
