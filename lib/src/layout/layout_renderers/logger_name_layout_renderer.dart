import 'package:flog3/src/configuration/configuration.dart';
import 'package:flog3/src/layout/layout_renderers/layout_renderer.dart';
import 'package:flog3/src/layout/parser/layout_parser.dart';
import 'package:flog3/src/layout/parser/tokenizer/parse_exception.dart';

class LoggerNameLayoutRenderer extends LayoutRenderer {
  static const name = "loggername";

  final bool shortName;

  const LoggerNameLayoutRenderer._({
    this.shortName = false,
  });

  @override
  void append(StringBuffer builder, LogEventInfo logEvent) {
    builder.write(getValue(logEvent));
  }

  String getValue(LogEventInfo logEvent) {
    return logEvent.loggerName;
  }

  factory LoggerNameLayoutRenderer.fromToken(LayoutVariable variable) {
    bool shortName = false;
    final lst = (variable.value as List).map((e) => e as LayoutVariable);
    for (final lv in lst) {
      switch (lv.variableName) {
        case "shortname":
          shortName = lv.getValue<bool>();
          break;
        default:
          throw LayoutParserException("Unknown field: ${lv.variableName}", null);
      }
    }
    return LoggerNameLayoutRenderer._(shortName: shortName);
  }
}
