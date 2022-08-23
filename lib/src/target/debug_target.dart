import 'package:flog3/src/configuration/configuration.dart';
import 'package:flog3/src/target/specs/target_spec.dart';
import 'package:flog3/src/target/target.dart';

class DebugTarget extends Target {
  final List<String> logOutput = [];

  DebugTarget._({required super.spec, required super.config});

  factory DebugTarget.fromSpec(TargetSpec spec, LogConfiguration config) {
    return DebugTarget._(spec: spec, config: config);
  }

  @override
  void write(LogEventInfo logEvent) {
    final s = super.layout.render(logEvent);
    logOutput.add(s);
  }
}
