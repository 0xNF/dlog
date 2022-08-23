import 'package:flog3/src/configuration/configuration.dart';
import 'package:flog3/src/internal_logger/internal_logger.dart';
import 'package:flog3/src/layout/layout.dart';
import 'package:flog3/src/target/console_target.dart';
import 'package:flog3/src/target/debug_target.dart';
import 'package:flog3/src/target/file_target.dart';
import 'package:flog3/src/target/null_target.dart';
import 'package:flog3/src/target/specs/console_target_spec.dart';
import 'package:flog3/src/target/specs/debug_target_spec.dart';
import 'package:flog3/src/target/specs/file_target_spec.dart';
import 'package:flog3/src/target/specs/null_target_spec.dart';
import 'package:flog3/src/target/specs/target_spec.dart';
import 'package:meta/meta.dart';

abstract class Target {
  final TargetSpec spec;
  final Layout layout;
  bool get isInitialized => _isInitialized;
  bool _isInitialized = false;
  Target({required this.spec, required LogConfiguration config}) : layout = Layout.parseLayout(spec.layout, config);

  void write(LogEventInfo logEvent);

  @mustCallSuper
  void initializeTarget() {
    _isInitialized = true;
    internalLogger.debug("initialized target", eventProperties: {'target': this});
  }

  @mustCallSuper
  void closeTarget() {
    internalLogger.debug("closed target", eventProperties: {'target': this});
  }

  factory Target.fromSpec(TargetSpec spec, LogConfiguration config) {
    switch (spec.type) {
      case ConsoleTargetSpec.kind:
        return ConsoleTarget.fromSpec(spec, config);
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
