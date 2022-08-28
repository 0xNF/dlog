import 'dart:convert';

import 'package:flog3/src/configuration/configuration.dart';
import 'package:flog3/src/layout/file/file_path_layout.dart';
import 'package:flog3/src/layout/layout.dart';
import 'package:flog3/src/target/file/file_archive_numbering_mode.dart';
import 'package:flog3/src/target/file/file_archive_period.dart';
import 'package:flog3/src/target/file/file_path_kind.dart';
import 'package:flog3/src/target/file/file_target_spec.dart';
import 'package:flog3/src/target/file/icreate_file_parameters.dart';
import 'package:flog3/src/target/file/line_ending.dart';
import 'package:flog3/src/target/specs/target_spec.dart';
import 'package:flog3/src/target/target_with_layout_header_footer.dart';
import 'package:flog3/src/log_event_info.dart';

class FileTarget extends TargetWithLayoutHeaderAndFooter implements ICreateFileParameters {
  /// Default clean up period of the initialized files. When a file exceeds the clean up period is removed from the list.
  static const Duration _initializedFileCleanupPeriod = Duration(days: 2);

  /// This value disables file archiving based on the size.
  static const int archiveAboveSizeDisabled = -1;

  FileTarget({required super.spec, required super.config});

  /// Holds the initialized files each given time by the [FileTarget] instance.
  /// Against each file, the last write time (UTC) is stored.
  final Map<String, DateTime> _initializedFiles = {};

  /// The number of initialized files at any one time.
  int _initializedFilesCounter = 0;

  /// The maximum number of archive files that should be kept.
  int get maxArchiveFiles => _maxArchiveFiles;
  int _maxArchiveFiles = 0;
  set maxArchiveFiles(int value) {
    if (_maxArchiveFiles != value) {
      _maxArchiveFiles = value;
      _resetFileAppenders("MaxArchiveFiles Changed"); // Enforce archive cleanup
    }
  }

  /// The maximum days of archive files that should be kept.
  int get maxArchiveDays => _maxArchiveDays;
  int _maxArchiveDays = 0;
  set maxArchiveDays(int value) {
    if (_maxArchiveDays != value) {
      _maxArchiveDays = value;
      _resetFileAppenders("MaxArchiveDays Changed"); // Enforce archive cleanup
    }
  }

  /// Gets or sets a value indicating whether to automatically archive log files every time the specified time passes.
  ///
  /// Files are moved to the archive as part of the write operation if the current period of time changes. For example
  /// if the current <c>hour</c> changes from 10 to 11, the first write that will occur
  /// on or after 11:00 will trigger the archiving.
  FileArchivePeriod get archiveEvery => _archiveEvery;
  set archiveEvery(FileArchivePeriod value) {
    if (_archiveEvery != value) {
      _archiveEvery = value;
      _resetFileAppenders("ArchiveEvery Changed"); // Enforce archive cleanu
    }
  }

  FileArchivePeriod _archiveEvery = FileArchivePeriod.none;

  /// The date of the previous log event.
  DateTime? _previousLogEventTimestamp;

  /// The file name of the previous log event.
  String? _previousLogFileName;

  /// Gets or sets a value indicating whether concurrent writes to the log file by multiple processes on the same host.
  ///
  /// This makes multi-process logging possible. NLog uses a special technique
  /// that lets it keep the files open for writing.
  bool get concurrentWrites => _concurrentWrites;
  bool _concurrentWrites = false;
  set concurrentWrites(bool value) {
    if (_concurrentWrites != value) {
      _concurrentWrites = value;
      _resetFileAppenders("ConcurrentWrites changed");
    }
  }

  bool get cleanupFileNames => _cleanupFileName;
  bool _cleanupFileName = false;
  set cleanupFileNames(bool value) {
    if (_cleanupFileName != value) {
      _cleanupFileName = value;
      _fullFileName = _createFileNameLayout(filename);
      _fullArchiveFileName = _createFileNameLayout(archiveFileName);
      _resetFileAppenders("CleanupFileName changed");
    }
  }

