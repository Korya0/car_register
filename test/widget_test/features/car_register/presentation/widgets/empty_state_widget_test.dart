import 'package:car_register_app/core/constants/app_strings.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/empty_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/mock_cubit_helper.dart';

void main() {
  group('EmptyStateWidget', () {
    testWidgets('renders without errors', (tester) async {
      await tester.pumpWidget(wrapWithApp(const EmptyStateWidget()));
      await tester.pump();

      expect(find.byType(EmptyStateWidget), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('displays the no plates message', (tester) async {
      await tester.pumpWidget(wrapWithApp(const EmptyStateWidget()));
      await tester.pump();

      expect(find.text(AppStrings.noPlatesRegistered), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('displays the start adding message', (tester) async {
      await tester.pumpWidget(wrapWithApp(const EmptyStateWidget()));
      await tester.pump();

      expect(find.text(AppStrings.startByAddingPlate), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('displays the car icon', (tester) async {
      await tester.pumpWidget(wrapWithApp(const EmptyStateWidget()));
      await tester.pump();

      expect(find.byIcon(Icons.car_crash_outlined), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('has a Center widget (from EmptyStateWidget)', (tester) async {
      await tester.pumpWidget(wrapWithApp(const EmptyStateWidget()));
      await tester.pump();

      // There can be multiple Center widgets due to ScreenUtilInit wrapping
      expect(find.byType(Center), findsAtLeast(1));

      await tester.pump(const Duration(seconds: 1));
    });
  });
}
