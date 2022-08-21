class FLogException implements Exception {
  final String message;
  final Exception? innerException;

  const FLogException({required this.message, this.innerException});
}

/// The logging library shouldn't throw except under very specific conditions
///
/// This method confirms whether the conditions warrant tossing upwards;
///
/// Mostly taken from C# Nlog
bool mustRethrowExceptionImmediately(dynamic e) {
  if (e is Error) {
    /* `Error` means "the programmer fucked up, not the program" so we throw these */
    return true;
  }
  return false;
}
