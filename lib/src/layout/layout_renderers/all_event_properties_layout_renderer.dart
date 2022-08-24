import 'dart:convert';

import 'package:flog3/src/layout/layout_renderers/layout_renderer.dart';
import 'package:flog3/src/layout/parser/layout_parser.dart';
import 'package:flog3/src/layout/parser/tokenizer/parse_exception.dart';
import 'package:flog3/src/log_event_info.dart';

class AllEventPropertiesLayoutRenderer extends LayoutRenderer {
  static const id = "all-event-properties";

  @override
  String get name => id;

  /// How key/value pairs will be formatted.
  /// The placeholder used to define placement of the key is, `[key]`, and the placeholder for value is, `[value]`.
  final String format;

  /// The string that will be used to separate key/value pairs.
  final String separator;

  /// Also render the caller information attributes?
  // final bool includeCallerInformation;

  /// Include ScopeContext Properties together with LogEvent Properties.
  // final bool includeScopeProperties;

  ///  include empty values? A value is empty when null or in case of a string, null or empty string.
  final bool includeEmptyValues;

  /// LogEvent property-key-names to exclude from output. List of keys can be passed as comma separated values,
  final List<String> exclude;

  @override
  bool get isInitialized => true;

  @override
  void append(StringBuffer builder, LogEventInfo logEvent) {
    builder.write(_getValue(logEvent));
  }

  String _getValue(LogEventInfo logEvent) {
    List<String> props = [];

    for (final kvp in logEvent.eventProperties.entries) {
      final key = kvp.key;
      final val = kvp.value;

      /* check exclude */
      if (exclude.contains(key)) {
        continue;
      }

      /* check empty */
      if (!includeEmptyValues) {
        if (val == null) {
          continue;
        }
        if (val is String && val.isEmpty) {
          continue;
        } else if (val is Iterable && val.isEmpty) {
          continue;
        } else if (val is Map && val.isEmpty) {
          continue;
        }
      }

      /* format */
      final v = const JsonEncoder().convert(val);
      final fmtd = format.replaceAll('[key]', key).replaceAll('[value]', v);

      props.add(fmtd);
    }
    return props.join(separator);
  }

  AllEventPropertiesLayoutRenderer({
    this.format = "[key]=[value]",
    this.separator = ",",
    this.exclude = const [],
    this.includeEmptyValues = false,
  });

  factory AllEventPropertiesLayoutRenderer.fromToken(LayoutVariable variable) {
    String separator = ",";
    bool includeEmptyValues = false;
    List<String> exclude = [];
    String format = "[key]=[value]";
    final lst = (variable.value as List).map((e) => e as LayoutVariable);
    for (final lv in lst) {
      switch (lv.variableName.toLowerCase()) {
        case "separator":
          separator = lv.getValue<String>();
          break;
        case 'includeemptyvalues':
          includeEmptyValues = lv.getValue<bool>();
          break;
        case 'exclude':
          exclude = lv.getValue<String>().split(',');
          break;
        case 'format':
          format = lv.getValue<String>();
          break;
        default:
          throw LayoutParserException("Unknown field: ${lv.variableName}", null);
      }
    }
    return AllEventPropertiesLayoutRenderer(
      separator: separator,
      includeEmptyValues: includeEmptyValues,
      exclude: exclude,
      format: format,
    );
  }
}
