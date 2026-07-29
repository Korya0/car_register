import 'package:car_register_app/core/error/failure.dart';
import 'package:car_register_app/core/style/theme/app_colors.dart';
import 'package:car_register_app/core/widgets/app_bottom_nav_bar.dart';
import 'package:car_register_app/features/car_register/presentation/controllers/car_register_cubit.dart';
import 'package:car_register_app/features/car_register/presentation/controllers/car_register_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/mock_cubit_helper.dart';

void main() {
  group('AppBottomNavBar', () {
    testWidgets('renders two navigation items', (tester) async {
      final mockCubit = MockCarRegisterCubit()
      ..emitState(const CarRegisterLoaded());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BlocProvider<CarRegisterCubit>.value(
              value: mockCubit,
              child: const AppBottomNavBar(),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.list), findsOneWidget);
    });

    testWidgets('shows add icon selected when on add page', (tester) async {
      final mockCubit = MockCarRegisterCubit()
        ..emitState(const CarRegisterLoaded());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BlocProvider<CarRegisterCubit>.value(
              value: mockCubit,
              child: const AppBottomNavBar(),
            ),
          ),
        ),
      );
      await tester.pump();

      final navBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(navBar.currentIndex, equals(0));
    });

    testWidgets('shows list icon selected when on list page', (tester) async {
      final mockCubit = MockCarRegisterCubit()
        ..emitState(
          const CarRegisterLoaded(currentPage: AppPageView.list),
        );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BlocProvider<CarRegisterCubit>.value(
              value: mockCubit,
              child: const AppBottomNavBar(),
            ),
          ),
        ),
      );
      await tester.pump();

      final navBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(navBar.currentIndex, equals(1));
    });

    testWidgets('tapping add icon calls setCurrentPage with add', (
      tester,
    ) async {
      final mockCubit = MockCarRegisterCubit()
        ..emitState(
          const CarRegisterLoaded(currentPage: AppPageView.list),
        );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BlocProvider<CarRegisterCubit>.value(
              value: mockCubit,
              child: const AppBottomNavBar(),
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(mockCubit.setCurrentPageCalls, equals([AppPageView.add]));
    });

    testWidgets('tapping list icon calls setCurrentPage with list', (
      tester,
    ) async {
      final mockCubit = MockCarRegisterCubit()
        ..emitState(const CarRegisterLoaded());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BlocProvider<CarRegisterCubit>.value(
              value: mockCubit,
              child: const AppBottomNavBar(),
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.byIcon(Icons.list));
      await tester.pump();

      expect(mockCubit.setCurrentPageCalls, equals([AppPageView.list]));
    });

    testWidgets('handles CarRegisterFailure state', (tester) async {
      final mockCubit = MockCarRegisterCubit()
        ..emitState(
          const CarRegisterFailure(
            failure: NetworkFailure('error'),
            currentPage: AppPageView.list,
          ),
        );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BlocProvider<CarRegisterCubit>.value(
              value: mockCubit,
              child: const AppBottomNavBar(),
            ),
          ),
        ),
      );
      await tester.pump();

      final navBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(navBar.currentIndex, equals(1));
    });

    testWidgets('has correct background color', (tester) async {
      final mockCubit = MockCarRegisterCubit()
        ..emitState(const CarRegisterLoaded());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: BlocProvider<CarRegisterCubit>.value(
              value: mockCubit,
              child: const AppBottomNavBar(),
            ),
          ),
        ),
      );
      await tester.pump();

      final navBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(navBar.backgroundColor, equals(AppColors.backgroundSecondary));
    });
  });
}
