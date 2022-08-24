import 'package:dart_ilogger/dart_ilogger.dart';
import 'package:flog3/src/layout/layout_renderers/layout_renderer.dart';
import 'package:flog3/src/layout/parser/layout_parser.dart';
import 'package:collection/collection.dart';
import 'package:flog3/src/layout/parser/tokenizer/parse_exception.dart';
import 'package:flog3/src/log_event_info.dart';


class LevelLayoutRenderer extends LayoutRenderer {
  static const id = "level";

  @override
  String get name => id;

  @override
  bool get isInitialized => true;

  final LevelFormat format;
  final bool uppercase;

  const LevelLayoutRenderer({
    this.format = LevelFormat.name,
    this.uppercase = false,
  });

  @override
  void append(StringBuffer builder, LogEventInfo logEvent) {
    final level = getValue(logEvent);
    switch (format) {
      case LevelFormat.name:
        builder.write(uppercase ? level.name.toUpperCase() : level.name);
        break;
      case LevelFormat.firstCharacter:
        builder.write(level.name[0]);
        break;
      case LevelFormat.ordinal:
        builder.write(level.ordinal);
        break;
      case LevelFormat.fullName:
        if (level == LogLevel.info) {
          builder.write(uppercase ? "INFORMATION" : "Information");
        } else if (level == LogLevel.warn) {
          builder.write(uppercase ? "WARNING" : "Warning");
        } else {
          builder.write(uppercase ? level.name.toUpperCase() : level.name);
        }
        break;
    }
  }

  static LogLevel getValue(LogEventInfo logEvent) {
    return logEvent.level;
  }

  factory LevelLayoutRenderer.fromToken(LayoutVariable variable) {
    LevelFormat format = LevelFormat.name;
    bool uppercase = false;
    final lst = (variable.value as List).map((e) => e as LayoutVariable);
    for (final lv in lst) {
      switch (lv.variableName.toLowerCase()) {
        case "format":
          final s = lv.getValue<String>();
          final f = LevelFormat.values.firstWhereOrNull((element) => element.name.toLowerCase() == s);
          if (f == null) {
            throw LayoutParser(source: "Unknown value for field 'format': $s");
          }
          format = f;
          break;
        case "uppercase":
          uppercase = lv.getValue<bool>();
          break;
        default:
          throw LayoutParserException("Unknown field: ${lv.variableName}", null);
      }
    }

    return LevelLayoutRenderer(format: format, uppercase: uppercase);
  }
}

enum LevelFormat {
  name,
  firstCharacter,
  ordinal,
  fullName,
}
