import 'package:flog3/src/configuration/configuration.dart';
import 'package:flog3/src/target/specs/target_spec.dart';
import 'package:flog3/src/target/target_with_layout_header_footer.dart';
import 'package:flog3/src/log_event_info.dart';

class FileTarget extends TargetWithLayoutHeaderAndFooter {
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
    if (header != null) {
      _writeToOutput(header!.render(LogEventInfo.createNullEvent()));
    }
    super.initializeTarget();
  }

  @override
  void closeTarget() {
    if (footer != null) {
      _writeToOutput(footer!.render(LogEventInfo.createNullEvent()));
    }
    super.closeTarget();
  }

  @override
  void write(LogEventInfo logEvent) {
    final s = super.layout.render(logEvent);
    _writeToOutput(s);
  }

  void _writeToOutput(String s) {
    print(s);
  }
}
