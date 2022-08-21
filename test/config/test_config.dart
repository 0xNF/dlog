import 'package:flog3/src/logger/log_factory.dart';
import 'package:test/test.dart';

void main() {
  group('Config Tests', () {
    setUp(() async {
      LogFactory.initializeWithFile("test/data/config_a.json");
    });

    test('Deserialize Rule', () {
      final _logger = LogFactory.getLogger("RandomConsoleLogger");
      _logger.info('testing output to console');
    });
  });
}
