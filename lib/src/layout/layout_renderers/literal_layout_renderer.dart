import 'package:flog3/src/layout/layout_renderers/layout_renderer.dart';
import 'package:flog3/src/layout/parser/layout_parser.dart';
import 'package:flog3/src/layout/parser/tokenizer/parse_exception.dart';
import 'package:flog3/src/log_event_info.dart';

class LiteralLayoutRenderer extends LayoutRenderer {
  static const id = "literal";

  @override
  String get name => id;

  @override
  bool get isInitialized => true;

  final String text;

  const LiteralLayoutRenderer({required this.text}) : super();

  @override
  void append(StringBuffer builder, LogEventInfo logEvent) {
    builder.write(text);
  }

  factory LiteralLayoutRenderer.fromToken(LayoutVariable variable) {
    late final String text;
    if (variable.variableName == r"$boundvariable") {
      text = variable.getValue<String>();
    } else {
      final lst = (variable.value as List).map((e) => e as LayoutVariable);
      for (final lv in lst) {
        switch (lv.variableName.toLowerCase()) {
          case "text":
            text = lv.getValue<String>();
            break;
          default:
            throw LayoutParserException("Unknown field: ${lv.variableName}", null);
        }
      }
    }
    return LiteralLayoutRenderer(text: text);
  }
}
