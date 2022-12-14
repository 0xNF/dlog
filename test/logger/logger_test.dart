import 'dart:io';

import 'package:dart_ilogger/dart_ilogger.dart';
import 'package:flog3/src/layout/layout_renderers/all_event_properties_layout_renderer.dart';
import 'package:flog3/src/layout/layout_renderers/level_layout_renderer.dart';
import 'package:flog3/src/layout/layout_renderers/literal_layout_renderer.dart';
import 'package:flog3/src/layout/layout_renderers/logger_name_layout_renderer.dart';
import 'package:flog3/src/layout/layout_renderers/longdate_layout_renderer.dart';
import 'package:flog3/src/layout/layout_renderers/message_layout_renderer.dart';
import 'package:flog3/src/layout/simple/layout_simple.dart';
import 'package:flog3/src/logger/log_factory.dart';
import 'package:flog3/src/logger/logger.dart';
import 'package:flog3/src/target/debug/debug_target.dart';
import 'package:flog3/src/target/specs/target_type.dart';
import 'package:flog3/src/target/target_with_layout_header_footer.dart';
import 'package:test/test.dart';

void main() {
  // Additional setup goes here.
  LogFactory.initializeWithFile("test/data/config_a.json");
  final basic = LogFactory.getLogger('SomeLogger') as FLogger;

  final RegExp basicMatcher = RegExp(r"(?<Timestamp>\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d{4})\|(?<Level>[A-Za-z0-9]+)\|(?<LoggerName>[A-Za-z0-9]*)\|(?<Message>.*)(\|(?<EProps>.*))");
  group('Basic Logger Tests', () {
    setUp(() {});

    test('Check logger name', () {
      expect(basic.name, "SomeLogger");
      expect((LogFactory.getLogger() as FLogger).name, "logger_test");
    });

    test("Check matching rules", () {
      expect(basic.rules.first.writeTo, "logconsole");
      expect(basic.rules[1].writeTo, "logfile");
      expect(basic.rules[2].writeTo, "logdebug");
    });

    test("Check matching targets", () {
      final targetLogFiile = basic.targets.firstWhere((e) => e.spec.name == "logfile");
      final targetConsole = basic.targets.firstWhere((e) => e.spec.name == "logconsole");
      expect(targetLogFiile.spec.type, TargetType.file);
      expect(targetConsole.spec.type, TargetType.console);
    });

    test("Check target renderers", () {
      final t = basic.targets.first as TargetWithLayoutHeaderAndFooter;
      final tlayout = t.layout as SimpleLayout;
      expect(tlayout.renderers.length, 9);
      expect(tlayout.renderers[0].name, LongDateLayoutRenderer.id);
      expect(tlayout.renderers[1].name, LiteralLayoutRenderer.id);
      expect(tlayout.renderers[2].name, LevelLayoutRenderer.id);
      expect(tlayout.renderers[3].name, LiteralLayoutRenderer.id);
      expect(tlayout.renderers[4].name, LoggerNameLayoutRenderer.id);
      expect(tlayout.renderers[5].name, LiteralLayoutRenderer.id);
      expect(tlayout.renderers[6].name, MessageLayoutRenderer.id);
      expect(tlayout.renderers[7].name, LiteralLayoutRenderer.id);
      expect(tlayout.renderers[8].name, AllEventPropertiesLayoutRenderer.id);
    });

    test("Check log levels", () {
      expect(basic.isDebugEnabled, true);
      expect(basic.isTraceEnabled, true);
      expect(basic.isInfoEnabled, true);
      expect(basic.isWarnEnabled, true);
      expect(basic.isErrorEnabled, true);
      expect(basic.isFatalEnabled, true);
    });

    test("Check all-literalables become actually all literals", () {
      final t = basic.targets.firstWhere((element) => element.spec.name == "debugWithThingsThatWillAllTurnIntoFixedText") as DebugTarget;
      basic.info("blahblahblah");
      final newLine = Platform.isWindows ? "\r\n" : "\n";
      final dirSep = Platform.pathSeparator;
      expect(t.logOutput.last, "literal$newLine$dirSep");
    });
  });

  group('Basic Output Tests', () {
    setUp(() {});

    test("Check basic output", () {
      final t = basic.targets.firstWhere((element) => element.spec.name == "logdebug") as DebugTarget;
      basic.info("A basic message");
      final matches = basicMatcher.allMatches(t.logOutput.last).first;
      expect(matches.groupCount, 6);
      expect(DateTime.tryParse(matches.namedGroup('Timestamp')!) != null, true);
      expect(LogLevel.fromString(matches.namedGroup('Level')!), LogLevel.info);
      expect(matches.namedGroup('LoggerName'), basic.name);
      expect(matches.namedGroup('Message'), "A basic message");
      expect(matches.namedGroup('EProps'), "");
    });

    test("Check Debug Level output", () {
      final t = basic.targets.firstWhere((element) => element.spec.name == "logdebug") as DebugTarget;
      basic.debug("A basic message");
      final matches = basicMatcher.allMatches(t.logOutput.last).first;
      expect(LogLevel.fromString(matches.namedGroup('Level')!), LogLevel.debug);
    });

    test("Check Info Level output", () {
      final t = basic.targets.firstWhere((element) => element.spec.name == "logdebug") as DebugTarget;
      basic.info("A basic message");
      final matches = basicMatcher.allMatches(t.logOutput.last).first;
      expect(LogLevel.fromString(matches.namedGroup('Level')!), LogLevel.info);
    });

    test("Check Warn Level output", () {
      final t = basic.targets.firstWhere((element) => element.spec.name == "logdebug") as DebugTarget;
      basic.warn("A basic message");
      final matches = basicMatcher.allMatches(t.logOutput.last).first;
      expect(LogLevel.fromString(matches.namedGroup('Level')!), LogLevel.warn);
    });

    test("Check Error Level output", () {
      final t = basic.targets.firstWhere((element) => element.spec.name == "logdebug") as DebugTarget;
      basic.error("A basic message");
      final matches = basicMatcher.allMatches(t.logOutput.last).first;
      expect(LogLevel.fromString(matches.namedGroup('Level')!), LogLevel.error);
    });

    test("Check Fatal Level output", () {
      final t = basic.targets.firstWhere((element) => element.spec.name == "logdebug") as DebugTarget;
      basic.fatal("A basic message");
      final matches = basicMatcher.allMatches(t.logOutput.last).first;
      expect(LogLevel.fromString(matches.namedGroup('Level')!), LogLevel.fatal);
    });
  });
}
