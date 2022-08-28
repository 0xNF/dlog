import 'package:flog3/src/log_event_info.dart';

abstract class IRenderable {
  /// Renders the value of layout or layout renderer in the context of the specified log event.
  String render(LogEventInfo logEvent);
}
