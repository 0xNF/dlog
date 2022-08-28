import 'package:flog3/src/abstractions/iraw_value_renderer.dart';
import 'package:flog3/src/layout/layout_renderers/layout_renderer.dart';
import 'package:flog3/src/layout/parser/layout_parser.dart';
import 'package:flog3/src/layout/parser/tokenizer/parse_exception.dart';
import 'package:flog3/src/log_event_info.dart';

import 'package:path/path.dart' as path;

class DirectorySeparatorLayoutRenderer extends LayoutRenderer implements IRawValue {
  static const id = "dir-separator";

  @override
  String get name => id;

  @override
  bool get isInitialized => true;

  @override
  void append(StringBuffer builder, LogEventInfo logEvent) {
    builder.write(path.separator);
  }

  @override
  Object? tryGetRawValue(LogEventInfo logEvent) {
    return path.separator;
  }

  const DirectorySeparatorLayoutRenderer();

  factory DirectorySeparatorLayoutRenderer.fromToken(LayoutVariable variable) {
    final lst = (variable.value as List).map((e) => e as LayoutVariable);
    for (final lv in lst) {
      switch (lv.variableName.toLowerCase()) {
        default:
          throw LayoutParserException("Unknown field: ${lv.variableName}", null);
      }
    }
    return DirectorySeparatorLayoutRenderer();
  }
}
