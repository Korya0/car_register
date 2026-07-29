import 'package:car_register_app/core/constants/app_strings.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/car_number_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators', () {
    group('isDigitsOnly', () {
      test('returns true for numeric string', () {
        expect(Validators.isDigitsOnly('123'), isTrue);
      });

      test('returns false for string with letters', () {
        expect(Validators.isDigitsOnly('12a'), isFalse);
      });

      test('returns false for empty string', () {
        expect(Validators.isDigitsOnly(''), isFalse);
      });

      test('returns false for string with special characters', () {
        expect(Validators.isDigitsOnly('12#'), isFalse);
      });
    });

    group('validateCarNumber', () {
      test('returns error for null value', () {
        final result = Validators.validateCarNumber(null);
        expect(result, equals(AppStrings.validationEnterCarNumber));
      });

      test('returns error for empty value', () {
        final result = Validators.validateCarNumber('');
        expect(result, equals(AppStrings.validationEnterCarNumber));
      });

      test('returns error for whitespace-only value', () {
        final result = Validators.validateCarNumber('   ');
        expect(result, equals(AppStrings.validationEnterCarNumber));
      });

      test('returns error for non-digit characters', () {
        final result = Validators.validateCarNumber('12A34');
        expect(result, equals(AppStrings.validationDigitsOnly));
      });

      test('returns error for Arabic letters', () {
        final result = Validators.validateCarNumber('مرحبا');
        expect(result, equals(AppStrings.validationDigitsOnly));
      });

      test('returns null for valid number (1 digit)', () {
        final result = Validators.validateCarNumber('1');
        expect(result, isNull);
      });

      test('returns null for valid number (8 digits)', () {
        final result = Validators.validateCarNumber('12345678');
        expect(result, isNull);
      });

      test('returns null for valid number after trimming whitespace', () {
        final result = Validators.validateCarNumber(' 12345 ');
        expect(result, isNull);
      });

      test('returns error for number longer than 8 digits', () {
        final result = Validators.validateCarNumber('123456789');
        expect(result, equals(AppStrings.validationCarNumberLength));
      });
    });
  });

  group('CarNumberTextField', () {
    testWidgets('renders with hint text', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CarNumberTextField(controller: controller),
          ),
        ),
      );

      expect(find.text(AppStrings.enterPlateNumber), findsOneWidget);
      controller.dispose();
    });

    testWidgets('displays the controller text', (tester) async {
      final controller = TextEditingController(text: '12345');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CarNumberTextField(controller: controller),
          ),
        ),
      );

      expect(find.text('12345'), findsOneWidget);
      controller.dispose();
    });

    testWidgets('is read-only (cannot type)', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CarNumberTextField(controller: controller),
          ),
        ),
      );

      // TextFormField wraps a TextField internally
      final textField = tester.widget<TextField>(
        find.descendant(
          of: find.byType(TextFormField),
          matching: find.byType(TextField),
        ),
      );
      expect(textField.readOnly, isTrue);
      controller.dispose();
    });

    testWidgets('has digits-only keyboard type', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CarNumberTextField(controller: controller),
          ),
        ),
      );

      final textField = tester.widget<TextField>(
        find.descendant(
          of: find.byType(TextFormField),
          matching: find.byType(TextField),
        ),
      );
      expect(textField.keyboardType, equals(TextInputType.none));
      controller.dispose();
    });

    testWidgets('renders with custom hint text', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CarNumberTextField(
              controller: controller,
              hintText: 'أدخل الرقم',
            ),
          ),
        ),
      );

      expect(find.text('أدخل الرقم'), findsOneWidget);
      controller.dispose();
    });

    testWidgets('renders with suffix icon', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CarNumberTextField(controller: controller),
          ),
        ),
      );

      expect(find.byIcon(Icons.directions_car), findsOneWidget);
      controller.dispose();
    });

    testWidgets('validates input with Validators', (tester) async {
      final formKey = GlobalKey<FormState>();
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: CarNumberTextField(controller: controller),
            ),
          ),
        ),
      );

      formKey.currentState!.validate();
      await tester.pump();

      expect(find.text(AppStrings.validationEnterCarNumber), findsOneWidget);
      controller.dispose();
    });
  });
}
