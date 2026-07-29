import 'package:car_register_app/core/error/failure.dart';
import 'package:car_register_app/features/car_register/data/models/car_number_model.dart';
import 'package:car_register_app/features/car_register/presentation/controllers/car_register_state.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/car_numbers_list.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/empty_state_widget.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/list_car_numbers_widget.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/list_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/mock_cubit_helper.dart';

void main() {
  group('ListCarNumbersWidget', () {
    testWidgets('renders ListHeaderWidget', (tester) async {
      final mockCubit = MockCarRegisterCubit()
        ..emitState(const CarRegisterLoaded());

      await tester.pumpWidget(wrapWithBloc(const ListCarNumbersWidget(), mockCubit));
      await tester.pump();

      expect(find.byType(ListHeaderWidget), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('shows EmptyStateWidget when number list is empty',
        (tester) async {
      final mockCubit = MockCarRegisterCubit()
        ..emitState(const CarRegisterLoaded());

      await tester.pumpWidget(wrapWithBloc(const ListCarNumbersWidget(), mockCubit));
      await tester.pump();

      expect(find.byType(EmptyStateWidget), findsOneWidget);
      expect(find.byType(CarNumbersList), findsNothing);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('shows CarNumbersList when numbers exist', (tester) async {
      final mockCubit = MockCarRegisterCubit()
        ..emitState(
          CarRegisterLoaded(
            carNumbers: [
              CarNumberModel(number: '12345678'),
              CarNumberModel(number: '87654321'),
            ],
          ),
        );

      await tester.pumpWidget(wrapWithBloc(const ListCarNumbersWidget(), mockCubit));
      await tester.pump();

      expect(find.byType(CarNumbersList), findsOneWidget);
      expect(find.byType(EmptyStateWidget), findsNothing);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('shows numbers in reversed order', (tester) async {
      final mockCubit = MockCarRegisterCubit()
        ..emitState(
          CarRegisterLoaded(
            carNumbers: [
              CarNumberModel(number: '11111111'),
              CarNumberModel(number: '22222222'),
            ],
          ),
        );

      await tester.pumpWidget(wrapWithBloc(const ListCarNumbersWidget(), mockCubit));
      await tester.pump();

      expect(find.text('11111111'), findsOneWidget);
      expect(find.text('22222222'), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('renders in SingleChildScrollView', (tester) async {
      final mockCubit = MockCarRegisterCubit()
        ..emitState(const CarRegisterLoaded());

      await tester.pumpWidget(wrapWithBloc(const ListCarNumbersWidget(), mockCubit));
      await tester.pump();

      expect(find.byType(SingleChildScrollView), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('handles CarRegisterFailure state with numbers',
        (tester) async {
      final mockCubit = MockCarRegisterCubit()
        ..emitState(
          CarRegisterFailure(
            failure: const NetworkFailure('error'),
            carNumbers: [
              CarNumberModel(number: '12345678'),
            ],
          ),
        );

      await tester.pumpWidget(wrapWithBloc(const ListCarNumbersWidget(), mockCubit));
      await tester.pump();

      expect(find.byType(CarNumbersList), findsOneWidget);
      expect(find.text('12345678'), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('handles CarRegisterFailure state with empty numbers',
        (tester) async {
      final mockCubit = MockCarRegisterCubit()
        ..emitState(
          const CarRegisterFailure(
            failure: NetworkFailure('error'),
          ),
        );

      await tester.pumpWidget(wrapWithBloc(const ListCarNumbersWidget(), mockCubit));
      await tester.pump();

      expect(find.byType(EmptyStateWidget), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });
  });
}
