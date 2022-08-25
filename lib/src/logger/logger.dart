import 'package:dart_ilogger/dart_ilogger.dart';
import 'package:flog3/src/exception/flog_exception.dart';
import 'package:flog3/src/internal_logger/internal_logger.dart';
import 'package:flog3/src/rule/rule.dart';
import 'package:collection/collection.dart';
import 'package:flog3/src/log_event_info.dart';
import 'package:flog3/src/target/target.dart';

class FLogger implements ILogger {
  List<Rule> get rules => _rules; //List.unmodifiable(_rules);
  late final List<Rule> _rules;
  List<Target> get targets => _targets; // List.unmodifiable(_targets);
  late final List<Target> _targets;
  FLogger(String name, List<Rule> rules, List<Target> targets) {
    _name = name;
    for (final r in rules) {
      /* set Single Level */
      if (r.level != null) {
        if (r.level == LogLevel.off) {
          _isTraceEnabled = false;
          _isDebugEnabled = false;
          _isInfoEnabled = false;
          _isWarnEnabled = false;
          _isErrorEnabled = false;
          _isFatalEnabled = false;
        } else if (r.level == LogLevel.trace) {
          _isTraceEnabled = true;
          _isDebugEnabled = false;
          _isInfoEnabled = false;
          _isWarnEnabled = false;
          _isErrorEnabled = false;
          _isFatalEnabled = false;
        } else if (r.level == LogLevel.debug) {
          _isTraceEnabled = false;
          _isDebugEnabled = true;
          _isInfoEnabled = false;
          _isWarnEnabled = false;
          _isErrorEnabled = false;
          _isFatalEnabled = false;
        } else if (r.level == LogLevel.info) {
          _isTraceEnabled = false;
          _isDebugEnabled = false;
          _isInfoEnabled = true;
          _isWarnEnabled = false;
          _isErrorEnabled = false;
          _isFatalEnabled = false;
        } else if (r.level == LogLevel.warn) {
          _isTraceEnabled = false;
          _isDebugEnabled = false;
          _isInfoEnabled = false;
          _isWarnEnabled = true;
          _isErrorEnabled = false;
          _isFatalEnabled = false;
        } else if (r.level == LogLevel.error) {
          _isTraceEnabled = false;
          _isDebugEnabled = false;
          _isInfoEnabled = false;
          _isWarnEnabled = false;
          _isErrorEnabled = true;
          _isFatalEnabled = false;
        } else if (r.level == LogLevel.fatal) {
          _isTraceEnabled = false;
          _isDebugEnabled = false;
          _isInfoEnabled = false;
          _isWarnEnabled = false;
          _isErrorEnabled = false;
          _isFatalEnabled = true;
        }
      }
      /* Or, set specific levels */
      else if (r.levels != null) {
        for (final level in r.levels!) {
          if (level == LogLevel.off) {
            _isTraceEnabled = false;
            _isDebugEnabled = false;
            _isInfoEnabled = false;
            _isWarnEnabled = false;
            _isErrorEnabled = false;
            _isFatalEnabled = false;
          } else if (level == LogLevel.trace) {
            _isTraceEnabled = true;
          } else if (level == LogLevel.debug) {
            _isDebugEnabled = true;
          } else if (level == LogLevel.info) {
            _isInfoEnabled = true;
          } else if (level == LogLevel.warn) {
            _isWarnEnabled = true;
          } else if (level == LogLevel.error) {
            _isErrorEnabled = true;
          } else if (level == LogLevel.fatal) {
            _isFatalEnabled = true;
          }
        }
      }
      /* or, set min amd max level */
      else {
        /* set min */
        if (r.minLevel != null) {
          if (r.minLevel == LogLevel.off || r.minLevel == LogLevel.trace) {
            _isTraceEnabled = true;
            _isDebugEnabled = true;
            _isInfoEnabled = true;
            _isWarnEnabled = true;
            _isErrorEnabled = true;
            _isFatalEnabled = true;
          } else if (r.minLevel == LogLevel.debug) {
            _isTraceEnabled = false;
            _isDebugEnabled = true;
            _isInfoEnabled = true;
            _isWarnEnabled = true;
            _isErrorEnabled = true;
            _isFatalEnabled = true;
          } else if (r.minLevel == LogLevel.info) {
            _isTraceEnabled = false;
            _isDebugEnabled = false;
            _isInfoEnabled = true;
            _isWarnEnabled = true;
            _isErrorEnabled = true;
            _isFatalEnabled = true;
          } else if (r.minLevel == LogLevel.warn) {
            _isTraceEnabled = false;
            _isDebugEnabled = false;
            _isInfoEnabled = false;
            _isWarnEnabled = true;
            _isErrorEnabled = true;
            _isFatalEnabled = true;
          } else if (r.minLevel == LogLevel.error) {
            _isTraceEnabled = false;
            _isDebugEnabled = false;
            _isInfoEnabled = false;
            _isWarnEnabled = false;
            _isErrorEnabled = true;
            _isFatalEnabled = true;
          } else if (r.minLevel == LogLevel.fatal) {
            _isTraceEnabled = false;
            _isDebugEnabled = false;
            _isInfoEnabled = false;
            _isWarnEnabled = false;
            _isErrorEnabled = false;
            _isFatalEnabled = true;
          }
        } else if (r.minLevel != null) {
          if (r.minLevel == LogLevel.off || r.minLevel == LogLevel.trace) {
            _isTraceEnabled = true;
            _isDebugEnabled = true;
            _isInfoEnabled = true;
            _isWarnEnabled = true;
            _isErrorEnabled = true;
            _isFatalEnabled = true;
          } else if (r.minLevel == LogLevel.debug) {
            _isDebugEnabled = true;
            _isInfoEnabled = true;
            _isWarnEnabled = true;
            _isErrorEnabled = true;
            _isFatalEnabled = true;
          } else if (r.minLevel == LogLevel.info) {
            _isInfoEnabled = true;
            _isWarnEnabled = true;
            _isErrorEnabled = true;
            _isFatalEnabled = true;
          } else if (r.minLevel == LogLevel.warn) {
            _isWarnEnabled = true;
            _isErrorEnabled = true;
            _isFatalEnabled = true;
          } else if (r.minLevel == LogLevel.error) {
            _isErrorEnabled = true;
            _isFatalEnabled = true;
          } else if (r.minLevel == LogLevel.fatal) {
            _isFatalEnabled = true;
          }
        } else {
          _isTraceEnabled = true;
          _isDebugEnabled = true;
          _isInfoEnabled = true;
          _isWarnEnabled = true;
          _isErrorEnabled = true;
          _isFatalEnabled = true;
        }

        /* set max level */
        if (r.maxLevel != null) {
          if (r.maxLevel == LogLevel.off) {
            _isTraceEnabled = false;
            _isDebugEnabled = false;
            _isInfoEnabled = false;
            _isWarnEnabled = false;
            _isErrorEnabled = false;
            _isFatalEnabled = false;
          } else if (r.maxLevel == LogLevel.trace) {
            _isTraceEnabled = true;
            _isDebugEnabled = false;
            _isInfoEnabled = false;
            _isWarnEnabled = false;
            _isErrorEnabled = false;
            _isFatalEnabled = false;
          } else if (r.maxLevel == LogLevel.debug) {
            _isTraceEnabled = true;
            _isDebugEnabled = true;
            _isInfoEnabled = false;
            _isWarnEnabled = false;
            _isErrorEnabled = false;
            _isFatalEnabled = false;
          } else if (r.maxLevel == LogLevel.info) {
            _isTraceEnabled = true;
            _isDebugEnabled = true;
            _isInfoEnabled = true;
            _isWarnEnabled = false;
            _isErrorEnabled = false;
            _isFatalEnabled = false;
          } else if (r.maxLevel == LogLevel.warn) {
            _isTraceEnabled = true;
            _isDebugEnabled = true;
            _isInfoEnabled = true;
            _isWarnEnabled = true;
            _isErrorEnabled = false;
            _isFatalEnabled = false;
          } else if (r.maxLevel == LogLevel.error) {
            _isTraceEnabled = true;
            _isDebugEnabled = true;
            _isInfoEnabled = true;
            _isWarnEnabled = true;
            _isErrorEnabled = true;
            _isFatalEnabled = false;
          } else if (r.maxLevel == LogLevel.fatal) {
            _isTraceEnabled = true;
            _isDebugEnabled = true;
            _isInfoEnabled = true;
            _isWarnEnabled = true;
            _isErrorEnabled = true;
            _isFatalEnabled = true;
          }
        }
      }
      if (r.isFinal) {
        break;
      }
    }

    _rules = rules.toList();
    _targets = targets.toList();
  }

