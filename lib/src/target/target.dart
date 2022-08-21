import 'package:flog3/src/configuration/configuration.dart';
import 'package:flog3/src/layout/layout.dart';
import 'package:flog3/src/target/console_target.dart';
import 'package:flog3/src/target/file_target.dart';
import 'package:flog3/src/target/null_target.dart';
import 'package:flog3/src/target/specs/console_target_spec.dart';
import 'package:flog3/src/target/specs/file_target_spec.dart';
import 'package:flog3/src/target/specs/null_target_spec.dart';
import 'package:flog3/src/target/specs/target_spec.dart';

abstract class Target {
  final TargetSpec spec;
  final Layout layout;
  Target({required this.spec, required LogConfiguration config}) : layout = Layout.parseLayout(spec.layout, config);

  void write(LogEventInfo logEvent);

  factory Target.fromSpec(TargetSpec spec, LogConfiguration config) {
    switch (spec.type) {
      case ConsoleTargetSpec.kind:
        return ConsoleTarget.fromSpec(spec, config);
      case FileTargetSpec.kind:
        return FileTarget.fromSpec(spec, config);
      case NullTargetSpec.kind:
      default:
        return NullTarget(spec: spec, config: config);
    }
  }
}
