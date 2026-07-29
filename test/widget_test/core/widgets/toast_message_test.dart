import 'package:car_register_app/core/constants/app_strings.dart';
import 'package:car_register_app/core/widgets/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ToastMessage', () {
    testWidgets('shows success toast with message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: _ToastTestWidget()),
      );
      await tester.pump();

      await tester.tap(find.byKey(const Key('success')));
      await tester.pump();

      expect(find.text(AppStrings.savedSuccessfully), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);

      // Advance past the toast duration to avoid pending timer
      await tester.pump(const Duration(seconds: 4));
    });

    testWidgets('shows error toast with message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: _ToastTestWidget()),
      );
      await tester.pump();

      await tester.tap(find.byKey(const Key('error')));
      await tester.pump();

      expect(find.text('Error occurred'), findsOneWidget);
      expect(find.byIcon(Icons.error), findsOneWidget);

      await tester.pump(const Duration(seconds: 5));
    });

    testWidgets('shows warning toast with message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: _ToastTestWidget()),
      );
      await tester.pump();

      await tester.tap(find.byKey(const Key('warning')));
      await tester.pump();

      expect(find.text('Warning message'), findsOneWidget);
      expect(find.byIcon(Icons.warning), findsOneWidget);

      await tester.pump(const Duration(seconds: 4));
    });

    testWidgets('shows info toast with message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: _ToastTestWidget()),
      );
      await tester.pump();

      await tester.tap(find.byKey(const Key('info')));
      await tester.pump();

      expect(find.text('Info message'), findsOneWidget);
      expect(find.byIcon(Icons.info), findsOneWidget);

      await tester.pump(const Duration(seconds: 3));
    });

    testWidgets('toast auto-dismisses after duration', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: _ToastTestWidget()),
      );
      await tester.pump();

      await tester.tap(find.byKey(const Key('short')));
      await tester.pump();

      expect(find.text('Short toast'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 600));

      expect(find.text('Short toast'), findsNothing);
    });

    testWidgets('new toast replaces previous toast', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: _ToastTestWidget()),
      );
      await tester.pump();

      // Show first toast and let it complete
      await tester.tap(find.byKey(const Key('success')));
      await tester.pump();
      expect(find.text(AppStrings.savedSuccessfully), findsOneWidget);

      // Let the first toast complete its duration
      await tester.pump(const Duration(seconds: 4));

      // Now show second toast
      await tester.tap(find.byKey(const Key('error')));
      await tester.pump();

      // Second toast should be visible, first should be gone
      expect(find.text(AppStrings.savedSuccessfully), findsNothing);
      expect(find.text('Error occurred'), findsOneWidget);

      await tester.pump(const Duration(seconds: 5));
    });

    testWidgets('success toast has correct structure', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: _ToastTestWidget()),
      );
      await tester.pump();

      await tester.tap(find.byKey(const Key('success')));
      await tester.pump();

      expect(find.byType(Row), findsAtLeast(1));
      expect(find.byType(Expanded), findsOneWidget);

      await tester.pump(const Duration(seconds: 4));
    });

    testWidgets('error toast is visible with message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: _ToastTestWidget()),
      );
      await tester.pump();

      await tester.tap(find.byKey(const Key('error')));
      await tester.pump();

      expect(find.text('Error occurred'), findsOneWidget);

      await tester.pump(const Duration(seconds: 5));
    });
  });
}

class _ToastTestWidget extends StatelessWidget {
  const _ToastTestWidget();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              key: const Key('success'),
              onPressed: () {
                ToastMessage.success(context, AppStrings.savedSuccessfully);
              },
              child: const Text('Success'),
            ),
            ElevatedButton(
              key: const Key('error'),
              onPressed: () {
                ToastMessage.error(context, 'Error occurred');
              },
              child: const Text('Error'),
            ),
            ElevatedButton(
              key: const Key('warning'),
              onPressed: () {
                ToastMessage.warning(context, 'Warning message');
              },
              child: const Text('Warning'),
            ),
            ElevatedButton(
              key: const Key('info'),
              onPressed: () {
                ToastMessage.info(context, 'Info message');
              },
              child: const Text('Info'),
            ),
            ElevatedButton(
              key: const Key('short'),
              onPressed: () {
                ToastMessage.show(
                  context,
                  'Short toast',
                  duration: const Duration(milliseconds: 500),
                );
              },
              child: const Text('Short'),
            ),
          ],
        ),
      ),
    );
  }
}
