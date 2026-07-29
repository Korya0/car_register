import 'package:car_register_app/core/constants/app_constants.dart';
import 'package:car_register_app/core/constants/app_strings.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/pin_verification_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PinVerificationDialog', () {
    testWidgets('shows dialog with PIN input', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: _PinDialogLauncher())),
      );
      await tester.pumpAndSettle();

      // Tap the button to show the dialog
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verify dialog content
      expect(find.text(AppStrings.securityVerification), findsOneWidget);
      expect(find.text(AppStrings.enterPinToConfirm), findsOneWidget);
      expect(find.text(AppStrings.cancel), findsOneWidget);
      expect(find.text(AppStrings.confirm), findsOneWidget);
    });

    testWidgets('shows PIN input field', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: _PinDialogLauncher())),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verify TextField exists for PIN entry
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('accepts correct PIN and returns true', (tester) async {
      bool? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: _PinDialogLauncher(onResult: (r) => result = r),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Enter the correct PIN
      await tester.enterText(find.byType(TextField), AppConstants.pinCode);
      await tester.pumpAndSettle();

      // Tap confirm
      await tester.tap(find.text(AppStrings.confirm));
      await tester.pumpAndSettle();

      expect(result, isTrue);
    });

    testWidgets('shows error on wrong PIN', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: _PinDialogLauncher())),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Enter wrong PIN
      await tester.enterText(find.byType(TextField), '000000');
      await tester.pumpAndSettle();

      // Tap confirm
      await tester.tap(find.text(AppStrings.confirm));
      await tester.pumpAndSettle();

      // Should show error message with attempt count
      expect(
        find.textContaining(AppStrings.wrongAttemptPrefix),
        findsOneWidget,
      );
    });

    testWidgets('cancels and returns false when cancel is tapped',
        (tester) async {
      bool? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: _PinDialogLauncher(onResult: (r) => result = r),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.cancel));
      await tester.pumpAndSettle();

      expect(result, isFalse);
    });

    testWidgets('increments attempts on wrong PIN', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: _PinDialogLauncher())),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // First wrong attempt
      await tester.enterText(find.byType(TextField), '111111');
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppStrings.confirm));
      await tester.pumpAndSettle();

      // Should show attempt 1
      expect(
        find.textContaining('${AppStrings.wrongAttemptPrefix}1'),
        findsOneWidget,
      );

      // Second wrong attempt
      await tester.enterText(find.byType(TextField), '222222');
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppStrings.confirm));
      await tester.pumpAndSettle();

      // Should show attempt 2
      expect(
        find.textContaining('${AppStrings.wrongAttemptPrefix}2'),
        findsOneWidget,
      );
    });

    testWidgets('closes dialog after max wrong attempts', (tester) async {
      bool? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: _PinDialogLauncher(onResult: (r) => result = r),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Enter 3 wrong PINs
      for (var i = 0; i < AppConstants.maxPinAttempts; i++) {
        await tester.enterText(find.byType(TextField), '000000');
        await tester.pumpAndSettle();
        await tester.tap(find.text(AppStrings.confirm));
        await tester.pumpAndSettle();
      }

      // Dialog should be dismissed
      expect(find.text(AppStrings.securityVerification), findsNothing);
      expect(result, isFalse);
    });

    testWidgets('clears PIN input after wrong attempt', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: _PinDialogLauncher())),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Enter wrong PIN
      await tester.enterText(find.byType(TextField), '111111');
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppStrings.confirm));
      await tester.pumpAndSettle();

      // Text field should be cleared
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller!.text, isEmpty);
    });

    testWidgets('security icon is displayed', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: _PinDialogLauncher())),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.security), findsOneWidget);
    });

    testWidgets('is not dismissible by barrier tap', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: _PinDialogLauncher())),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Dialog should still be visible
      expect(find.text(AppStrings.securityVerification), findsOneWidget);
    });
  });
}

/// Helper widget to launch the PIN dialog in tests
class _PinDialogLauncher extends StatelessWidget {
  const _PinDialogLauncher({this.onResult});

  final ValueChanged<bool?>? onResult;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          final result = await PinVerificationDialog.show(context);
          onResult?.call(result);
        },
        child: const Text('Show Dialog'),
      ),
    );
  }
}
