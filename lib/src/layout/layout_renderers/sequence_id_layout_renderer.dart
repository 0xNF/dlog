import 'package:flog3/src/abstractions/iraw_value_renderer.dart';
import 'package:flog3/src/layout/layout_renderers/layout_renderer.dart';
import 'package:flog3/src/layout/parser/layout_parser.dart';
import 'package:flog3/src/layout/parser/tokenizer/parse_exception.dart';
import 'package:flog3/src/log_event_info.dart';

class SequenceIdRenderer extends LayoutRenderer implements IRawValue {
  static const id = "sequenceid";

  @override
  String get name => id;

  @override
  bool get isInitialized => true;

  @override
  void append(StringBuffer builder, LogEventInfo logEvent) {
    builder.write(_getValue(logEvent));
  }

  String _getValue(LogEventInfo logEvent) {
    return "${logEvent.sequenceId}";
  }

  @override
  Object? tryGetRawValue(LogEventInfo logEvent) => _getValue(logEvent);

  const SequenceIdRenderer();

  factory SequenceIdRenderer.fromToken(LayoutVariable variable) {
    final lst = (variable.value as List).map((e) => e as LayoutVariable);
    for (final lv in lst) {
      switch (lv.variableName.toLowerCase()) {
        default:
          throw LayoutParserException("Unknown field: ${lv.variableName}", null);
      }
    }
    return const SequenceIdRenderer();
  }
}
