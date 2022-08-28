/// Type of filepath
enum FilePathKind {
  /// Detect of relative or absolute
  unknown,

  /// Relative path
  relative,

  /// Absolute path
  /// Best for performance
  absolute
}
