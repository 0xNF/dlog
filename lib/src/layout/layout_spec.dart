import 'package:flog3/src/layout/null_layout/null_options.dart';
import 'package:flog3/src/layout/options/layout_spec_options.dart';
import 'package:flog3/src/layout/csv/csv_layout_options.dart';
import 'package:flog3/src/layout/parser/tokenizer/parse_exception.dart';
import 'package:flog3/src/layout/simple/simple_layout_options.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';

import 'json/json_layout_options.dart';

class LayoutSpec {
  static const String deafultSimpleLayout = r"${longdate}|${level:uppercase=true}|${loggerName}|${message:withexception=true}|${all-event-properties}";

  @JsonKey(name: 'type', defaultValue: LayoutKind.simple)
  final LayoutKind kind;

  @JsonKey(name: 'layout', defaultValue: deafultSimpleLayout)
  final String layout;

  @JsonKey(name: 'options')
  final LayoutSpecOptions options;

  const LayoutSpec({
    this.kind = LayoutKind.simple,
    this.layout = deafultSimpleLayout,
    LayoutSpecOptions? options,
  }) : options = options ??
            (kind == LayoutKind.simple
                ? const SimpleLayoutSpecOptions()
                : kind == LayoutKind.csv
                    ? const CSVLayoutOptions()
                    : kind == LayoutKind.json
                        ? const JSONLayoutOptions()
                        : const NullOptions());

  Map<String, dynamic> toJson() => _$LayoutSpecToJson();
  factory LayoutSpec.fromJson(Map<String, dynamic> json) => _$LayoutSpecFromJson(json);

  static LayoutSpec _$LayoutSpecFromJson(Map<String, dynamic> json) {
    LayoutKind? k = LayoutKind.simple;
    String? kstr = json["type"] as String?;
    if (kstr != null) {
      kstr = kstr.toLowerCase();
      k = LayoutKind.values.firstWhereOrNull((x) => x.name.toLowerCase() == kstr);
      if (k == null) {
        throw LayoutParserException("Invalid Layout Type: $kstr ", null);
      }
    }
    String l = deafultSimpleLayout;
    final lstr = json["layout"] as String?;
    if (lstr != null) {
      l = lstr;
    }

    final opts = json["options"] as Map<String, dynamic>?;
    late final LayoutSpecOptions o;

    switch (k) {
      case LayoutKind.json:
        o = opts == null ? const JSONLayoutOptions() : JSONLayoutOptions.fromJson(opts);
        break;
      case LayoutKind.csv:
        o = opts == null ? const CSVLayoutOptions() : CSVLayoutOptions.fromJson(opts);
        break;
      case LayoutKind.simple:
      default:
        o = opts == null ? const SimpleLayoutSpecOptions() : SimpleLayoutSpecOptions.fromJson(opts);
    }

    return LayoutSpec(kind: k, layout: l, options: o);
  }

  Map<String, dynamic> _$LayoutSpecToJson() {
    final m = <String, dynamic>{
      'type': kind.name,
      'layout': layout,
      'options': (options as dynamic).toJson(),
    };
    return m;
  }
}

enum LayoutKind {
  @JsonValue("Simple")
  simple,

  @JsonValue("JSON")
  json,

  @JsonValue("CSV")
  csv,
}