  /// Is the  [FileName] an absolute or relative path?
  FilePathKind get fileNameKind => _fileNameKind;
  FilePathKind _fileNameKind = FilePathKind.unknown;
  set fileNameKind(FilePathKind value) {
    if (_fileNameKind != value) {
      _fileNameKind = value;
      _fullFileName = _createFileNameLayout(fileName);
      _resetFileAppenders("FileNameKind Changed");
    }
  }

  /// Is the [ArchiveFileName] an absolute or relative path?
  FilePathKind get archiveFileKind => _archiveFileKind;
  FilePathKind _archiveFileKind = FilePathKind.unknown;
  set archiveFileKind(FilePathKind value) {
    if (_archiveFileKind != value) {
      _archiveFileKind = value;
      _fullArchiveFileName = _createFileNameLayout(archiveFileName);
      _resetFileAppenders("ArchiveFileKind Changed");
    }
  }

  /// Gets or sets the way file archives are numbered.
  ArchiveNumberingMode get archiveNumbering => _archiveNumbering;
  ArchiveNumberingMode _archiveNumbering = ArchiveNumberingMode.sequence;
  set archiveNumbering(ArchiveNumberingMode value) {
    if (_archiveNumbering != value) {
      _archiveNumbering = value;
      _resetFileAppenders("ArchiveNumbering Changed"); // Reset archive file-monitoring
    }
  }

  Layout? get archiveFileName {
    if (_fullArchiveFileName == null) {
      return null;
    }
    return _fullArchiveFileName!.getLayout();
  }

  FilePathLayout? _fullArchiveFileName;

  set archiveFileName(Layout? value) {
    _fullArchiveFileName = _createFileNameLayout(value);
    _resetFileAppenders("ArchiveFileName Changed"); // Reset archive file-monitoring
  }

  /// Gets or sets the name of the file to write to.
  ///
  /// This FileName string is a layout which may include instances of layout renderers.
  ///
  /// This lets you use a single target to write to multiple files.
  ///
  /// The following value makes FLog write logging events to files based on the log level in the directory where
  /// the application runs.
  /// <code>${basedir}/${level}.log</code>
  ///
  /// All <c>Debug</c> messages will go to <c>Debug.log</c>, all <c>Info</c> messages will go to <c>Info.log</c> and so on.
  /// You can combine as many of the layout renderers as you want to produce an arbitrary log file name.
  Layout? get fileName => _fullFileName?.getLayout();
  set fileName(Layout? value) {
    _fullFileName = _createFileNameLayout(value);
    _resetFileAppenders("FileName Changed"); // Reset archive file-monitoring
  }

  FilePathLayout? _fullFileName;

  /// Gets or sets a value indicating whether to delete old log file on startup.
  ///
  /// This option works only when the [fileName] parameter denotes a single file.
  bool get deleteOldFilesOnStartup => _deleteOldFilesOnStartup;
  bool _deleteOldFilesOnStartup = false;

  FilePathLayout? _createFileNameLayout(Layout? value) {
    if (value == null) {
      return null;
    }
    return FilePathLayout(value: value, cleanupFileName: cleanupFileNames, fileNameKind: fileNameKind);
  }

  @override
  // TODO: implement bufferSize
  int get bufferSize => _bufferSize;
  int _bufferSize = 32768;

  @override
  // TODO: implement concurrentWrites
  bool get concurrentWrites => throw UnimplementedError();

  /// Gets or sets a value indicating whether to create directories if they do not exist.
  /// Setting this to false may improve performance a bit, but you'll receive an error
  /// when attempting to write to a directory that's not present.
  @override
  bool get createDirs => _createDirs;
  bool _createDirs = true;

  /// Gets or sets a value indicating whether to replace file contents on each write instead of appending log message at the end.
  bool replaceFileContentsOnEachWrite = false;

  /// Gets or sets a value indicating whether to keep log file open instead of opening and closing it on each logging event.
  ///
  /// KeepFileOpen = true gives the best performance, and ensure the file-lock is not lost to other applications.
  ///
  /// KeepFileOpen = false gives the best compability, but slow performance and lead to file-locking issues with other applications.
  bool get keepFileOpen => _keepFileOpen;
  set keepFileOpen(bool value) {
    if (_keepFileOpen != value) {
      _keepFileOpen = value;
      _resetFileAppenders("KeepFileOpen changed");
    }
  }

  bool _keepFileOpen = true;

