import 'package:car_register_app/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'app_test_helpers.dart';

void main() {
  setUpIntegrationTestBinding();

  group('Delete Single Car Number', () {
    setUp(() async {
      await setupTestInjector();
      await clearStorage();
    });

    tearDownAll(cleanUpTempDirs);

    testWidgets('delete a car number via confirmation dialog', (
      WidgetTester tester,
    ) async {
      await pumpTestApp(tester);
      await tester.pumpAndSettle();

      const carNumber = '87654321';
      await addCarNumberAndVerifyOnList(tester, carNumber);

      await tester.tap(find.byIcon(Icons.delete_forever).first);
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.confirmDelete), findsOneWidget);
      expect(
        find.text(
          '${AppStrings.confirmDeleteSinglePrefix}$carNumber${AppStrings.confirmDeleteSingleSuffix}',
        ),
        findsOneWidget,
      );

      await tester.tap(find.text(AppStrings.cancel));
      await tester.pumpAndSettle();

      expect(find.text(carNumber), findsOneWidget);
    });

    testWidgets('confirm delete and verify number is removed', (
      WidgetTester tester,
    ) async {
      await pumpTestApp(tester);
      await tester.pumpAndSettle();

      const carNumber = '88888888';
      await addCarNumberAndVerifyOnList(tester, carNumber);

      await tester.tap(find.byIcon(Icons.delete_forever).first);
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.delete).last);
      await tester.pumpAndSettle();

      expect(find.text(carNumber), findsNothing);
    });
  });
}
