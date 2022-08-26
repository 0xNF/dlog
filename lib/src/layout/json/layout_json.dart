import 'dart:convert';

import 'package:flog3/src/configuration/configuration.dart';
import 'package:flog3/src/layout/json/json_layout_options.dart';
import 'package:flog3/src/layout/layout.dart';
import 'package:flog3/src/log_event_info.dart';

class _JSONAttribute extends Layout {
  late final Layout layout;
  JSONAttribute source;
  final String name;

  _JSONAttribute({required this.name, required this.source, required super.configuration});

  @override
  void renderFormattedMessage(LogEventInfo logEvent, StringBuffer target) {
    layout.renderAppendBuilder(logEvent, target, cacheLayoutResult: false);
  }

  @override
  String? getFormattedMessage(LogEventInfo logEvent) {
    final sb = StringBuffer();
    renderAppendBuilder(logEvent, sb, cacheLayoutResult: false);
    return sb.toString();
  }

  @override
  void initialize(LogConfiguration configuration) {
    layout = Layout.fromText(source.layout);
    super.initialize(configuration);
  }

  factory _JSONAttribute.fromAttribute(JSONAttribute attrib, LogConfiguration config) {
    return _JSONAttribute(name: attrib.name, source: attrib, configuration: config);
  }
}

class JsonLayout extends Layout {
  final JSONLayoutOptions options;

  final List<_JSONAttribute> _attributes;

  JsonLayout({
    required super.configuration,
    required this.options,
  }) : _attributes = options.attributes.map((e) => _JSONAttribute.fromAttribute(e, configuration)).toList();

  @override
  void initialize(LogConfiguration configuration) {
    if (options.escapeForwardSlash) {
      /* set child escape properties to parent escape property */
      for (final e in _attributes) {
        e.source = JSONAttribute(
          name: e.name,
          layout: e.source.layout,
          encode: e.source.encode,
          escapeUnicode: e.source.escapeUnicode,
          escapeForwardSlash: true,
          includeEmptyValue: e.source.includeEmptyValue,
        );
      }
    }
    super.initialize(configuration);
  }

  @override
  void renderFormattedMessage(LogEventInfo logEvent, StringBuffer target) {
    final orgLength = target.length;
    _renderJsonFormattedMessage(logEvent, target);
    if (target.length == orgLength && options.renderEmptyObject) {
      target.write(options.suppressSpaces ? "{}" : "{ }");
    }
  }

  @override
  String? getFormattedMessage(LogEventInfo logEvent) {
    final sb = StringBuffer();
    renderFormattedMessage(logEvent, sb);
    return sb.toString();
  }

  void _renderJsonFormattedMessage(LogEventInfo logEvent, StringBuffer target) {
    final json = <String, dynamic>{};
    for (final attribute in _attributes) {
      final val = attribute.getFormattedMessage(logEvent);
      json[attribute.name] = val;
    }
    final jstr = JsonEncoder().convert(json);
    target.write(jstr);
  }

  factory JsonLayout.parseLayout(JSONLayoutOptions options, LogConfiguration configuration) {
    return JsonLayout(configuration: configuration, options: options);
  }

  // void _beginJsonProperty(StringBuffer sb, String propName, bool beginJsonMessage, {required bool ensureStringEscape}) {
  //   if (beginJsonMessage) {
  //     sb.write(options.suppressSpaces ? "{\"" : "{ \"");
  //   } else {
  //     sb.write(options.suppressSpaces ? ",\"" : ", \"");
  //   }

  //   if (ensureStringEscape) {
  //     _appendStringEscape(sb, propName, thing: false, escapeForwardSlash: false);
  //   }
  //   sb.write(propName);

  //   sb.write(options.suppressSpaces ? "\":" : "\": ");
  // }

  // void _completeJsonMessage(StringBuffer sb) {
  //   sb.write(options.suppressSpaces ? "}" : " }");
  // }

  // bool _renderAppendJsonPropertyValue(JSONAttribute attribute, LogEventInfo logEvent, StringBuffer sb, bool beginJsonMessage) {
  //   _beginJsonProperty(sb, attribute.name, beginJsonMessage, ensureStringEscape: false);
  //   if (!attribute.renderAppendJsonValue(logEvent, sb)) {
  //     return false;
  //   }
  //   return true;
  // }

  // static void _performJsonEscapeIfNeeded(StringBuffer sb, int valueStart, {required bool escapeForwardSlash}) {
  //   if ((sb.length - valueStart) <= 2) {
  //     return;
  //   }
  //   for (int i = valueStart; i < sb.length; i++) {
  //     if (_requiresJsonEscape(sb.elementAt(i), false, escapeForwardSlash)) {
  //       final jsonEscape = sb.substring(valueStart + 1, sb.length - (valueStart - 2));
  //       sb.truncate(valueStart);
  //       sb.write('"');
  //       _appendStringEscape(sb, jsonEscape, thing: false, escapeForwardSlash: escapeForwardSlash);
  //       break;
  //     }
  //   }
  // }

  // static bool _requiresJsonEscape(String char, bool thing, bool escapeForwardSlaash) {}

  // static bool _appendStringEscape(StringBuffer sb, String jsonEscape, {required bool thing, required bool escapeForwardSlash}) {}
}
