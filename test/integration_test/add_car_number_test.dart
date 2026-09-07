import 'package:car_register_app/core/constants/app_strings.dart';
import 'package:flutter_test/flutter_test.dart';

import 'app_test_helpers.dart';

void main() {
  setUpIntegrationTestBinding();

  group('Add Car Number', () {
    setUp(() async {
      await setupTestInjector();
      await clearStorage();
    });

    tearDownAll(cleanUpTempDirs);

    testWidgets('add a car number and verify it appears in the list', (
      WidgetTester tester,
    ) async {
      await pumpTestApp(tester);
      await tester.pumpAndSettle();

      const carNumber = '12345678';
      await addCarNumberAndVerifyOnList(tester, carNumber);
    });

    testWidgets('show success toast message when adding car number', (
      WidgetTester tester,
    ) async {
      await pumpTestApp(tester);
      await tester.pumpAndSettle();

      const carNumber = '99999999';
      await enterNumberViaKeypad(tester, carNumber);
      await tester.ensureVisible(find.text(AppStrings.savePlate));
      await tester.pump();
      await tester.tap(find.text(AppStrings.savePlate));
      await tester.pump();

      expect(find.text(AppStrings.savedSuccessfully), findsOneWidget);
      await tester.pump(const Duration(seconds: 4));
    });

    testWidgets('show validation error for empty car number submit', (
      WidgetTester tester,
    ) async {
      await pumpTestApp(tester);
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.savePlate));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.validationEnterCarNumber), findsOneWidget);
    });

    testWidgets('show validation error for non-digit car number', (
      WidgetTester tester,
    ) async {
      await pumpTestApp(tester);
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.savePlate));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.validationEnterCarNumber), findsOneWidget);
    });

    testWidgets('show validation error for too long car number', (
      WidgetTester tester,
    ) async {
      await pumpTestApp(tester);
      await tester.pumpAndSettle();

      const carNumber = '12345678';
      await addCarNumberAndVerifyOnList(tester, carNumber);
    });

    testWidgets('show error toast when adding duplicate car number', (
      WidgetTester tester,
    ) async {
      await pumpTestApp(tester);
      await tester.pumpAndSettle();

      const carNumber = '66666666';
      await addCarNumber(tester, carNumber);
      await goToListTab(tester);
      expect(find.text(carNumber), findsOneWidget);
      await goToAddTab(tester);

      await enterNumberViaKeypad(tester, carNumber);
      await tester.ensureVisible(find.text(AppStrings.savePlate));
      await tester.pump();
      await tester.tap(find.text(AppStrings.savePlate));
      await tester.pump();

      expect(find.text(AppStrings.plateNumberAlreadyExists), findsOneWidget);
    });

    testWidgets('add multiple car numbers and verify all appear', (
      WidgetTester tester,
    ) async {
      await pumpTestApp(tester);
      await tester.pumpAndSettle();

      const number1 = '10000001';
      const number2 = '10000002';
      const number3 = '10000003';

      await addCarNumber(tester, number1);
      await addCarNumber(tester, number2);
      await addCarNumber(tester, number3);

      await goToListTab(tester);
      expect(find.text(number1), findsOneWidget);
      expect(find.text(number2), findsOneWidget);
      expect(find.text(number3), findsOneWidget);
    });
  });
}
