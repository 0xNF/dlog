import 'package:flog3/src/logger/log_factory.dart';
import 'package:test/test.dart';

void main() {
  group('Config Tests', () {
    setUp(() async {
      LogFactory.initializeWithFile("test/data/config_a.json");
    });

    test('Test that unusued target gets removed from runtime config', () {
      // TODO(nf): fixme
      expect(true, false);
    });
  });
}
