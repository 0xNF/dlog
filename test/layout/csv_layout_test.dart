import 'package:flog3/flog3.dart';
import 'package:flog3/src/layout/csv/csv_layout_options.dart';
import 'package:flog3/src/layout/layout_spec.dart';
import 'package:flog3/src/logger/log_factory.dart';
import 'package:flog3/src/logger/logger.dart';
import 'package:flog3/src/target/debug/debug_target.dart';
import 'package:flog3/src/target/debug/debug_target_spec.dart';
import 'package:test/test.dart';

void main() {
  final List<CSVColumn> cols = [
    CSVColumn(name: 'time', layout: r"${longdate}"),
    CSVColumn(name: 'level', layout: r"${level}"),
    CSVColumn(name: 'message', layout: r"${message}"),
  ];

  // Additional setup goes here.
  LogFactory.initializeWithFile("test/data/config_a.json");
  final csv = LogFactory.getLogger('CSVLogger') as FLogger;

  final d = csv.targets.firstWhere((e) => e is DebugTarget && e.spec.name == "debugWithCSVLayout") as DebugTarget;

  group('CSV Layout Tests', () {
    setUp(() {});

    test("Check basic three column tab-delim output", () {
      csv.info("inftest");
      final splits = d.logOutput.last.split('\t');
      expect(splits.length, 3);
      expect(DateTime.tryParse(splits.first) != null, true);
      expect(splits[1], "Info");
      expect(splits[2], "inftest");
    });

    test("Check Header", () {
      final opts = CSVLayoutOptions(
        columns: cols,
        withHeader: true,
      );
      final lspec = LayoutSpec(kind: LayoutKind.csv, layout: "", options: opts);
      final d2 = DebugTarget.fromSpec(DebugTargetSpec(name: 'withHeader', layout: lspec), LogFactory.configuration!);
      d2.initializeTarget();
      final splits = d2.logOutput.first.split(',');
      expect(splits[0], "time");
      expect(splits[1], "level");
      expect(splits[2], "message");
    });
  });

  group('csv delimeter tests', () {
    tearDown(() {});

    test("Check Custom delim", () {
      final String targetName = "DollarDelim";
      final opts = CSVLayoutOptions(delimeter: DelimeterEnum.custom, columns: cols, customColumnDelimiter: r'$');
      final lspec = LayoutSpec(kind: LayoutKind.csv, layout: "", options: opts);
      final d2 = DebugTarget.fromSpec(DebugTargetSpec(name: targetName, layout: lspec), LogFactory.configuration!);
      final l = FLogger('testLogger', [Rule(loggerName: 'testLogger', writeTo: targetName)], [d2]);

      l.info("dollar");

      expect(d2.logOutput.last.contains(r'$'), true);
      expect(d2.logOutput.last.split(r'$').length, 3);
    });
    test("Check Semicolon delim", () {
      final String targetName = "semicolon";
      final opts = CSVLayoutOptions(delimeter: DelimeterEnum.semicolon, columns: cols);
      final lspec = LayoutSpec(kind: LayoutKind.csv, layout: "", options: opts);
      final d2 = DebugTarget.fromSpec(DebugTargetSpec(name: targetName, layout: lspec), LogFactory.configuration!);
      final l = FLogger('testLogger', [Rule(loggerName: 'testLogger', writeTo: targetName)], [d2]);

      l.info("semicolon");

      expect(d2.logOutput.last.contains(';'), true);
      expect(d2.logOutput.last.split(';').length, 3);
    });

    test("Check Comma delim", () {
      final String targetName = "comma";
      final opts = CSVLayoutOptions(delimeter: DelimeterEnum.comma, columns: cols);
      final lspec = LayoutSpec(kind: LayoutKind.csv, layout: "", options: opts);
      final d2 = DebugTarget.fromSpec(DebugTargetSpec(name: targetName, layout: lspec), LogFactory.configuration!);
      final l = FLogger('testLogger', [Rule(loggerName: 'testLogger', writeTo: targetName)], [d2]);

      l.info("comma");

      expect(d2.logOutput.last.contains(','), true);
      expect(d2.logOutput.last.split(',').length, 3);
    });

    test("Check Pipe delim", () {
      final String targetName = "pipe";
      final opts = CSVLayoutOptions(delimeter: DelimeterEnum.pipe, columns: cols);
      final lspec = LayoutSpec(kind: LayoutKind.csv, layout: "", options: opts);
      final d2 = DebugTarget.fromSpec(DebugTargetSpec(name: targetName, layout: lspec), LogFactory.configuration!);
      final l = FLogger('testLogger', [Rule(loggerName: 'testLogger', writeTo: targetName)], [d2]);

      l.info("pipe");

      expect(d2.logOutput.last.contains('|'), true);
      expect(d2.logOutput.last.split('|').length, 3);
    });

    test("Check Space delim", () {
      final String targetName = "space";
      final opts = CSVLayoutOptions(delimeter: DelimeterEnum.pipe, columns: cols);
      final lspec = LayoutSpec(kind: LayoutKind.csv, layout: "", options: opts);
      final d2 = DebugTarget.fromSpec(DebugTargetSpec(name: targetName, layout: lspec), LogFactory.configuration!);
      final l = FLogger('testLogger', [Rule(loggerName: 'testLogger', writeTo: targetName)], [d2]);

      l.info(" ");

      expect(d2.logOutput.last.contains(' '), true);
      expect(d2.logOutput.last.split(' ').length, 3);
    });

    test("Check Auto delim", () {
      // TODO(nf): implement region detection for autp
      final String targetName = "auto";
      final opts = CSVLayoutOptions(delimeter: DelimeterEnum.auto, columns: cols);
      final lspec = LayoutSpec(kind: LayoutKind.csv, layout: "", options: opts);
      final d2 = DebugTarget.fromSpec(DebugTargetSpec(name: targetName, layout: lspec), LogFactory.configuration!);
      final l = FLogger('testLogger', [Rule(loggerName: 'testLogger', writeTo: targetName)], [d2]);

      l.info("auto");

      expect(d2.logOutput.last.contains(','), true);
      expect(d2.logOutput.last.split(',').length, 3);
    });
  });

  group('csv quote tests', () {
    test("Check different Quote char", () {
      final String targetName = "Different Quote";
      final opts = CSVLayoutOptions(columns: cols, quoteChar: '%', quoting: QuoteEnum.all);
      final lspec = LayoutSpec(kind: LayoutKind.csv, layout: "", options: opts);
      final d2 = DebugTarget.fromSpec(DebugTargetSpec(name: targetName, layout: lspec), LogFactory.configuration!);
      final l = FLogger('testLogger', [Rule(loggerName: 'testLogger', writeTo: targetName)], [d2]);

      l.info('hello');

      final splots = d2.logOutput.last.split(',');
      expect(splots[1], '%Info%'); /* quotes */
    });

    test("Check Quote Enum All", () {
      /* TODO(nf): this is producing triple quotes -- is this correct? */
      final String targetName = "All quote";
      final opts = CSVLayoutOptions(columns: cols, quoting: QuoteEnum.all);
      final lspec = LayoutSpec(kind: LayoutKind.csv, layout: "", options: opts);
      final d2 = DebugTarget.fromSpec(DebugTargetSpec(name: targetName, layout: lspec), LogFactory.configuration!);
      final l = FLogger('testLogger', [Rule(loggerName: 'testLogger', writeTo: targetName)], [d2]);

      l.info('"hello"');

      final splots = d2.logOutput.last.split(',');
      expect(splots[1], '"Info"'); /* quotes */
      expect(splots[2], '"""hello"""'); /* double quotes due to inner quotes*/
    });

    test("Check Quote Enum Auto", () {
      /* TODO(nf): this is producing quad quotes -- is this correct? */
      final String targetName = "All quote";
      final opts = CSVLayoutOptions(columns: cols, quoting: QuoteEnum.auto);
      final lspec = LayoutSpec(kind: LayoutKind.csv, layout: "", options: opts);
      final d2 = DebugTarget.fromSpec(DebugTargetSpec(name: targetName, layout: lspec), LogFactory.configuration!);
      final l = FLogger('testLogger', [Rule(loggerName: 'testLogger', writeTo: targetName)], [d2]);

      l.info('"hello"');

      final splots = d2.logOutput.last.split(',');
      expect(splots[1], 'Info'); /* no quotes */
      expect(splots[2], '"""hello"""');
      /* double quotes due to inner quotes*/
    });

    test("Check Quote Enum None", () {
      final String targetName = "No quote";
      final opts = CSVLayoutOptions(columns: cols, quoting: QuoteEnum.none);
      final lspec = LayoutSpec(kind: LayoutKind.csv, layout: "", options: opts);
      final d2 = DebugTarget.fromSpec(DebugTargetSpec(name: targetName, layout: lspec), LogFactory.configuration!);
      final l = FLogger('testLogger', [Rule(loggerName: 'testLogger', writeTo: targetName)], [d2]);

      l.info('"hello"');

      final splots = d2.logOutput.last.split(',');
      expect(splots.last, '"hello"'); /* no escaped quotes */
    });
  });
}
