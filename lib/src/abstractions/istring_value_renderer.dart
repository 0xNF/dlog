import 'package:flog3/src/log_event_info.dart';

abstract class IStringValueRenderer {
  /// Renders the value of layout renderer in the context of the specified log event
  String? getFormattedString(LogEventInfo logEvent);
}
