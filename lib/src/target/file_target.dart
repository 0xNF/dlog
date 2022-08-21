import 'package:flog3/src/configuration/configuration.dart';
import 'package:flog3/src/target/specs/target_spec.dart';
import 'package:flog3/src/target/target.dart';

class FileTarget extends Target {
  FileTarget({required super.spec, required super.config});

  factory FileTarget.fromSpec(TargetSpec spec, LogConfiguration config) {
    return FileTarget(spec: spec, config: config);
  }

  @override
  void write(LogEventInfo logEvent) {
    final s = super.layout.render(logEvent);
    print(s);
  }
}
