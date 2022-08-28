import 'package:flog3/src/log_event_info.dart';

/// Get the Raw, unformatted value without stringify
abstract class IRawValue {
  /// Get the raw value
  Object? tryGetRawValue(LogEventInfo logEvent);
}
