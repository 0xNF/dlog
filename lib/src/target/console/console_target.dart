import 'dart:convert';
import 'dart:io';

import 'package:flog3/src/configuration/configuration.dart';
import 'package:flog3/src/internal_logger/internal_logger.dart';
import 'package:flog3/src/target/console/console_target_spec.dart';
import 'package:flog3/src/target/specs/target_spec.dart';
import 'package:flog3/src/target/target_with_layout_header_footer.dart';
import 'package:flog3/src/log_event_info.dart';

class ConsoleTarget extends TargetWithLayoutHeaderAndFooter {
  final Encoding encoding;
  final bool useStdErr;
  final bool detectConsoleAvailable;
  bool _pauseLogging = false;
  Stdout _sink;

  ConsoleTarget({
    required super.spec,
    required super.config,
    required Stdout sink,
    required this.encoding,
    required this.detectConsoleAvailable,
    required this.useStdErr,
  }) : _sink = sink;

  factory ConsoleTarget.fromSpec(TargetSpec spec, LogConfiguration config) {
    final xspec = spec as ConsoleTargetSpec;
    return ConsoleTarget(
      spec: xspec,
      config: config,
      sink: xspec.useStdErr ? stderr : stdout,
      detectConsoleAvailable: xspec.detectConsoleAvailable,
      encoding: xspec.encoding,
      useStdErr: xspec.useStdErr,
    );
  }

  @override
  void initializeTarget() {
    if (detectConsoleAvailable) {
      if ((useStdErr && !stderr.hasTerminal) || (!useStdErr && !stdout.hasTerminal)) {
        internalLogger.info("${this}: Console has been detected as turned off. Disable [DetectConsoleAvailable] to skip detection.");
        _pauseLogging = true;
      }
    } else {
      _sink = useStdErr ? stderr : stdout;
      _sink.encoding = encoding;
    }
    if (header != null) {
      _writeToOutput(header!.render(LogEventInfo.nullEvent));
    }
    super.initializeTarget();
  }

  @override
  void closeTarget() {
    if (footer != null) {
      _writeToOutput(footer!.render(LogEventInfo.nullEvent));
    }
    super.closeTarget();
  }

  @override
  void write(LogEventInfo logEvent) {
    if (_pauseLogging) {
      return;
    }
    String s = super.layout.render(logEvent);
    _writeToOutput(s);
  }

  void _writeToOutput(String s) {
    if (_pauseLogging) {
      return;
    }
    _sink.writeln(s);
  }
}
