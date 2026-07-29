import 'package:car_register_app/core/error/failure.dart';
import 'package:car_register_app/features/car_register/data/models/car_number_model.dart';
import 'package:car_register_app/features/car_register/presentation/controllers/car_register_state.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/add_car_number_widget.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/error_state_widget.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/home_body.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/list_car_numbers_widget.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/skeleton_screens.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/mock_cubit_helper.dart';

void main() {
  group('HomeBody', () {
    testWidgets('shows AddPageSkeleton on initial state', (tester) async {
      final mockCubit = MockCarRegisterCubit()
        ..emitState(const CarRegisterInitial());

      await tester.pumpWidget(wrapWithBloc(const HomeBody(), mockCubit));
      await tester.pump();

      expect(find.byType(AddPageSkeleton), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('shows AddPageSkeleton on loading state', (tester) async {
      final mockCubit = MockCarRegisterCubit()
        ..emitState(const CarRegisterLoading());

      await tester.pumpWidget(wrapWithBloc(const HomeBody(), mockCubit));
      await tester.pump();

      expect(find.byType(AddPageSkeleton), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('shows ErrorStateWidget when failure with empty numbers',
        (tester) async {
      final mockCubit = MockCarRegisterCubit()
        ..emitState(
          const CarRegisterFailure(
            failure: NetworkFailure('Network error'),
          ),
        );

      await tester.pumpWidget(wrapWithBloc(const HomeBody(), mockCubit));
      await tester.pump();

      expect(find.byType(ErrorStateWidget), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('shows AddCarNumberWidget when loaded on add page',
        (tester) async {
      final mockCubit = MockCarRegisterCubit()
        ..emitState(
          const CarRegisterLoaded(),
        );

      await tester.pumpWidget(wrapWithBloc(const HomeBody(), mockCubit));
      await tester.pump();

      expect(find.byType(AddCarNumberWidget), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('shows ListCarNumbersWidget when loaded on list page',
        (tester) async {
      final mockCubit = MockCarRegisterCubit()
        ..emitState(
          const CarRegisterLoaded(currentPage: AppPageView.list),
        );

      await tester.pumpWidget(wrapWithBloc(const HomeBody(), mockCubit));
      await tester.pump();

      expect(find.byType(ListCarNumbersWidget), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('shows AddCarNumberWidget on failure with add page',
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

      await tester.pumpWidget(wrapWithBloc(const HomeBody(), mockCubit));
      await tester.pump();

      expect(find.byType(AddCarNumberWidget), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });
  });
}
