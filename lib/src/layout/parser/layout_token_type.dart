enum LayoutType {
  /* Misc */
  /// The log level (e.g. ERROR, DEBUG) or level ordinal (number)
  level,

  /// regular string, using no other layout types
  literal,

  /// The (formatted) log message
  message,

  ///  A newline literal.
  newline,

  /// A variable
  variable,

  /* Callsite and Stack traces */
  ///  The call site (class name, method name and source information)
  callsite,

  /// The call site source file name.
  callsiteFilename,

  /// The call site source line number.
  callsiteLineNumber,

  ///  Render the Stack trace
  stackTrace,

  /* Context Information */
  ///  Exception information provided through a call to one of the Logger methods
  exception,

  /// The logger name. GetLogger, GetCurrentClassLogger etc
  loggerName,

  /// Log event properties data
  eventProperty,

/* Counters */
  ///  A counter value (increases on each layout rendering)
  counter,

  /// Globally-unique identifier(GUID).
  guid,

  /// The log sequence id
  sequenceId,

  /* Files and Directories */
  /// The current application domain's base directory.
  baseDir,

  ///  The current working directory of the application.
  currentDir,

  /// The the OS dependent directory separator.
  dirSeparator,

  /* Date Time */

  /// Current date and time.
  date,

  /// The date and time in a long, sortable format `yyyy-MM-dd HH:mm:ss.ffff`.
  longdate,

  ///  The short date in a sortable format yyyy-MM-dd.
  shortdate,

  /// The Ticks value of current date and time.
  ticks,

  /// The time in a 24-hour, sortable format HH:mm:ss.mmm.
  time,
}
