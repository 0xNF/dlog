import 'dart:io';

import 'package:flog3/src/layout/layout_renderers/layout_renderer.dart';
import 'package:flog3/src/layout/parser/layout_parser.dart';
import 'package:flog3/src/layout/parser/tokenizer/parse_exception.dart';
import 'package:flog3/src/log_event_info.dart';

class NewLineLayoutRenderer extends LayoutRenderer {
  static const id = "newline";

  @override
  String get name => id;

  @override
  bool get isInitialized => true;

  @override
  void append(StringBuffer builder, LogEventInfo logEvent) {
    builder.write(_getValue());
  }

  String _getValue() {
    return Platform.isWindows ? '\r\n' : '\n';
  }

  const NewLineLayoutRenderer();

  factory NewLineLayoutRenderer.fromToken(LayoutVariable variable) {
    final lst = (variable.value as List).map((e) => e as LayoutVariable);
    for (final lv in lst) {
      switch (lv.variableName.toLowerCase()) {
        default:
          throw LayoutParserException("Unknown field: ${lv.variableName}", null);
      }
    }
    return NewLineLayoutRenderer();
  }
}
