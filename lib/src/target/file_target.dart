import 'package:flog3/src/configuration/configuration.dart';
import 'package:flog3/src/target/specs/target_spec.dart';
import 'package:flog3/src/target/target.dart';

class FileTarget extends Target {
  FileTarget({required super.spec, required super.config});

  factory FileTarget.fromSpec(TargetSpec spec, LogConfiguration config) {
    return FileTarget(spec: spec, config: config);
  }

  @override
  void initializeTarget() {
    // if (detectConsoleAvailable) {
    //   if ((useStdErr && !stderr.hasTerminal) || (!useStdErr && !stdout.hasTerminal)) {
    //     internalLogger.info("${this}: Console has been detected as turned off. Disable DetectConsoleAvailable to skip detection. Reason: {1}");
    //   }
    // } else {
    //   _sink = useStdErr ? stderr : stdout;
    // }
    super.initializeTarget();
  }

  @override
  void closeTarget() {
    super.closeTarget();
  }

  @override
  void write(LogEventInfo logEvent) {
    final s = super.layout.render(logEvent);
    print(s);
  }
}
