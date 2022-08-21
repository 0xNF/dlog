import 'dart:convert';

import 'package:flog3/src/configuration/configuration.dart';
import 'package:flog3/src/layout/layout_renderers/layout_renderer.dart';
import 'package:flog3/src/layout/parser/layout_parser.dart';
import 'package:flog3/src/layout/parser/tokenizer/parse_exception.dart';
import 'package:collection/collection.dart';

class EventPropertyLayoutRenderer extends LayoutRenderer {
  static const name = "event-property";

  /// Name of the item. Required.
  final String item;

  ///Name lookup should be case-insensitive. Default true
  final bool ignoreCase;

  /// property path if the value is an object. Nested properties are supported.
  /// Uses `jq` syntax
  final String? objectPath;

  @override
  void append(StringBuffer builder, LogEventInfo logEvent) {
    builder.write(_getValue(logEvent));
  }

  String _getValue(LogEventInfo logEvent) {
    String prop = "";

    /* get Key */
    String? key;
    if (ignoreCase) {
      key = logEvent.eventProperties.keys.firstWhereOrNull((element) => element.toLowerCase() == item.toLowerCase());
    } else {
      key = logEvent.eventProperties[item];
    }

    if (key == null) {
      return "";
    }

    dynamic val = logEvent.eventProperties[key];

    if (objectPath == null || objectPath == r"$") {
      return const JsonEncoder().convert(val);
    }

    prop = JsonEncoder().convert(_traverseJPath(val, objectPath!));
    return prop;
  }

  /// Recursively traverse the value using JsonPath syntax
  String? _traverseJPath(dynamic value, String jpath) {
    // TODO(nf): implement JSONPath parsing
    return value?.toString();
  }

  const EventPropertyLayoutRenderer._({
    required this.item,
    this.ignoreCase = true,
    this.objectPath,
  });

  factory EventPropertyLayoutRenderer.fromToken(LayoutVariable variable) {
    String? item;
    bool ignoreCase = true;
    String? objectPath;
    final lst = (variable.value as List).map((e) => e as LayoutVariable);
    for (final lv in lst) {
      switch (lv.variableName.toLowerCase()) {
        case "item":
          item = lv.getValue<String>();
          break;
        case 'ignorecase':
          ignoreCase = lv.getValue<bool>();
          break;
        case 'objectpath':
          objectPath = lv.getValue<String>();
          break;
        default:
          throw LayoutParserException("Unknown field: ${lv.variableName}", null);
      }
    }
    if (item == null) {
      throw LayoutParserException('Required field `item` missing from layout', null);
    }
    return EventPropertyLayoutRenderer._(
      item: item,
      ignoreCase: ignoreCase,
      objectPath: objectPath,
    );
  }
}
