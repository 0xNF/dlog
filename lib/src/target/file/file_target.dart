import 'package:flog3/src/configuration/configuration.dart';
import 'package:flog3/src/target/file/icreate_file_parameters.dart';
import 'package:flog3/src/target/specs/target_spec.dart';
import 'package:flog3/src/target/target_with_layout_header_footer.dart';
import 'package:flog3/src/log_event_info.dart';

class FileTarget extends TargetWithLayoutHeaderAndFooter implements ICreateFileParameters {
  FileTarget({required super.spec, required super.config});

  @override
  // TODO: implement bufferSize
  int get bufferSize => throw UnimplementedError();

  @override
  // TODO: implement concurrentWrites
  bool get concurrentWrites => throw UnimplementedError();

  @override
  // TODO: implement createDirs
  bool get createDirs => throw UnimplementedError();

  @override
  // TODO: implement enableFileDelete
  bool get enableFileDelete => throw UnimplementedError();

  @override
  // TODO: implement enableFileDeleteSimpleMonitor
  bool get enableFileDeleteSimpleMonitor => throw UnimplementedError();

  @override
  // TODO: implement fileOpenRetryCount
  Duration get fileOpenRetryCount => throw UnimplementedError();

  @override
  // TODO: implement fileOpenRetryDelay
  int get fileOpenRetryDelay => throw UnimplementedError();

  @override
  // TODO: implement forceManaged
  bool get forceManaged => throw UnimplementedError();

  @override
  // TODO: implement isArchivingEnabled
  bool get isArchivingEnabled => throw UnimplementedError();

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
    final s = super.layout.render(logEvent);
    _writeToOutput(s);
  }

  void _writeToOutput(String s) {
    print(s);
  }
}
