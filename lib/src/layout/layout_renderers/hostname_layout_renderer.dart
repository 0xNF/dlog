import 'dart:io';

import 'package:flog3/src/configuration/configuration.dart';
import 'package:flog3/src/layout/layout_renderers/layout_renderer.dart';
import 'package:flog3/src/layout/parser/layout_parser.dart';
import 'package:flog3/src/layout/parser/tokenizer/parse_exception.dart';

class HostnameLayoutRenderer extends LayoutRenderer {
  static const name = "hostname";

  @override
  void append(StringBuffer builder, LogEventInfo logEvent) {
    builder.write(_getValue());
  }

  String _getValue() {
    return Platform.localHostname;
  }

  const HostnameLayoutRenderer._();

  factory HostnameLayoutRenderer.fromToken(LayoutVariable variable) {
    final lst = (variable.value as List).map((e) => e as LayoutVariable);
    for (final lv in lst) {
      switch (lv.variableName) {
        default:
          throw LayoutParserException("Unknown field: ${lv.variableName}", null);
      }
    }
    return const HostnameLayoutRenderer._();
  }
}
