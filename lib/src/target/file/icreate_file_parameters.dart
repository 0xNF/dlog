/// Interface that provides parameters for create file function.
abstract class ICreateFileParameters {
  /// Gets or sets the delay to wait before attempting to write to the file again.
  Duration get fileOpenRetryCount;

  /// Gets or sets the number of times the write is appended on the file before NLog
  /// discards the log message.
  int get fileOpenRetryDelay;

  // /// Gets or sets a value indicating whether concurrent writes to the log file by multiple processes on the same host.
  // /// This makes multi-process logging possible. NLog uses a special technique
  // /// that lets it keep the files open for writing.
  // bool get concurrentWrites;

  /// Gets or sets a value indicating whether to create directories if they do not exist.
  /// Setting this to false may improve performance a bit, but you'll receive an error
  /// when attempting to write to a directory that's not present.
  bool get createDirs;

  /// Gets or sets a value indicating whether to enable log file(s) to be deleted.
  bool get enableFileDelete;

  /// Gets or sets the log file buffer size in bytes.
  int get bufferSize;

  /// Gets or set a value indicating whether a managed file stream is forced, instead of using the native implementation.
  bool get forceManaged;

  /// Should archive mutex be created?
  bool get isArchivingEnabled;

  /// Should manual simple detection of file deletion be enabled?
  bool get enableFileDeleteSimpleMonitor;
}
