import 'package:flog3/src/logger/log_factory.dart';
import 'package:flog3/src/logger/logger.dart';
import 'package:flog3/src/target/debug/debug_target.dart';
import 'package:test/test.dart';

void main() {
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
      assert(false);
    });
  });

  group('csv delimeter tests', () {
    test("Check Semicolon delim", () {
      assert(false);
    });
    test("Check Comma delim", () {
      assert(false);
    });

    test("Check Pipe delim", () {
      assert(false);
    });

    test("Check Space delim", () {
      assert(false);
    });

    test("Check Auto delim", () {
      assert(false);
    });
  });

  group('csv quote tests', () {
    test("Check different Quote char", () {
      assert(false);
    });

    test("Check Quote Enum All", () {
      assert(false);
    });

    test("Check Quote Enum Auto", () {
      assert(false);
    });

    test("Check Quote Enum None", () {
      assert(false);
    });
  });
}
