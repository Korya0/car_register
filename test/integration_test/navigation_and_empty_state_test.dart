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

      // Default page is the Add tab; navigate to List to see empty state.
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

      // On the list tab we should see the list icon (not add) in nav bar
      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add).first);
      await tester.pumpAndSettle();

      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets(
      'empty state transitions to populated state after adding a number',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildTestApp());
        await tester.pumpAndSettle();

        // Check empty state on list tab
        await goToListTab(tester);
        expect(find.text(AppStrings.noPlatesRegistered), findsOneWidget);

        // Add a number from the Add tab
        await goToAddTab(tester);
        const carNumber = '22222222';
        await addCarNumber(tester, carNumber);

        // Navigate to List – should now show the number, not empty state
        await goToListTab(tester);
        expect(find.text(AppStrings.noPlatesRegistered), findsNothing);
        expect(find.text(carNumber), findsOneWidget);
      },
    );
  });
}
