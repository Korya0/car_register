import 'package:car_register_app/core/constants/app_strings.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/skeleton_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'app_test_helpers.dart';

void main() {
  setUpIntegrationTestBinding();

  group('Error State with Retry', () {
    setUp(() async {
      await setupTestInjector();
      await clearStorage();
      resetMockConfig();
    });

    tearDownAll(cleanUpTempDirs);

    testWidgets(
      'show error toast when initialization fails, then recover to loaded state',
      (WidgetTester tester) async {
        mockRemoteShouldFailOnInitialize = true;

        await pumpTestApp(tester);
        await tester.pump();

        expect(find.text(AppStrings.failureNetwork), findsOneWidget);
        expect(find.byType(TextFormField), findsOneWidget);
      },
    );
  });

  group('Loading / Skeleton State', () {
    setUp(() async {
      await setupTestInjector();
      await clearStorage();
      resetMockConfig();
    });

    tearDownAll(cleanUpTempDirs);

    testWidgets(
      'show skeleton screen during initialization and transition to form',
      (WidgetTester tester) async {
        mockRemoteInitializeDelayMs = 200;

        await pumpTestApp(tester);

        expect(find.byType(AddPageSkeleton), findsOneWidget);

        await tester.pump(const Duration(milliseconds: 250));

        expect(find.byType(AddPageSkeleton), findsNothing);
        expect(find.byType(TextFormField), findsOneWidget);
      },
    );
  });
}
