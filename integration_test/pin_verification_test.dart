import 'package:car_register_app/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'app_test_helpers.dart';

void main() {
  setUpIntegrationTestBinding();

  group('PIN Verification Dialog Scenarios', () {
    setUp(() async {
      await setupTestInjector();
      await clearStorage();
    });

    tearDownAll(cleanUpTempDirs);

    testWidgets(
      'show attempt counter on wrong PIN and dismiss after max attempts',
      (WidgetTester tester) async {
        await pumpTestApp(tester);
        await tester.pumpAndSettle();

        const carNumber = '55555555';
        await addCarNumber(tester, carNumber);
        await goToListTab(tester);
        expect(find.text(carNumber), findsOneWidget);

        await tester.longPress(find.text(carNumber));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.delete_forever).first);
        await tester.pumpAndSettle();

        await tester.tap(find.text(AppStrings.proceed));
        await tester.pumpAndSettle();

        expect(find.text(AppStrings.securityVerification), findsOneWidget);

        // Attempt 1: wrong PIN
        await tester.enterText(
          find.byType(TextField).first,
          '000000',
        );
        await tester.pumpAndSettle();

        await tester.tap(
          find.descendant(
            of: find.byType(ElevatedButton),
            matching: find.text(AppStrings.confirm),
          ).first,
        );
        await tester.pumpAndSettle();

        expect(
          find.textContaining('${AppStrings.wrongAttemptPrefix}1'),
          findsOneWidget,
        );

        // Attempt 2: wrong PIN
        await tester.enterText(
          find.byType(TextField).first,
          '111111',
        );
        await tester.pumpAndSettle();

        await tester.tap(
          find.descendant(
            of: find.byType(ElevatedButton),
            matching: find.text(AppStrings.confirm),
          ).first,
        );
        await tester.pumpAndSettle();

        expect(
          find.textContaining('${AppStrings.wrongAttemptPrefix}2'),
          findsOneWidget,
        );

        // Attempt 3: wrong PIN (max attempts)
        await tester.enterText(
          find.byType(TextField).first,
          '222222',
        );
        await tester.pumpAndSettle();

        await tester.tap(
          find.descendant(
            of: find.byType(ElevatedButton),
            matching: find.text(AppStrings.confirm),
          ).first,
        );
        await tester.pumpAndSettle();

        expect(find.text(AppStrings.securityVerification), findsNothing);
        expect(find.text(carNumber), findsOneWidget);
      },
    );

    testWidgets(
      'dismiss PIN dialog without action when cancel is tapped',
      (WidgetTester tester) async {
        await pumpTestApp(tester);
        await tester.pumpAndSettle();

        const carNumber = '44444444';
        await addCarNumber(tester, carNumber);
        await goToListTab(tester);
        expect(find.text(carNumber), findsOneWidget);

        await tester.longPress(find.text(carNumber));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.delete_forever).first);
        await tester.pumpAndSettle();

        await tester.tap(find.text(AppStrings.proceed));
        await tester.pumpAndSettle();

        expect(find.text(AppStrings.securityVerification), findsOneWidget);

        await tester.tap(find.text(AppStrings.cancel).first);
        await tester.pumpAndSettle();

        expect(find.text(AppStrings.securityVerification), findsNothing);
        expect(find.text(carNumber), findsOneWidget);
      },
    );
  });
}
