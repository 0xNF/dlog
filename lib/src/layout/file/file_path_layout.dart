import 'package:flog3/src/abstractions/irenderable.dart';
import 'package:flog3/src/layout/layout.dart';
import 'package:flog3/src/log_event_info.dart';
import 'package:flog3/src/target/file/file_path_kind.dart';

/// A layout that represents a filePath.

class FilePathLayout implements IRenderable {
  final Layout value;
  final bool cleanupFileName;
  final FilePathKind fileNameKind;
  const FilePathLayout({required this.value, required this.cleanupFileName, required this.fileNameKind});

  Layout getLayout() {
    return value;
  }

  @override
  String render(LogEventInfo logEvent) {
    // TODO: implement render
    throw UnimplementedError();
  }
}
