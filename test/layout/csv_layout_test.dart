import 'package:flog3/src/logger/log_factory.dart';
import 'package:flog3/src/logger/logger.dart';
import 'package:flog3/src/target/debug_target.dart';
import 'package:test/test.dart';

void main() {
  // Additional setup goes here.
  LogFactory.initializeWithFile("test/data/config_a.json");
  final csv = LogFactory.getLogger('CSVLogger') as FLogger;

  group('CSV Layout Tests', () {
    final d = csv.targets.firstWhere((e) => e is DebugTarget && e.spec.name == "debugWithCSVLayout") as DebugTarget;
    setUp(() {});

    test("??", () {
      csv.info("inftest");
      final splits = d.logOutput.last.split('\t');
      expect(splits.length, 3);
      expect(DateTime.tryParse(splits.first) != null, true);
      expect(splits[1], "Info");
      expect(splits[2], "inftest");
    });
  });
}
