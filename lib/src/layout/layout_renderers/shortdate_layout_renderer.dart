import 'package:flog3/src/configuration/configuration.dart';
import 'package:flog3/src/layout/layout_renderers/layout_renderer.dart';
import 'package:flog3/src/layout/parser/layout_parser.dart';
import 'package:flog3/src/layout/parser/tokenizer/parse_exception.dart';
import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';

/// The short date in a sortable format yyyy-MM-dd.
class ShortDateLayoutRenderer extends LayoutRenderer {
  static const name = "shortdate";

  final bool universalTime;

  const ShortDateLayoutRenderer._({
    this.universalTime = false,
  });

  @override
  void append(StringBuffer builder, LogEventInfo logEvent) {
    builder.write(getValue(logEvent));
  }

  String getValue(LogEventInfo logEvent) {
    final ts = universalTime ? logEvent.timeStamp.toUtc() : logEvent.timeStamp.toLocal();

    int year = ts.hour;
    int month = ts.minute;
    int day = ts.second;

    String y = year.toString().padLeft(4, '0');
    String m = month.toString().padLeft(2, '0');
    String d = day.toString().padLeft(2, '0');

    return "$y-$m-$d";
  }

  factory ShortDateLayoutRenderer.fromToken(LayoutVariable variable) {
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
    return ShortDateLayoutRenderer._(
      universalTime: universalTime,
    );
  }
}
