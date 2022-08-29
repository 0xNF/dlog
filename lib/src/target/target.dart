import 'package:flog3/src/abstractions/isupports_initialize.dart';
import 'package:flog3/src/configuration/configuration.dart';
import 'package:flog3/src/exception/flog_exception.dart';
import 'package:flog3/src/internal_logger/internal_logger.dart';
import 'package:flog3/src/target/colored_console/colored_console_target.dart';
import 'package:flog3/src/target/colored_console/colored_console_target_spec.dart';
import 'package:flog3/src/target/console/console_target.dart';
import 'package:flog3/src/target/console/console_target_spec.dart';
import 'package:flog3/src/target/debug/debug_target.dart';
import 'package:flog3/src/target/debug/debug_target_spec.dart';
import 'package:flog3/src/target/file/file_target.dart';
import 'package:flog3/src/target/file/file_target_spec.dart';
import 'package:flog3/src/target/null_target/null_target.dart';
import 'package:flog3/src/target/null_target/null_target_spec.dart';
import 'package:flog3/src/target/specs/target_spec.dart';
import 'package:flog3/src/log_event_info.dart';
import 'package:meta/meta.dart';

abstract class Target implements ISupportsInitialize {
  final TargetSpec spec;
  bool get isInitialized => _isInitialized;
  bool _isInitialized = false;
  final LogConfiguration config;
  Target({required this.spec, required this.config});

  void write(LogEventInfo logEvent);

  @override
  void initialize(LogConfiguration configuration) {
    final wasInitialized = isInitialized;
    initializeTarget();
    if (wasInitialized) {
      findAllLayouts();
    }
  }

  @override
  void close() {
    try {
      internalLogger.debug("{target}: Closing...", eventProperties: {'target': this});
      closeTarget();
      internalLogger.debug("{target}: Closed", eventProperties: {'target': this});
    } on Exception catch (e) {
      if (mustRethrowExceptionImmediately(e)) {
        rethrow;
      }
    }
  }

  @mustCallSuper
  void initializeTarget() {
    _isInitialized = true;
  }

  @mustCallSuper
  void closeTarget() {
    internalLogger.debug("closed target", eventProperties: {'target': this});
  }

  void findAllLayouts() {}

  factory Target.fromSpec(TargetSpec spec, LogConfiguration config) {
    switch (spec.type) {
      case ConsoleTargetSpec.kind:
        return ConsoleTarget.fromSpec(spec, config);
      case ColoredConsoleTargetSpec.kind:
        return ColoredConsoleTarget.fromSpec(spec, config);
      case FileTargetSpec.kind:
        return FileTarget.fromSpec(spec, config);
      case DebugTargetSpec.kind:
        return DebugTarget.fromSpec(spec, config);
      case NullTargetSpec.kind:
      default:
        return NullTarget.fromSpec(spec, config);
    }
  }
}
