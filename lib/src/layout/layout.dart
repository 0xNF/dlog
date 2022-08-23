import 'package:flog3/src/configuration/configuration.dart';
import 'package:flog3/src/layout/layout_renderers/layout_renderer.dart';
import 'package:flog3/src/layout/parser/layout_parser.dart';
import 'package:meta/meta.dart';

class Layout {
  /// Original string used to create this layout
  final String source;

  final LogConfiguration configuration;

  final List<LayoutRenderer> renderers;

  const Layout({
    required this.source,
    required this.configuration,
    required this.renderers,
  });

  @nonVirtual
  String render(LogEventInfo logEvent) {
    StringBuffer sb = StringBuffer();
    for (final lr in renderers) {
      lr.renderAppendBuilder(logEvent, sb);
    }
    return sb.toString();
  }

  factory Layout.parseLayout(String source, LogConfiguration configuration) {
    final parser = LayoutParser(source: source);
    final renderers = parser.parse();
    return Layout(source: source, configuration: configuration, renderers: renderers);
  }
}