  @override
  bool get enableFileDelete => _enableFileDelete;
  bool _enableFileDelete = true;

  @override
  // TODO: implement enableFileDeleteSimpleMonitor
  bool get enableFileDeleteSimpleMonitor => throw UnimplementedError();

  @override
  Duration get fileOpenRetryCount => concurrentWrites ? Duration(milliseconds: concurrentWriteAttempts) : (keepFileOpen ? Duration.zero : (Duration(milliseconds: _concurrentWriteAttempts ?? 2)));

  @override
  int get fileOpenRetryDelay => concurrentWriteAttemptDelay.inMilliseconds;

  /// Gets or sets the number of times the write is appended on the file before NLog
  /// discards the log message.

  int get concurrentWriteAttempts => _concurrentWriteAttempts ?? 10;
  int? _concurrentWriteAttempts;
  set concurrentWriteAttempts(int value) {
    _concurrentWriteAttempts = value;
  }

  /// Gets or sets the line ending mode.
  LineEnding lineEnding = LineEnding.platform;

  /// Gets or sets a value indicating whether to automatically flush the file buffers after each log message.
  bool autoFlush = true;

  /// Gets or sets the delay in milliseconds to wait before attempting to write to the file again.
  /// The actual delay is a random value between 0 and the value specified
  /// in this parameter. On each failed attempt the delay base is doubled
  /// Assuming that ConcurrentWriteAttemptDelay is 10 the time to wait will be:<p/>
  /// a random value between 0 and 10 milliseconds - 1st attempt<br/>
  /// a random value between 0 and 20 milliseconds - 2nd attempt<br/>
  /// a random value between 0 and 40 milliseconds - 3rd attempt<br/>
  /// a random value between 0 and 80 milliseconds - 4th attempt<br/>
  /// ...<p/>
  /// and so on.
  Duration concurrentWriteAttemptDelay = const Duration(milliseconds: 1);

  /// Gets or sets the number of files to be kept open. Setting this to a higher value may improve performance
  /// in a situation where a single File target is writing to many files
  /// (such as splitting by level or by logger).
  ///
  ///
  /// The files are managed on a LRU (least recently used) basis, which flushes
  /// the files that have not been used for the longest period of time should the
  /// cache become full. As a rule of thumb, you shouldn't set this parameter to
  /// a very high value. A number like 10-15 shouldn't be exceeded, because you'd
  /// be keeping a large number of files open which consumes system resources.
  int openFileCacheSize = 5;

  /// Gets or sets the maximum number of seconds that files are kept open. Zero or negative means disabled.
  Duration get openFileCacheTimeout => Duration(seconds: _openFileCacheTimeout);
  int _openFileCacheTimeout = 0;

  /// Gets or sets the maximum number of seconds before open files are flushed. Zero or negative means disabled.
  Duration get openFileFlushTimeout => Duration(seconds: _openFileFlushTimeout);
  int _openFileFlushTimeout = 0;

  Encoding get encoding => _encoding;
  Encoding _encoding = const Utf8Codec();
  set encoding(Encoding value) {
    _encoding = value;
    if (!writeBOM && _initialBOMValue(value)) {
      writeBOM = true;
    }
  }

  /// Gets or sets a value indicating whether to write BOM (byte order mark) in created files.
  /// Defaults to true for UTF-16 and UTF-32
  bool writeBOM = false;

  /// Gets or sets whether or not this target should just discard all data that its asked to write.
  /// Mostly used for when testing FLog Stack except final write
  bool discardAll = false;

  /// Gets or sets a value indicating whether to archive old log file on startup.
  ///
  /// This option works only when the [fileName] parameter denotes a single file.
  /// After archiving the old file, the current log file will be empty.
  bool archiveOldFileOnStartup = false;

  /// Gets or sets a value of the file size threshold to archive old log file on startup.
  ///
  /// This option won't work if [archiveOldFileOnStartup] is set to `false`
  /// Default value is 0 which means that the file is archived as soon as archival on
  /// startup is enabled.
  int archiveOldFilesOnStartupAboveSize = 0;

