import 'package:flog3/src/target/file/file_archive_numbering_mode.dart';
import 'package:flog3/src/target/file/ifile_archive_mode.dart';

class FileArchiveModeFactory {
  static IFileArchiveMode createArchiveStyle(
    String archiveFilePath,
    ArchiveNumberingMode archiveNumbering,
    String dateFormat,
    bool customArchiveFileName,
    bool archiveCleanupEnabled,
  ) {
    // TODO(nf): implement me
    throw UnimplementedError();
  }

  static IFileArchiveMode createStrictFileArchiveMode(ArchiveNumberingMode archiveNumbering, String dateFormat, bool archiveCleanupEnabled) {
    // TODO9(nf): Implement me
    throw UnimplementedError();
  }

  /// Determines if the file name as [String] contains a numeric pattern i.e. `{#}` in it.
  ///
  /// Example:
  ///     trace{#}.log        Contains the numeric pattern.
  ///     trace{###}.log      Contains the numeric pattern.
  ///     trace{#X#}.log      Contains the numeric pattern (See remarks).
  ///     trace.log           Does not contain the pattern.
  ///
  /// Occasionally, this method can identify the existence of the {#} pattern incorrectly
  static bool containsFileNamePattern(String fileName) {
    int startingIndex = fileName.indexOf("{#");
    int endingIndex = fileName.indexOf("#}");

    return (startingIndex != -1 && endingIndex != -1 && startingIndex < endingIndex);
  }
}
