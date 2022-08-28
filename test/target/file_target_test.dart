import 'dart:convert';
import 'dart:io';

import 'package:flog3/flog3.dart';
import 'package:flog3/src/layout/csv/csv_layout_options.dart';
import 'package:flog3/src/layout/layout_spec.dart';
import 'package:flog3/src/logger/log_factory.dart';
import 'package:flog3/src/logger/logger.dart';
import 'package:flog3/src/target/debug/debug_target.dart';
import 'package:flog3/src/target/debug/debug_target_spec.dart';
import 'package:flog3/src/target/file/file_target.dart';
import 'package:flog3/src/target/file/file_target_spec.dart';
import 'package:test/test.dart';

void main() {
  final RegExp basicMatcher = RegExp(r"(?<Timestamp>\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d{4})\|(?<Level>[A-Za-z0-9]+)\|(?<LoggerName>[A-Za-z0-9]*)\|(?<Message>.*)(\|(?<EProps>.*))");

  LogFactory.initializeWithFile("test/data/config_a.json");
  final basic = LogFactory.getLogger('FileTargetLogger') as FLogger;

  group('Basic File Target Tests', () {
    setUp(() {
      basic.rules.clear();
      basic.targets.clear();
      final spec = FileTargetSpec(name: 'filetarget_test', fileName: 'test1.txt');
      Target t = FileTarget.fromSpec(spec, LogFactory.configuration!);
      basic.targets.add(t);
      basic.rules.add(Rule(loggerName: 'filetarget_testlogger', writeTo: 'filetarget_testtarget'));
    });

    tearDown(() {
      basic.rules.clear();
      basic.targets.clear();
    });

    test('Should write all the log levels to a file', () {
      basic.trace('testing_trace');
      basic.debug('testing_debug');
      basic.info('testing_info');
      basic.warn('testing_war');
      basic.error('testing_error');
      basic.fatal('testing_fatal');

      final lines = readFile('test1.txt');
      expect(basicMatcher.firstMatch(lines[0])?.namedGroup('Level'), "Trace");
      expect(basicMatcher.firstMatch(lines[1])?.namedGroup('Level'), "Debug");
      expect(basicMatcher.firstMatch(lines[2])?.namedGroup('Level'), "Info");
      expect(basicMatcher.firstMatch(lines[3])?.namedGroup('Level'), "Warn");
      expect(basicMatcher.firstMatch(lines[4])?.namedGroup('Level'), "Error");
      expect(basicMatcher.firstMatch(lines[4])?.namedGroup('Level'), "Fatal");
    });
  });
}

List<String> readFile(String filename, [Encoding encoding = const Utf8Codec()]) {
  final f = File(filename);
  final lines = f.readAsLinesSync(encoding: encoding);
  return lines;
}
