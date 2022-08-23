import 'package:flog3/src/configuration/configuration.dart';
import 'package:flog3/src/layout/layout_renderers/layout_renderer.dart';
import 'package:flog3/src/layout/parser/layout_parser.dart';
import 'package:flog3/src/layout/parser/tokenizer/parse_exception.dart';
import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';

class GuidLayoutRenderer extends LayoutRenderer {
  static const id = "guid";

  @override
  String get name => id;

  /// v1, v4 or v5 uuid formats
  final GuidFormat format;

  final String? namespace;
  final String? guidname;

  /// whether to use the same guid for the same log event across all outputs
  final bool generateFromLogEvent;

  const GuidLayoutRenderer({
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
    // TODO(nf): fix generate from Log Event
    if (generateFromLogEvent) {
      int hashCode = logEvent.hashCode;
      int b = ((hashCode >> 16) & 0XFFFF) % 256;
      int c = (hashCode & 0XFFFF) % 256;
      int zeroDateTicks = LogEventInfo.zeroDate.microsecondsSinceEpoch;
      int d = ((zeroDateTicks >> 56) & 0xFF) % 256;
      int e = ((zeroDateTicks >> 48) & 0xFF) % 256;
      int f = ((zeroDateTicks >> 40) & 0xFF) % 256;
      int g = ((zeroDateTicks >> 32) & 0xFF) % 256;
      int h = ((zeroDateTicks >> 24) & 0xFF) % 256;
      int i = ((zeroDateTicks >> 16) & 0xFF) % 256;
      int j = ((zeroDateTicks >> 8) & 0xFF) % 256;
      int k = (zeroDateTicks & 0XFF) % 256;
      int l = ((hashCode >> 8) & 0XFFFF) % 256;
      int m = ((hashCode >> 24) & 0XFFFF) % 256;
      // TODO(nf): last 3 bytes are 0 because unlike .NET, they are  32 bit numbers not 64 bit.
      int n = hashCode.isOdd ? 100 : 250;

      /// ((hashCode >> 32) & 0XFFFF) % 256;
      int o = 253;
      // ((hashCode >> 40) & 0XFFFF) % 256;
      int p = 128;
      // ((hashCode >> 48) & 0XFFFF) % 256;

      final guid = Uuid.unparse([logEvent.sequenceId, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p]);
      return guid;
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
    return GuidLayoutRenderer(
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
