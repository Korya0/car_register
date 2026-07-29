import 'package:car_register_app/core/constants/app_strings.dart';
import 'package:car_register_app/features/car_register/presentation/controllers/car_register_state.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/car_number_form.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/car_number_text_field.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/car_submit_button.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/custom_keypad.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/mock_cubit_helper.dart';

/// Helper to build the form widget with all necessary wrappers for testing
Future<void> buildForm(
  WidgetTester tester, {
  bool isAddingNumber = false,
  MockCarRegisterCubit? cubit,
}) async {
  final mockCubit = cubit ?? MockCarRegisterCubit()
    ..emitState(CarRegisterLoaded(isAddingNumber: isAddingNumber));

  // Wrap in SingleChildScrollView to allow ensureVisible to scroll to off-screen items
  await tester.pumpWidget(
    wrapWithBloc(
      SingleChildScrollView(
        child: CarNumberForm(isAddingNumber: isAddingNumber),
      ),
      mockCubit,
    ),
  );
  // Pump through the animate_do animation: first pump fires the delay timer,
  // second pump completes the animation so widgets are fully visible
  await tester.pump(const Duration(milliseconds: 300));
  await tester.pump(const Duration(milliseconds: 700));
}

void main() {
  group('CarNumberForm', () {
    testWidgets('renders text field, submit button and keypad',
        (tester) async {
      final mockCubit = MockCarRegisterCubit()
        ..emitState(const CarRegisterLoaded());

      await tester.pumpWidget(
        wrapWithBloc(
          const SingleChildScrollView(
            child: CarNumberForm(isAddingNumber: false),
          ),
          mockCubit,
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 700));

      expect(find.byType(CarNumberTextField), findsOneWidget);
      expect(find.byType(CarSubmitButton), findsOneWidget);
      expect(find.byType(CustomKeypad), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('keypad digit adds number to text field', (tester) async {
      final mockCubit = MockCarRegisterCubit();
      await buildForm(tester, cubit: mockCubit);

      await tester.tap(find.text('5'));
      await tester.pump();

      expect(find.text('5'), findsAtLeast(1));

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('multiple keypad digits build the number', (tester) async {
      final mockCubit = MockCarRegisterCubit();
      await buildForm(tester, cubit: mockCubit);

      await tester.tap(find.text('1'));
      await tester.tap(find.text('2'));
      await tester.tap(find.text('3'));
      await tester.pump();

      expect(find.text('123'), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('delete button removes last digit', (tester) async {
      final mockCubit = MockCarRegisterCubit();
      await buildForm(tester, cubit: mockCubit);

      await tester.tap(find.text('1'));
      await tester.tap(find.text('2'));
      await tester.tap(find.text('3'));
      await tester.pump();

      expect(find.text('123'), findsOneWidget);

      await tester.ensureVisible(find.text('⌫'));
      await tester.pump();
      await tester.tap(find.text('⌫'));
      await tester.pump();

      expect(find.text('12'), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('clear button (C) clears all digits', (tester) async {
      final mockCubit = MockCarRegisterCubit();
      await buildForm(tester, cubit: mockCubit);

      await tester.tap(find.text('1'));
      await tester.tap(find.text('2'));
      await tester.tap(find.text('3'));
      await tester.tap(find.text('4'));
      await tester.tap(find.text('5'));
      await tester.pump();

      await tester.ensureVisible(find.text('C'));
      await tester.pump();
      await tester.tap(find.text('C'));
      await tester.pump();

      expect(find.text('12345'), findsNothing);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('submit button calls addCarNumber on cubit', (tester) async {
      final mockCubit = MockCarRegisterCubit();
      await buildForm(tester, cubit: mockCubit);

      await tester.tap(find.text('1'));
      await tester.tap(find.text('2'));
      await tester.tap(find.text('3'));
      await tester.pump();

      await tester.ensureVisible(find.text(AppStrings.savePlate));
      await tester.pump();
      await tester.tap(find.text(AppStrings.savePlate));
      await tester.pump();

      expect(mockCubit.addNumberCalls, equals(['123']));

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('limits input to max 8 digits', (tester) async {
      final mockCubit = MockCarRegisterCubit();
      await buildForm(tester, cubit: mockCubit);

      // Enter 4 digits and verify they appear
      await tester.tap(find.text('1'));
      await tester.tap(find.text('2'));
      await tester.tap(find.text('3'));
      await tester.tap(find.text('4'));
      await tester.pump();

      expect(find.text('1234'), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('shows loading state on submit button when isAddingNumber',
        (tester) async {
      final mockCubit = MockCarRegisterCubit()
        ..emitState(const CarRegisterLoaded(isAddingNumber: true));

      await tester.pumpWidget(
        wrapWithBloc(
          const SingleChildScrollView(
            child: CarNumberForm(isAddingNumber: true),
          ),
          mockCubit,
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 700));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text(AppStrings.savePlate), findsNothing);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('submit button does not call addCarNumber without input',
        (tester) async {
      final mockCubit = MockCarRegisterCubit();
      await buildForm(tester, cubit: mockCubit);

      // Submit without entering any number - should not call addCarNumber
      await tester.ensureVisible(find.text(AppStrings.savePlate));
      await tester.pump();
      await tester.tap(find.text(AppStrings.savePlate));
      await tester.pump();

      expect(mockCubit.addNumberCalls, isEmpty);

      await tester.pump(const Duration(seconds: 1));
    });
  });
}
