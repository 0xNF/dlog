import 'package:flog3/src/configuration/configuration.dart';
import 'package:flog3/src/layout/layout_renderers/layout_renderer.dart';
import 'package:flog3/src/layout/parser/layout_parser.dart';
import 'package:flog3/src/layout/parser/tokenizer/parse_exception.dart';
import 'package:path/path.dart' as path;

class DirectorySeparatorLayoutRenderer extends LayoutRenderer {
  static const name = "dir-separator";

  @override
  void append(StringBuffer builder, LogEventInfo logEvent) {
    builder.write(path.separator);
  }

  const DirectorySeparatorLayoutRenderer._();

  factory DirectorySeparatorLayoutRenderer.fromToken(LayoutVariable variable) {
    final lst = (variable.value as List).map((e) => e as LayoutVariable);
    for (final lv in lst) {
      switch (lv.variableName) {
        default:
          throw LayoutParserException("Unknown field: ${lv.variableName}", null);
      }
    }
    return const DirectorySeparatorLayoutRenderer._();
  }
}