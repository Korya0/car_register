import 'package:car_register_app/core/constants/app_strings.dart';
import 'package:car_register_app/features/car_register/data/models/car_number_model.dart';
import 'package:car_register_app/features/car_register/presentation/controllers/car_register_cubit.dart';
import 'package:car_register_app/features/car_register/presentation/controllers/car_register_state.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/car_number_card_widget.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/car_numbers_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/mock_cubit_helper.dart';

void main() {
  final numbers = [
    CarNumberModel(number: '12345678', createdAt: DateTime(2024)),
    CarNumberModel(number: '87654321', createdAt: DateTime(2024, 2)),
  ];

  group('CarNumbersList', () {
    testWidgets('renders all car numbers', (tester) async {
      final mockCubit = MockCarRegisterCubit()
      ..emitState(const CarRegisterLoaded());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<CarRegisterCubit>.value(
              value: mockCubit,
              child: CarNumbersList(numbers: numbers),
            ),
          ),
        ),
      );
      // Pump through animate_do: first pump fires delay, second pump completes animation
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 700));

      expect(find.text('12345678'), findsOneWidget);
      expect(find.text('87654321'), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('displays CarNumberCard for each number', (tester) async {
      final mockCubit = MockCarRegisterCubit()
      ..emitState(const CarRegisterLoaded());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<CarRegisterCubit>.value(
              value: mockCubit,
              child: CarNumbersList(numbers: numbers),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 700));

      expect(find.byType(CarNumberCard), findsNWidgets(2));

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('long press selects a number', (tester) async {
      final mockCubit = MockCarRegisterCubit()
      ..emitState(const CarRegisterLoaded());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<CarRegisterCubit>.value(
              value: mockCubit,
              child: CarNumbersList(numbers: numbers),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 700));

      await tester.longPress(find.text('12345678'));
      await tester.pump();

      expect(find.byIcon(Icons.check), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('selection bar appears after selecting', (tester) async {
      final mockCubit = MockCarRegisterCubit()
      ..emitState(const CarRegisterLoaded());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<CarRegisterCubit>.value(
              value: mockCubit,
              child: CarNumbersList(numbers: numbers),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 700));

      await tester.longPress(find.text('12345678'));
      await tester.pump();

      expect(find.text(AppStrings.selected), findsOneWidget);
      expect(find.text(AppStrings.selectAll), findsOneWidget);
      expect(find.text(AppStrings.delete), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('tapping selected number deselects it', (tester) async {
      final mockCubit = MockCarRegisterCubit()
      ..emitState(const CarRegisterLoaded());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<CarRegisterCubit>.value(
              value: mockCubit,
              child: CarNumbersList(numbers: numbers),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 700));

      await tester.longPress(find.text('12345678'));
      await tester.pump();

      expect(find.byIcon(Icons.check), findsOneWidget);

      await tester.tap(find.text('12345678'));
      await tester.pump();

      expect(find.byIcon(Icons.check), findsNothing);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('select all button selects all items', (tester) async {
      final mockCubit = MockCarRegisterCubit()
      ..emitState(const CarRegisterLoaded());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<CarRegisterCubit>.value(
              value: mockCubit,
              child: CarNumbersList(numbers: numbers),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 700));

      await tester.longPress(find.text('12345678'));
      await tester.pump();

      await tester.tap(find.text(AppStrings.selectAll));
      await tester.pump();

      expect(find.byIcon(Icons.check), findsNWidgets(2));

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('shows confirmation dialog on delete single item', (
      tester,
    ) async {
      final mockCubit = MockCarRegisterCubit()
      ..emitState(const CarRegisterLoaded());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<CarRegisterCubit>.value(
              value: mockCubit,
              child: SingleChildScrollView(
                child: CarNumbersList(numbers: numbers),
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 700));

      await tester.ensureVisible(find.byIcon(Icons.delete_forever).first);
      await tester.pump();
      await tester.tap(find.byIcon(Icons.delete_forever).first);
      await tester.pump();
      await tester.pump();

      expect(find.text(AppStrings.confirmDelete), findsOneWidget);
      expect(find.text(AppStrings.cancel), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('cancelling delete dialog does not delete', (tester) async {
      final mockCubit = MockCarRegisterCubit()
      ..emitState(const CarRegisterLoaded());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider<CarRegisterCubit>.value(
              value: mockCubit,
              child: SingleChildScrollView(
                child: CarNumbersList(numbers: numbers),
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 700));

      await tester.ensureVisible(find.byIcon(Icons.delete_forever).first);
      await tester.pump();
      await tester.tap(find.byIcon(Icons.delete_forever).first);
      await tester.pump();
      await tester.pump();

      await tester.tap(find.text(AppStrings.cancel));
      await tester.pump();

      expect(mockCubit.deleteNumberCalls, isEmpty);

      await tester.pump(const Duration(seconds: 1));
    });
  });
}
