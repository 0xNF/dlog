import 'package:flog3/src/target/file/date_and_sequence_archive.dart';
import 'package:intl/intl.dart';

abstract class IFileArchiveMode {
  bool get IsArchiveCleanupEnabled;

  /// Check if cleanup should be performed on initialize new file
  ///
  /// <param name="archiveFilePath">Base archive file pattern</param>
  /// <param name="maxArchiveFiles">Maximum number of archive files that should be kept</param>
  /// <param name="maxArchiveDays">Maximum days of archive files that should be kept</param>
  /// <returns>True, when archive cleanup is needed</returns>
  bool attemptCleanupOnInitializeFile(String archiveFilePath, int maxArchiveFiles, int maxArchiveDays);

  /// Create a wildcard file-mask that allows one to find all files belonging to the same archive.
  String generateFileNameMask(String archiveFilePath);

  /// <summary>
  /// Search directory for all existing files that are part of the same archive.
  /// </summary>
  /// <param name="archiveFilePath">Base archive file pattern</param>
  /// <returns></returns>
  List<DateAndSequenceArchive> getExistingArchiveFiles(String archiveFilePath);

  /// <summary>
  /// Generate the next archive filename for the archive.
  /// </summary>
  /// <param name="archiveFilePath">Base archive file pattern</param>
  /// <param name="archiveDate">File date of archive</param>
  /// <param name="existingArchiveFiles">Existing files in the same archive</param>
  /// <returns></returns>
  DateAndSequenceArchive generateArchiveFileName(String archiveFilePath, DateTime archiveDate, List<DateAndSequenceArchive> existingArchiveFiles);

  /// Return all files that should be removed from the provided archive.
  ///
  /// <param name="archiveFilePath">Base archive file pattern</param>
  /// <param name="existingArchiveFiles">Existing files in the same archive</param>
  /// <param name="maxArchiveFiles">Maximum number of archive files that should be kept</param>
  /// <param name="maxArchiveDays">Maximum days of archive files that should be kept</param>
  Iterable<DateAndSequenceArchive> checkArchiveCleanup(String archiveFilePath, List<DateAndSequenceArchive> existingArchiveFiles, int maxArchiveFiles, int maxArchiveDays);
}
