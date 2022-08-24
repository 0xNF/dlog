import 'package:flog3/src/configuration/configuration.dart';
import 'package:flog3/src/layout/layout_renderers/layout_renderer.dart';
import 'package:flog3/src/layout/parser/layout_parser.dart';
import 'package:flog3/src/log_event_info.dart';
import 'package:flog3/src/layout/parser/tokenizer/parse_exception.dart';
import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';

/// The time in a 24-hour, sortable format HH:mm:ss.mmmm.
class TimeLayoutRenderer extends LayoutRenderer {
  static const id = "time";

  @override
  String get name => id;

  @override
  bool get isInitialized => true;

  final bool universalTime;

  const TimeLayoutRenderer({
    this.universalTime = false,
  });

  @override
  void append(StringBuffer builder, LogEventInfo logEvent) {
    builder.write(getValue(logEvent));
  }

  String getValue(LogEventInfo logEvent) {
    final ts = universalTime ? logEvent.timeStamp.toUtc() : logEvent.timeStamp.toLocal();
    int hour = ts.hour;
    int minute = ts.minute;
    int second = ts.second;
    int milisecond = ts.millisecond;

    String h = hour.toString().padLeft(2, '0');
    String m = minute.toString().padLeft(2, '0');
    String s = second.toString().padLeft(2, '0');
    String ms = milisecond.toString().padRight(4, '0');

    return "$h:$m:$s.$ms";
  }

  factory TimeLayoutRenderer.fromToken(LayoutVariable variable) {
    bool universalTime = false;
    final lst = (variable.value as List).map((e) => e as LayoutVariable);
    for (final lv in lst) {
      switch (lv.variableName.toLowerCase()) {
        case "universaltime":
          universalTime = lv.getValue<bool>();
          break;
        default:
          throw LayoutParserException("Unknown field: ${lv.variableName}", null);
      }
    }
    return TimeLayoutRenderer(
      universalTime: universalTime,
    );
  }
}
