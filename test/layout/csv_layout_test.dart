import 'package:flog3/src/logger/log_factory.dart';
import 'package:flog3/src/logger/logger.dart';
import 'package:test/test.dart';

void main() {
  // Additional setup goes here.
  LogFactory.initializeWithFile("test/data/config_a.json");
  final csv = LogFactory.getLogger('CSVLogger') as FLogger;

  group('CSV Layout Tests', () {
    setUp(() {});

    test('Check logger name', () {
      expect(csv.name, "SomeLogger");
    });

    test("??", () {});
  });
}