  @override
  void trace(message, {Exception? exception, Map<String, dynamic>? eventProperties}) {
    log(LogLevel.trace, message, exception: exception, eventProperties: eventProperties);
  }

  @override
  void debug(message, {Exception? exception, Map<String, dynamic>? eventProperties}) {
    log(LogLevel.debug, message, exception: exception, eventProperties: eventProperties);
  }

  @override
  void info(message, {Exception? exception, Map<String, dynamic>? eventProperties}) {
    log(LogLevel.info, message, exception: exception, eventProperties: eventProperties);
  }

  @override
  void warn(message, {Exception? exception, Map<String, dynamic>? eventProperties}) {
    log(LogLevel.warn, message, exception: exception, eventProperties: eventProperties);
  }

  @override
  void error(message, {Exception? exception, Map<String, dynamic>? eventProperties}) {
    log(LogLevel.error, message, exception: exception, eventProperties: eventProperties);
  }

  @override
  void fatal(message, {Exception? exception, Map<String, dynamic>? eventProperties}) {
    log(LogLevel.fatal, message, exception: exception, eventProperties: eventProperties);
  }

  @override
  bool get isDebugEnabled {
    _isDebugEnabled ??= _rules.any((element) => element.canWrite(LogLevel.debug));
    return _isDebugEnabled!;
  }

