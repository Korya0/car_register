import 'package:car_register_app/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'app_test_helpers.dart';

void main() {
  setUpIntegrationTestBinding();

  group('Navigation and Empty State', () {
    setUp(() async {
      await setupTestInjector();
      await clearStorage();
    });

    tearDownAll(cleanUpTempDirs);

    testWidgets('show empty state when on list tab with no numbers', (
      WidgetTester tester,
    ) async {
      await pumpTestApp(tester);
      await tester.pumpAndSettle();

      await goToListTab(tester);

      expect(find.text(AppStrings.noPlatesRegistered), findsOneWidget);
      expect(find.text(AppStrings.startByAddingPlate), findsOneWidget);
    });

    testWidgets('switch between Add and List tabs via bottom nav bar', (
      WidgetTester tester,
    ) async {
      await pumpTestApp(tester);
      await tester.pumpAndSettle();

      expect(find.byType(TextFormField), findsOneWidget);

      await tester.tap(find.byIcon(Icons.list).first);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add).first);
      await tester.pumpAndSettle();

      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets(
      'empty state transitions to populated state after adding a number',
      (WidgetTester tester) async {
        await pumpTestApp(tester);
        await tester.pumpAndSettle();

        await goToListTab(tester);
        expect(find.text(AppStrings.noPlatesRegistered), findsOneWidget);

        await goToAddTab(tester);
        const carNumber = '22222222';
        await addCarNumber(tester, carNumber);

        await goToListTab(tester);
        expect(find.text(AppStrings.noPlatesRegistered), findsNothing);
        expect(find.text(carNumber), findsOneWidget);
      },
    );
  });
}
