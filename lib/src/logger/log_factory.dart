import 'package:dart_ilogger/dart_ilogger.dart';
import 'package:flog3/src/configuration/configuration.dart';
import 'package:flog3/src/exception/flog_exception.dart';
import 'package:flog3/src/internal_logger/internal_logger.dart';
import 'package:flog3/src/logger/logger.dart';
import 'package:flog3/src/rule/rule.dart';
import 'package:flog3/src/target/target.dart';
import 'package:flog3/src/utils.dart';
import 'package:collection/collection.dart';

class LogFactory {
  static final Map<String, ILogger> _logCache = <String, ILogger>{};
  static LogConfiguration? get configuration => _configuration;
  static LogConfiguration? _configuration;
  static late final bool throwExceptions;

  /// Gets an [ILogger] for use in your application.
  ///
  /// If you do not supply a name, a name will be given by attempting to determine
  /// the file name of the function the logger was created in.
  static ILogger getLogger([String? name]) {
    final n = name ?? _getAnonymousLoggerName();
    ILogger? l = _logCache[name];
    if (l == null) {
      internalLogger.debug("Logger didn't exist, creating one now", eventProperties: {'loggerName': n});
      l = _makeLogger(n);
      _logCache[n] = l;
    }
    return l;
  }

  static String _getAnonymousLoggerName() {
    final st = StackTrace.current;
    final s = st.relevantTraceLines(1).firstOrNull;
    if (s == null || s.isEmpty) {
      return "<anonymous logger>";
    }
    return st.getFileName(s);
  }

  static ILogger _makeLogger(String name) {
    /* match rules to reify the Logger */
    if (configuration == null) {
      internalLogger.fatal("Cannot make logger, no configuration was set");
      throw Exception("No configuration set");
    }
    /* get dynamic rules */
    List<Rule> rules = [];
    for (int i = 0; i < configuration!.rules.length; i++) {
      final rule = configuration!.rules[i];
      if (rule.isEnabled && _matchRuleToTarget(rule.loggerName, name)) {
        rules.add(rule);
        if (rule.isFinal) {
          internalLogger.debug("Found final rule for logger, will not process any futher rules", eventProperties: {'loggerName': name, 'finalRule': rule.loggerName});
          break;
        }
      }
    }

    /* get dynamic targets */
    Set<Target> targets = {};
    for (int i = 0; i < rules.length; i++) {
      final r = rules[i];
      final matchingTargets = configuration!.targets.where((element) => _matchRuleToTarget(r.loggerName, element.spec.name));
      targets.addAll(matchingTargets);
    }
    return FLogger(name, rules, targets.toList());
  }

  static void initialize(LogConfiguration config) {
    _logCache.clear();
    _configuration = config;
    throwExceptions = config.settings.throwExceptions;
    internalLogger.info("Successfully initailized LogFactory");
  }

  static void initializeWithFile(String filename) {
    internalLogger.info("Initializing LogFactory with filename", eventProperties: {'filename': filename});
    try {
      final config = LogConfiguration.loadFromFile(filename);
      initialize(config);
    } on Exception catch (e) {
      internalLogger.error('Failed to initialize LogFactory', exception: e);
      if (mustRethrowExceptionImmediately(e)) {
        rethrow;
      }
    }
  }

  static void reload() {}

  static bool _matchRuleToTarget(String ruleName, String loggerName) {
    /* nlog filters use '*' for wildcard, so we escape periods and replace stars */
    /**
     * star(*) = 'any sequence of symbols' aka (.*)
     * question(?) = 'any single symbol' aka (.)
     */
    final expression = ruleName.replaceAll('.', r'\.').replaceAll('*', '.*').replaceAll('?', '.');
    final r = RegExp(expression);
    return r.hasMatch(loggerName);
  }
}
