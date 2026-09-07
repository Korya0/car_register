import 'package:flutter_test/flutter_test.dart';

import 'app_test_helpers.dart';

void main() {
  setUpIntegrationTestBinding();

  group('Data Persistence', () {
    setUp(() async {
      await setupTestInjector();
      await clearStorage();
    });

    tearDownAll(cleanUpTempDirs);

    testWidgets('persist car number across app restart', (
      WidgetTester tester,
    ) async {
      await pumpTestApp(tester);
      await tester.pumpAndSettle();

      const carNumber = '77777777';
      await addCarNumber(tester, carNumber);
      await goToListTab(tester);

      expect(find.text(carNumber), findsOneWidget);

      await pumpTestApp(tester);
      await tester.pumpAndSettle();

      await goToListTab(tester);
      expect(find.text(carNumber), findsOneWidget);
    });
  });
}
