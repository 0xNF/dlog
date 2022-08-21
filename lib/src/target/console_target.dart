import 'package:flog3/src/configuration/configuration.dart';
import 'package:flog3/src/target/specs/target_spec.dart';
import 'package:flog3/src/target/target.dart';

class ConsoleTarget extends Target {
  ConsoleTarget({required super.spec, required super.config});

  factory ConsoleTarget.fromSpec(TargetSpec spec, LogConfiguration config) {
    return ConsoleTarget(spec: spec, config: config);
  }

  @override
  void write(LogEventInfo logEvent) {
    final s = super.layout.render(logEvent);
    print(s);
  }
}
