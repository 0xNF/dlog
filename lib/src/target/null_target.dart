import 'package:flog3/src/configuration/configuration.dart';
import 'package:flog3/src/target/specs/target_spec.dart';
import 'package:flog3/src/target/target.dart';
import 'package:flog3/src/log_event_info.dart';


class NullTarget extends Target {
  NullTarget._({required super.spec, required super.config});

  factory NullTarget.fromSpec(TargetSpec spec, LogConfiguration config) {
    return NullTarget._(spec: spec, config: config);
  }

  @override
  void write(LogEventInfo logEvent) {
    /* intentionally blank because null target */
  }
}
