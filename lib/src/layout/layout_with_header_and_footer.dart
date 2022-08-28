import 'package:flog3/flog3.dart';
import 'package:flog3/src/log_event_info.dart';

class LayoutWithHeaderAndFooter extends Layout {
  Layout layout;
  Layout? header;
  Layout? footer;

  LayoutWithHeaderAndFooter({
    required this.layout,
    this.header,
    this.footer,
    required super.configuration,
  });

  @override
  String? getFormattedMessage(LogEventInfo logEvent) {
    return layout.render(logEvent);
  }

  @override
  void renderFormattedMessage(LogEventInfo logEvent, StringBuffer target) {
    layout.renderFormattedMessage(logEvent, target);
  }

}
