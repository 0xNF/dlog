import 'package:flog3/src/configuration/configuration.dart';
import 'package:flog3/src/layout/layout_renderers/layout_renderer.dart';
import 'package:flog3/src/layout/parser/layout_parser.dart';
import 'package:flog3/src/layout/parser/tokenizer/parse_exception.dart';
import 'package:flog3/src/log_event_info.dart';

class LoggerNameLayoutRenderer extends LayoutRenderer {
  static const id = "loggername";

  @override
  String get name => id;

  @override
  bool get isInitialized => true;

  final bool shortName;

  const LoggerNameLayoutRenderer({
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
      switch (lv.variableName.toLowerCase()) {
        case "shortname":
          shortName = lv.getValue<bool>();
          break;
        default:
          throw LayoutParserException("Unknown field: ${lv.variableName}", null);
      }
    }
    return LoggerNameLayoutRenderer(shortName: shortName);
  }
}
