import 'package:flog3/src/configuration/configuration.dart';
import 'package:flog3/src/layout/layout_renderers/layout_renderer.dart';

class MessageLayoutRenderer extends LayoutRenderer {
  static const String name = "message";

  /// String that separates message from the exception.
  final String exceptionSeparator;

  ///  Indicates whether to log exception along with message.
  final bool withException;

  ///  Render the unformatted input message without using input parameters
  final bool raw;

  MessageLayoutRenderer({required this.exceptionSeparator, required this.withException, required this.raw});

  @override
  void append(StringBuffer builder, LogEventInfo logEvent) {
    bool exceptionOnly = logEvent.exception != null && withException && logEvent.message == "{0}";
    if (raw) {
      builder.write(logEvent.message);
    } else if (!exceptionOnly) {}
  }
}
