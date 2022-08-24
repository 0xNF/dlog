import 'package:flog3/src/layout/layout_renderers/layout_renderer.dart';
import 'package:flog3/src/layout/parser/layout_parser.dart';
import 'package:flog3/src/log_event_info.dart';

import 'package:flog3/src/layout/parser/tokenizer/parse_exception.dart';

///The date and time in a long, sortable format yyyy-MM-dd HH:mm:ss.ffff.
class LongDateLayoutRenderer extends LayoutRenderer {
  static const id = "longdate";

  @override
  String get name => id;

  @override
  bool get isInitialized => true;

  final bool universalTime;

  const LongDateLayoutRenderer({
    this.universalTime = false,
  });

  @override
  void append(StringBuffer builder, LogEventInfo logEvent) {
    builder.write(getValue(logEvent));
  }

  String getValue(LogEventInfo logEvent) {
    final ts = universalTime ? logEvent.timeStamp.toUtc() : logEvent.timeStamp.toLocal();
    int year = ts.year;
    int month = ts.month;
    int day = ts.day;

    int hour = ts.hour;
    int minute = ts.minute;
    int second = ts.second;
    int milisecond = ts.millisecond;

    String y = year.toString().padLeft(4, '0');
    String m = month.toString().padLeft(2, '0');
    String d = day.toString().padLeft(2, '0');

    String h = hour.toString().padLeft(2, '0');
    String mi = minute.toString().padLeft(2, '0');
    String s = second.toString().padLeft(2, '0');
    String ms = milisecond.toString().padRight(4, '0');

    return "$y-$m-$d $h:$mi:$s.$ms";
  }

  factory LongDateLayoutRenderer.fromToken(LayoutVariable variable) {
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
    return LongDateLayoutRenderer(
      universalTime: universalTime,
    );
  }
}
