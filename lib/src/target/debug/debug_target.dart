import 'package:flog3/src/configuration/configuration.dart';
import 'package:flog3/src/target/specs/target_spec.dart';
import 'package:flog3/src/target/target_with_layout_header_footer.dart';
import 'package:flog3/src/log_event_info.dart';

class DebugTarget extends TargetWithLayoutHeaderAndFooter {
  final List<String> logOutput = [];

  DebugTarget._({required super.spec, required super.config});

  factory DebugTarget.fromSpec(TargetSpec spec, LogConfiguration config) {
    return DebugTarget._(spec: spec, config: config);
  }

  @override
  void initializeTarget() {
    logOutput.clear();
    if (header != null) {
      layout.initialize(config);
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
    logOutput.add(s);
  }
}
