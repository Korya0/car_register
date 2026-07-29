import 'package:car_register_app/features/car_register/presentation/controllers/car_register_state.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/add_car_number_widget.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/car_number_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/mock_cubit_helper.dart';

void main() {
  group('AddCarNumberWidget', () {
    testWidgets('renders CarNumberForm', (tester) async {
      final mockCubit = MockCarRegisterCubit()
        ..emitState(const CarRegisterLoaded());

      await tester.pumpWidget(
        wrapWithBloc(const AddCarNumberWidget(), mockCubit),
      );
      await tester.pump();

      expect(find.byType(CarNumberForm), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('passes isAddingNumber false to CarNumberForm', (tester) async {
      final mockCubit = MockCarRegisterCubit()
        ..emitState(const CarRegisterLoaded());

      await tester.pumpWidget(
        wrapWithBloc(const AddCarNumberWidget(), mockCubit),
      );
      await tester.pump();

      final form = tester.widget<CarNumberForm>(find.byType(CarNumberForm));
      expect(form.isAddingNumber, isFalse);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('passes isAddingNumber true to CarNumberForm', (tester) async {
      final mockCubit = MockCarRegisterCubit()
        ..emitState(const CarRegisterLoaded(isAddingNumber: true));

      await tester.pumpWidget(
        wrapWithBloc(const AddCarNumberWidget(), mockCubit),
      );
      await tester.pump();

      final form = tester.widget<CarNumberForm>(find.byType(CarNumberForm));
      expect(form.isAddingNumber, isTrue);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('renders in a SingleChildScrollView', (tester) async {
      final mockCubit = MockCarRegisterCubit()
        ..emitState(const CarRegisterLoaded());

      await tester.pumpWidget(
        wrapWithBloc(const AddCarNumberWidget(), mockCubit),
      );
      await tester.pump();

      expect(find.byType(SingleChildScrollView), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('renders CarNumberForm regardless of state', (tester) async {
      final mockCubit = MockCarRegisterCubit()
        ..emitState(const CarRegisterInitial());

      await tester.pumpWidget(
        wrapWithBloc(const AddCarNumberWidget(), mockCubit),
      );
      await tester.pump();

      expect(find.byType(CarNumberForm), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });
  });
}
