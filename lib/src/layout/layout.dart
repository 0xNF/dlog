import 'package:flog3/src/configuration/configuration.dart';
import 'package:flog3/src/layout/layout_renderers/directory_separator_layout_renderer.dart';
import 'package:flog3/src/layout/layout_renderers/layout_renderer.dart';
import 'package:flog3/src/layout/layout_renderers/literal_layout_renderer.dart';
import 'package:flog3/src/layout/layout_renderers/new_line_layout_renderer.dart';
import 'package:flog3/src/layout/parser/layout_parser.dart';
import 'package:flog3/src/log_event_info.dart';
import 'package:meta/meta.dart';

abstract class Layout {
  bool get isInitialized => _isInitialized;
  bool _isInitialized = false;

  final LogConfiguration configuration;

  Layout({required this.configuration});

  factory Layout.fromText(String text, {LogConfiguration? configuration}) {
    return SimpleLayout.parseLayout(text, configuration ?? LogConfiguration.defaultt);
  }

  @nonVirtual
  String render(LogEventInfo logEvent) {
    if (!isInitialized) {
      initialize(configuration);
    }
    final layoutValue = getFormattedMessage(logEvent) ?? "";
    return layoutValue;
  }

  String? getFormattedMessage(LogEventInfo logEvent);

  @mustCallSuper
  void initialize(LogConfiguration configuration) {
    _isInitialized = true;
  }
}

class SimpleLayout extends Layout {
  final String? _fixedText;

  /// Original string used to create this layout
  final String source;

  final List<LayoutRenderer> renderers;

  SimpleLayout({
    required this.source,
    required super.configuration,
    required this.renderers,
    required String? fixedText,
  }) : _fixedText = fixedText;

  @override
  void initialize(LogConfiguration configuration) {
    for (final lr in renderers) {
      lr.initialize();
    }
    super.initialize(configuration);
  }

  @override
  String? getFormattedMessage(LogEventInfo logEvent) {
    if (_fixedText != null) {
      return _fixedText;
    }
    StringBuffer sb = StringBuffer();
    for (final lr in renderers) {
      lr.renderAppendBuilder(logEvent, sb);
    }
    return sb.toString();
  }

  factory SimpleLayout.parseLayout(String source, LogConfiguration configuration) {
    final parser = LayoutParser(source: source);
    final renderers = parser.parse();

    /* Replace runtime, single-evaluation, LogEvent agnostic items with a literal */
    for (int i = 0; i < renderers.length; i++) {
      final lr = renderers[i];
      final lit = _transformToLiteral(lr);
      if (lit != null) {
        renderers[i] = lit;
      }
    }
    String? fixed = _getFixedTextIfPossible(renderers);
    return SimpleLayout(source: source, configuration: configuration, renderers: renderers, fixedText: fixed);
  }

  static LiteralLayoutRenderer? _transformToLiteral(LayoutRenderer lr) {
    if (lr is LiteralLayoutRenderer) {
      return lr;
    } else if (lr is NewLineLayoutRenderer || lr is DirectorySeparatorLayoutRenderer) {
      return LiteralLayoutRenderer(text: lr.render(LogEventInfo.nullEvent));
    }
    return null;
  }

  static String? _getFixedTextIfPossible(List<LayoutRenderer> lst) {
    final l2 = lst.toList();
    if (l2.isEmpty) {
      return "";
    } else {
      bool allGood = true;
      for (int i = 0; i < l2.length; i++) {
        final lr = l2[i];
        final lit = _transformToLiteral(lr);
        if (lit == null) {
          allGood = false;
          break;
        } else {
          l2[i] = lit;
        }
      }
      if (allGood) {
        return l2.map((e) => e.render(LogEventInfo.nullEvent)).join('');
      }
    }
    return null;
  }
}
