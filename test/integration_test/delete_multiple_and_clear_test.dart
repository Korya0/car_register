import 'package:car_register_app/core/constants/app_constants.dart';
import 'package:car_register_app/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'app_test_helpers.dart';

void main() {
  setUpIntegrationTestBinding();

  group('Delete Multiple and Clear All', () {
    setUp(() async {
      await setupTestInjector();
      await clearStorage();
    });

    tearDownAll(cleanUpTempDirs);

    testWidgets(
      'select multiple car numbers and delete with PIN',
      (WidgetTester tester) async {
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

        await tester.longPress(find.text(number1));
        await tester.pumpAndSettle();

        expect(find.text(AppStrings.selected), findsOneWidget);

        // Select all items so that the batch-delete covers every number.
        await tester.tap(find.text(AppStrings.selectAll));
        await tester.pumpAndSettle();

        // Tap the labelled delete button in the selection bar (not a card icon).
        await tester.tap(
          find.descendant(
            of: find.byType(TextButton),
            matching: find.text(AppStrings.delete),
          ).first,
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text(AppStrings.proceed));
        await tester.pumpAndSettle();

        expect(find.text(AppStrings.securityVerification), findsOneWidget);

        await tester.enterText(
          find.byType(TextField).first,
          AppConstants.pinCode,
        );
        await tester.pumpAndSettle();

        await tester.tap(
          find.descendant(
            of: find.byType(ElevatedButton),
            matching: find.text(AppStrings.confirm),
          ).first,
        );
        await tester.pumpAndSettle();

        expect(find.text(number1), findsNothing);
        expect(find.text(number2), findsNothing);
        expect(find.text(number3), findsNothing);
        expect(find.text(AppStrings.deletedSuccessfully), findsOneWidget);
      },
    );

    testWidgets(
      'select all numbers and see selection UI',
      (WidgetTester tester) async {
        await pumpTestApp(tester);
        await tester.pumpAndSettle();

        const number1 = '20000001';
        const number2 = '20000002';

        await addCarNumber(tester, number1);
        await addCarNumber(tester, number2);

        await goToListTab(tester);

        await tester.longPress(find.text(number1));
        await tester.pumpAndSettle();

        expect(find.text(AppStrings.selected), findsOneWidget);
      },
    );

    testWidgets(
      'clear all car numbers with PIN verification',
      (WidgetTester tester) async {
        await pumpTestApp(tester);
        await tester.pumpAndSettle();

        const carNumber = '30000003';

        await addCarNumber(tester, carNumber);
        await goToListTab(tester);
        expect(find.text(carNumber), findsOneWidget);
        await goToAddTab(tester);

        await tester.longPress(find.text(AppStrings.savePlate));
        await tester.pumpAndSettle();

        expect(find.text(AppStrings.confirmClearAll), findsOneWidget);

        await tester.tap(
          find.descendant(
            of: find.byType(ElevatedButton),
            matching: find.text(AppStrings.proceed),
          ).first,
        );
        await tester.pumpAndSettle();

        expect(find.text(AppStrings.securityVerification), findsOneWidget);

        await tester.enterText(
          find.byType(TextField).first,
          AppConstants.pinCode,
        );
        await tester.pumpAndSettle();

        await tester.tap(
          find.descendant(
            of: find.byType(ElevatedButton),
            matching: find.text(AppStrings.confirm),
          ).first,
        );
        await tester.pumpAndSettle();
        // Wait for both success toasts (BlocListener + _handleClearAllWithPIN)
        // to fully dismiss before navigating to the list tab.
        await waitForToastDismiss(tester);

        await goToListTab(tester);
        expect(find.text(AppStrings.noPlatesRegistered), findsOneWidget);
      },
    );
  });
}
