import 'package:car_register_app/core/constants/app_strings.dart';
import 'package:car_register_app/features/car_register/presentation/controllers/car_register_cubit.dart';
import 'package:car_register_app/features/car_register/presentation/views/home_view.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/home_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/mock_cubit_helper.dart';

void main() {
  group('HomeView', () {
    testWidgets('renders Scaffold with app bar', (tester) async {
      final mockCubit = MockCarRegisterCubit();

      await tester.pumpWidget(
        wrapWithProviders(HomeView(cubit: mockCubit)),
      );
      await tester.pump();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);

      // Pump through animate_do timers
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('displays app title in app bar', (tester) async {
      final mockCubit = MockCarRegisterCubit();

      await tester.pumpWidget(
        wrapWithProviders(HomeView(cubit: mockCubit)),
      );
      await tester.pump();

      expect(find.text(AppStrings.appTitle), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('renders HomeBody', (tester) async {
      final mockCubit = MockCarRegisterCubit();

      await tester.pumpWidget(
        wrapWithProviders(HomeView(cubit: mockCubit)),
      );
      await tester.pump();

      expect(find.byType(HomeBody), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('renders bottom navigation bar', (tester) async {
      final mockCubit = MockCarRegisterCubit();

      await tester.pumpWidget(
        wrapWithProviders(HomeView(cubit: mockCubit)),
      );
      await tester.pump();

      expect(find.byType(BottomNavigationBar), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('calls initializeApp on init', (tester) async {
      final mockCubit = MockCarRegisterCubit();

      await tester.pumpWidget(
        wrapWithProviders(HomeView(cubit: mockCubit)),
      );
      await tester.pump();
      // Second pump for post-frame callback
      await tester.pump();

      expect(mockCubit.initializeAppCalls, equals(1));

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('provides cubit via BlocProvider', (tester) async {
      final mockCubit = MockCarRegisterCubit();

      await tester.pumpWidget(
        wrapWithProviders(HomeView(cubit: mockCubit)),
      );
      await tester.pump();

      final context = tester.element(find.byType(HomeBody));
      final providedCubit = context.read<CarRegisterCubit>();
      expect(providedCubit, equals(mockCubit));

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('has centered app bar title', (tester) async {
      final mockCubit = MockCarRegisterCubit();

      await tester.pumpWidget(
        wrapWithProviders(HomeView(cubit: mockCubit)),
      );
      await tester.pump();

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.centerTitle, isTrue);

      await tester.pump(const Duration(seconds: 1));
    });
  });
}
