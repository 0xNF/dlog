import 'package:flog3/src/configuration/configuration.dart';

/// Supports object initialization and termination.
abstract class ISupportsInitialize {
  /// Initializes this instance.
  void initialize(LogConfiguration configuration);

  /// Closes this instance.
  void close();
}
