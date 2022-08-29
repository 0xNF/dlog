import 'dart:convert';

import 'package:dart_ilogger/dart_ilogger.dart';
import 'package:flog3/flog3.dart';
import 'package:flog3/src/layout/json/json_layout_options.dart';
import 'package:flog3/src/layout/layout_spec.dart';
import 'package:flog3/src/logger/log_factory.dart';
import 'package:flog3/src/logger/logger.dart';
import 'package:flog3/src/target/debug/debug_target.dart';
import 'package:flog3/src/target/debug/debug_target_spec.dart';
import 'package:test/test.dart';

void main() {
  // Additional setup goes here.
  LogFactory.initializeWithFile("test/data/config_a.json");

  group("Json Layout Tests", () {
    test('Test basic layout rendering', () {
      final opts = JSONLayoutOptions();
      final lspec = LayoutSpec(kind: LayoutKind.json, options: opts, layout: '');
      final d2 = DebugTarget.fromSpec(DebugTargetSpec(name: 'default', layout: lspec), LogFactory.configuration!);
      d2.initialize(LogFactory.configuration!);
      final _logger = FLogger('jsonLogger', [Rule(loggerName: 'jsonLogger', writeTo: d2.spec.name)], [d2]);

      _logger.info("basic text");

      final jstr = d2.logOutput.last;
      final json = const JsonDecoder().convert(jstr) as Map<String, dynamic>;
      assert(DateTime.tryParse(json["Time"] as String) != null);
      expect(LogLevel.fromString(json["Level"] as String), LogLevel.info);
      expect(json["Logger"] as String, "jsonLogger");
      expect(json["Message"] as String, "basic text");
    });

    test('Test with basic event property subsitution', () {
      final opts = JSONLayoutOptions();
      final lspec = LayoutSpec(kind: LayoutKind.json, options: opts, layout: '');
      final d2 = DebugTarget.fromSpec(DebugTargetSpec(name: 'default', layout: lspec), LogFactory.configuration!);
      d2.initialize(LogFactory.configuration!);
      final _logger = FLogger('jsonLogger', [Rule(loggerName: 'jsonLogger', writeTo: d2.spec.name)], [d2]);

      _logger.info("propval should be {propval}", eventProperties: {'propval': 'hello'});

      String jstr = d2.logOutput.last;
      Map<String, dynamic> json = const JsonDecoder().convert(jstr) as Map<String, dynamic>;
      expect(json["Message"] as String, 'propval should be hello');

      _logger.info("Some digit should be {digit}", eventProperties: {'digit': 2});
      jstr = d2.logOutput.last;
      json = const JsonDecoder().convert(jstr) as Map<String, dynamic>;
      expect(json["Message"], "Some digit should be 2");
    });

    test('Test with event props, also formatted as json', () {
      final opts = JSONLayoutOptions();
      final lspec = LayoutSpec(kind: LayoutKind.json, options: opts, layout: '');
      final d2 = DebugTarget.fromSpec(DebugTargetSpec(name: 'default', layout: lspec), LogFactory.configuration!);
      d2.initialize(LogFactory.configuration!);
      final _logger = FLogger('jsonLogger', [Rule(loggerName: 'jsonLogger', writeTo: d2.spec.name)], [d2]);

      _logger.info("basic text", eventProperties: {'prop1': 'val1', 'prop2': 2});

      final jstr = d2.logOutput.last;
      print(jstr);
      final json = const JsonDecoder().convert(jstr) as Map<String, dynamic>;
      assert(DateTime.tryParse(json["Time"] as String) != null);
      expect(LogLevel.fromString(json["Level"] as String), LogLevel.info);
      expect(json["Logger"] as String, "jsonLogger");
      expect(json["Message"] as String, "basic text");
    });
  });
}
