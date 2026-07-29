import 'package:car_register_app/core/constants/app_strings.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/error_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ErrorStateWidget', () {
    testWidgets('renders with error message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorStateWidget(
              message: 'حدث خطأ في الاتصال',
              onRetry: () {},
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('حدث خطأ في الاتصال'), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('displays warning icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorStateWidget(
              message: 'Test error',
              onRetry: () {},
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('displays retry button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorStateWidget(
              message: 'Test error',
              onRetry: () {},
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text(AppStrings.retry), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('calls onRetry when retry button is tapped', (tester) async {
      var retryCalled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorStateWidget(
              message: 'Test error',
              onRetry: () => retryCalled = true,
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.text(AppStrings.retry));
      await tester.pump();

      expect(retryCalled, isTrue);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('renders a Center widget', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorStateWidget(
              message: 'Test error',
              onRetry: () {},
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(Center), findsAtLeast(1));
      expect(find.byType(Column), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('message is displayed with correct text alignment',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorStateWidget(
              message: 'خطأ في الاتصال بالخادم',
              onRetry: () {},
            ),
          ),
        ),
      );
      await tester.pump();

      final textWidget = tester.widget<Text>(
        find.text('خطأ في الاتصال بالخادم'),
      );
      expect(textWidget.textAlign, equals(TextAlign.center));

      await tester.pump(const Duration(seconds: 1));
    });
  });
}
