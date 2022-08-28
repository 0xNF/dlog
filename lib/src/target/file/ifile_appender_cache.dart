import 'package:flog3/src/target/file/base_file_appener.dart';
import 'package:flog3/src/target/file/icreate_file_parameters.dart';
import 'package:flog3/src/target/file/ifile_appender_factory.dart';

abstract class IFileAppenderCache {
  /// Gets the parameters which will be used for creating a file.
  ICreateFileParameters get createFileParameters;

  /// Gets the file appender factory used by all the appenders in this list.
  IFileAppenderFactory get factory;

  /// Gets the number of appenders which the list can hold.
  int get size;

  /// It allocates the first slot in the list when the file name does not already in the list and clean up any
  /// unused slots.
  BaseFileAppender allocateAppender(String filename);

  /// Close all the allocated appenders.
  void closeAppenders(String reason);

  /// Close the allocated appenders initialized before the supplied time.
  void closeExpiredAppenders(DateTime expireTimeUTC);

  /// Flush all the allocated appenders.
  void flushAppenders();

  DateTime? getFileCreationTimeSource(String filePath, [DateTime? fallbackTimeSource]);

  /// File Archive Logic uses the File-Creation-TimeStamp to detect if time to archive, and the File-LastWrite-Timestamp to name the archive-file.
  ///
  /// NLog always closes all relevant appenders during archive operation, so no need to lookup file-appender
  DateTime? getFileLastWriteTimeUtc(String filePath);

  int? getFileLength(String filePath);

  /// Closes the specified appender and removes it from the list.
  BaseFileAppender invalidateAppender(String filePath);

  /// The archive file path pattern that is used to detect when archiving occurs.
  String get archiveFilePatternToWatch;

  /// Invalidates appenders for all files that were archived.
  void invalidateAppendersForArchivedFiles();
}
