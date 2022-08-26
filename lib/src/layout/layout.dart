import 'package:flog3/src/configuration/configuration.dart';
import 'package:flog3/src/layout/csv/layout_csv.dart';
import 'package:flog3/src/layout/json/json_layout_options.dart';
import 'package:flog3/src/layout/json/layout_json.dart';
import 'package:flog3/src/layout/simple/layout_simple.dart';
import 'package:flog3/src/layout/layout_spec.dart';
import 'package:flog3/src/layout/csv/csv_layout_options.dart';
import 'package:flog3/src/log_event_info.dart';
import 'package:meta/meta.dart';

abstract class Layout {
  bool get isInitialized => _isInitialized;
  bool _isInitialized = false;

  final LogConfiguration configuration;

  Layout({required this.configuration});

  // TODO(nf): replace body here with more layout-agnostic logic than just SimpleLayout
  factory Layout.fromText(String text, {LogConfiguration? configuration}) {
    return SimpleLayout.parseLayout(text, configuration ?? LogConfiguration.defaultt);
  }

  factory Layout.fromSpec(LayoutSpec spec, {LogConfiguration? configuration}) {
    final config = configuration ?? LogConfiguration.defaultt;
    switch (spec.kind) {
      case LayoutKind.csv:
        return CSVLayout.parseLayout(spec.options as CSVLayoutOptions, config);
      case LayoutKind.json:
        return JsonLayout.parseLayout(spec.options as JSONLayoutOptions, config);
      case LayoutKind.simple:
        return SimpleLayout.parseLayout(spec.layout, config);
      default:
        return Layout.fromText(spec.layout, configuration: config);
    }
  }

  @nonVirtual
  String render(LogEventInfo logEvent) {
    if (!isInitialized) {
      initialize(configuration);
    }
    final layoutValue = getFormattedMessage(logEvent) ?? "";
    return layoutValue;
  }

  @nonVirtual
  void renderWithBuilder(LogEventInfo logEvent, StringBuffer target) {
    renderAppendBuilder(logEvent, target, cacheLayoutResult: false);
  }

  void renderAppendBuilder(LogEventInfo logEvent, StringBuffer target, {required bool cacheLayoutResult}) {
    if (!isInitialized) {
      initialize(configuration);
    }
    // TODO(nf): do stuff related to caching log output
    renderFormattedMessage(logEvent, target);
  }

  void renderFormattedMessage(LogEventInfo logEvent, StringBuffer target) {
    target.write(getFormattedMessage(logEvent));
  }

  String? getFormattedMessage(LogEventInfo logEvent);

  @mustCallSuper
  void initialize(LogConfiguration configuration) {
    _isInitialized = true;
  }
}