  /// Gets or sets a value specifying the date format to use when archiving files.
  ///
  /// This option works only when the [archiveNumbering] parameter is set either to `Date` or `DateAndSequence`.
  String get archiveDateFormat => _archiveDateFormat;
  String _archiveDateFormat = "";
  set archiveDateFormat(String value) {
    if (_archiveDateFormat != value) {
      _archiveDateFormat = value;
      _resetFileAppenders("ArchiveDateFormat Changed");
    }
  }

  /// Gets or sets the size in bytes above which log files will be automatically archived.
  /// Notice when combined with [ArchiveNumberingMode.Date] then it will attempt to append to any existing
  /// archive file if grown above size multiple times. New archive file will be created when using [ArchiveNumberingMode.DateAndSequence]
  int get archiveAboveSize => _archiveAboveSize;
  int _archiveAboveSize = -1;
  set archiveAboveSize(int value) {
    final newValue = value > 0 ? value : archiveAboveSizeDisabled;
    if ((_archiveAboveSize > 0) != (newValue > 0)) {
      _archiveAboveSize = newValue;
      _resetFileAppenders("ArchiveAboveSize Changed");
    } else {
      _archiveAboveSize = newValue;
    }
  }

  /// Gets or sets a value indicating whether the footer should be written only when the file is archived.
  bool writeFooterOnArchivingOnly = false;

  @override
  bool get forceManaged => _forceManaged;
  bool _forceManaged = true;

  @override
  bool get isArchivingEnabled => _archiveAboveSize != archiveAboveSizeDisabled || archiveEvery != FileArchivePeriod.none;

  bool get enableArchiveFileCompression => _enableArchiveFileCompression;
  bool _enableArchiveFileCompression = false;
  set enableArchiveFileCompression(bool value) {
    if (_enableArchiveFileCompression != value) {
      _enableArchiveFileCompression = value;
      _resetFileAppenders("EnableArchiveFileCompression Changed");
    }
  }

  /// Gets the characters that are appended after each line.
  String get newLineChars => lineEnding.chars();

  factory FileTarget.fromSpec(TargetSpec spec, LogConfiguration config) {
    final t = FileTarget(spec: spec, config: config);
    final tspec = spec as FileTargetSpec;

    t.archiveNumbering = tspec.archiveNumbering;
    t._maxArchiveDays = tspec.maxArchiveDays;
    t._maxArchiveFiles = tspec.maxArchiveFiles;
    t.archiveOldFileOnStartup = tspec.archiveOldFileOnStartup;
    t.archiveOldFilesOnStartupAboveSize = tspec.archiveOldFileOnStartupAboveSize;
    t._archiveEvery = tspec.archiveEvery;
    t._archiveAboveSize = tspec.archiveAboveSize ?? archiveAboveSizeDisabled;
    t._createDirs = tspec.createDirs;
    t._deleteOldFilesOnStartup = tspec.deleteOldFileOnStartup;
    t.replaceFileContentsOnEachWrite = tspec.replaceFileContentsOnEachWrite;
    t.keepFileOpen = tspec.keepFileOpen;
    t._enableFileDelete = tspec.enableFileDelete;
    t.lineEnding = tspec.lineEnding;
    t.autoFlush = tspec.autoFlush;
    t.openFileCacheSize = tspec.openFileCacheSize;
    t._openFileCacheTimeout = tspec.openFileCacheTimeout;
    t._openFileFlushTimeout = tspec.openFileFlushTimeout;
    t._bufferSize = tspec.bufferSize;
    t.writeBOM = tspec.writeBOM;
    t.discardAll = tspec.discardAll;
    t._encoding = tspec.encoding;
    t.writeFooterOnArchivingOnly = tspec.writeFooterOnArchivingOnly;
    t._forceManaged = tspec.forceManaged;
    t._enableArchiveFileCompression = tspec.enableArchiveFileCompression;

    t.archiveFileName = tspec.archiveFileName;
    t.fileName = tspec.fileName;
    return t;
  }

  @override
  void initializeTarget() {
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

  static bool _initialBOMValue(Encoding encoding) {
    const int utf16 = 1200;
    const int utf16Be = 1201;
    const int utf32 = 12000;
    const int urf32Be = 12001;
    // TODO(nf): find how to get CodePage number from an encoding
    return false;
    // var codePage = encoding?. ?? 0;
    // return codePage == utf16 || codePage == utf16Be || codePage == utf32 || codePage == urf32Be;
  }
}
