import 'package:flog3/src/configuration/configuration.dart';
import 'package:flog3/src/layout/layout_renderers/layout_renderer.dart';
import 'package:flog3/src/layout/parser/layout_parser.dart';
import 'package:flog3/src/layout/parser/tokenizer/parse_exception.dart';
import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';

class GuidLayoutRenderer extends LayoutRenderer {
  static const name = "guid";

  /// v1, v4 or v5 uuid formats
  final GuidFormat format;

  final String? namespace;
  final String? guidname;

  /// whether to use the same guid for the same log event across all outputs
  final bool generateFromLogEvent;

  const GuidLayoutRenderer._({
    this.format = GuidFormat.v4,
    this.generateFromLogEvent = false,
    this.namespace,
    this.guidname,
  });

  @override
  void append(StringBuffer builder, LogEventInfo logEvent) {
    builder.write(getValue(logEvent));
  }

  String getValue(LogEventInfo logEvent) {
    if (generateFromLogEvent) {
      throw UnimplementedError();
    }
    switch (format) {
      case GuidFormat.v1:
        return const Uuid().v1();
      case GuidFormat.v4:
        return const Uuid().v4();
      case GuidFormat.v5:
        return const Uuid().v5(namespace, guidname);
    }
  }

  factory GuidLayoutRenderer.fromToken(LayoutVariable variable) {
    GuidFormat format = GuidFormat.v4;
    bool generateFromLogEvent = false;
    String? namespace;
    String? guidname;
    final lst = (variable.value as List).map((e) => e as LayoutVariable);
    for (final lv in lst) {
      switch (lv.variableName.toLowerCase()) {
        case "format":
          final s = lv.getValue<String>();
          final f = GuidFormat.values.firstWhereOrNull((element) => element.name.toLowerCase() == s);
          if (f == null) {
            throw LayoutParser(source: "Unknown value for field 'format': $s");
          }
          format = f;
          break;
        case "namespace":
          namespace = lv.getValue<String>();
          break;
        case "guidname":
          guidname = lv.getValue<String>();
          break;
        case "generatefromlogevent":
          generateFromLogEvent = lv.getValue<bool>();
          break;
        default:
          throw LayoutParserException("Unknown field: ${lv.variableName}", null);
      }
    }
    return GuidLayoutRenderer._(
      format: format,
      generateFromLogEvent: generateFromLogEvent,
      guidname: guidname,
      namespace: namespace,
    );
  }
}

enum GuidFormat {
  v1,
  v4,
  v5,
}
