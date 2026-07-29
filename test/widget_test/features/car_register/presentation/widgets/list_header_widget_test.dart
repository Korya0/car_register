import 'package:car_register_app/core/constants/app_strings.dart';
import 'package:car_register_app/core/error/failure.dart';
import 'package:car_register_app/features/car_register/data/models/car_number_model.dart';
import 'package:car_register_app/features/car_register/presentation/controllers/car_register_state.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/list_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/mock_cubit_helper.dart';

void main() {
  group('ListHeaderWidget', () {
    testWidgets('displays the registered plates text', (tester) async {
      final mockCubit = MockCarRegisterCubit()
        ..emitState(const CarRegisterLoaded());

      await tester.pumpWidget(wrapWithBloc(const ListHeaderWidget(), mockCubit));
      await tester.pump();

      expect(find.text(AppStrings.registeredPlates), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('displays receipt icon', (tester) async {
      final mockCubit = MockCarRegisterCubit()
        ..emitState(const CarRegisterLoaded());

      await tester.pumpWidget(wrapWithBloc(const ListHeaderWidget(), mockCubit));
      await tester.pump();

      expect(find.byIcon(Icons.receipt_long_outlined), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('hides count badge when count is 0', (tester) async {
      final mockCubit = MockCarRegisterCubit()
        ..emitState(const CarRegisterLoaded());

      await tester.pumpWidget(wrapWithBloc(const ListHeaderWidget(), mockCubit));
      await tester.pump();

      expect(find.byType(CircleAvatar), findsNothing);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('shows count badge with correct number when count > 0',
        (tester) async {
      final mockCubit = MockCarRegisterCubit()
        ..emitState(
          CarRegisterLoaded(
            carNumbers: [
              CarNumberModel(number: '11111111'),
              CarNumberModel(number: '22222222'),
              CarNumberModel(number: '33333333'),
            ],
          ),
        );

      await tester.pumpWidget(wrapWithBloc(const ListHeaderWidget(), mockCubit));
      await tester.pump();

      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.text('3'), findsOneWidget);

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

      await tester.pumpWidget(wrapWithBloc(const ListHeaderWidget(), mockCubit));
      await tester.pump();

      expect(find.text(AppStrings.registeredPlates), findsOneWidget);
      expect(find.text('1'), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });
  });
}