  bool? _isDebugEnabled;

  @override
  bool get isErrorEnabled {
    _isErrorEnabled ??= _rules.any((element) => element.canWrite(LogLevel.error));
    return _isErrorEnabled!;
  }

  bool? _isErrorEnabled;

  @override
  bool get isFatalEnabled {
    _isFatalEnabled ??= _rules.any((element) => element.canWrite(LogLevel.fatal));
    return _isFatalEnabled!;
  }

  bool? _isFatalEnabled;

  @override
  bool get isInfoEnabled {
    _isInfoEnabled ??= _rules.any((element) => element.canWrite(LogLevel.info));
    return _isInfoEnabled!;
  }

  bool? _isInfoEnabled;

  @override
  bool get isTraceEnabled {
    _isTraceEnabled ??= _rules.any((element) => element.canWrite(LogLevel.trace));
    return _isTraceEnabled!;
  }

  bool? _isTraceEnabled;

  @override
  bool get isWarnEnabled {
    _isWarnEnabled ??= _rules.any((element) => element.canWrite(LogLevel.warn));
    return _isWarnEnabled!;
  }

  bool? _isWarnEnabled;

  @override
  bool isEnabled(LogLevel level) {
    if (level == LogLevel.trace) {
      return isTraceEnabled;
    } else if (level == LogLevel.debug) {
      return isDebugEnabled;
    } else if (level == LogLevel.info) {
      return isInfoEnabled;
    } else if (level == LogLevel.warn) {
      return isWarnEnabled;
    } else if (level == LogLevel.error) {
      return isErrorEnabled;
    } else if (level == LogLevel.fatal) {
      return isFatalEnabled;
    } else {
      return false;
    }
  }

  @override
  String get name => _name;
  late String _name;

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
  Future<void> swallowAsync(Function() action) {
    // TODO: implement swallowAsync
    throw UnimplementedError();
  }

  @override
  T? swallowResult<T>(T? Function() action, T? fallbackValue) {
    // TODO: implement swallowResult
    throw UnimplementedError();
  }

  @override
  Future<T?> swallowResultAsync<T>(Future<T?> Function() action, T? fallbackValue) {
    // TODO: implement swallowResultAsync
    throw UnimplementedError();
  }

  @override
  void log(LogLevel level, message, {Exception? exception, Map<String, dynamic>? eventProperties}) {
    if (isEnabled(level)) {
      final LogEventInfo info = LogEventInfo(
        level: level,
        loggerName: name,
        timeStamp: DateTime.now(),
        stackTrace: StackTrace.current,
        exception: exception,
        eventProperties: eventProperties ?? const {},
        messageFormatter: null,
        message: message,
      );
      Set<String> writtenTargets = {};
      for (final r in _rules) {
        if (r.canWrite(level)) {
          final t = _targets.firstWhereOrNull((element) => element.spec.name == r.writeTo);
          if (t == null) {
            internalLogger.error("Failed to write for target, not such target name existsed", eventProperties: {'writeTo': r.writeTo});
            throw FLogException(message: "No such target: ${r.writeTo}");
          }
          if (writtenTargets.contains(t.spec.name)) {
            internalLogger.trace('target already written to for this log event, skipping', eventProperties: {'writeTo': t.spec.name});
            return;
          }
          try {
            t.write(info);
            /* mark off this target so we don't double-write */
            writtenTargets.add(t.spec.name);
          } on Exception catch (e) {
            internalLogger.error('Failed to write to target', exception: e);
            if (mustRethrowExceptionImmediately(e)) {
              rethrow;
            }
          }
        }
      }
    }
  }
}
