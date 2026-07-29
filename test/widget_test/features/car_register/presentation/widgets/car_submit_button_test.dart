import 'package:car_register_app/core/constants/app_strings.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/car_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CarSubmitButton', () {
    testWidgets('renders with default text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CarSubmitButton(isLoading: false, onTap: null),
          ),
        ),
      );

      expect(find.text(AppStrings.savePlate), findsOneWidget);
    });

    testWidgets('renders with custom text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CarSubmitButton(
              isLoading: false,
              onTap: null,
              text: 'Custom Button',
            ),
          ),
        ),
      );

      expect(find.text('Custom Button'), findsOneWidget);
    });

    testWidgets('shows loading spinner when isLoading is true', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CarSubmitButton(isLoading: true, onTap: null),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text(AppStrings.savePlate), findsNothing);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CarSubmitButton(
              isLoading: false,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text(AppStrings.savePlate));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('does not crash when onTap is null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CarSubmitButton(isLoading: true, onTap: null),
          ),
        ),
      );

      await tester.tap(find.byType(GestureDetector));
      await tester.pump();
    });

    testWidgets('calls onLongPress when long pressed', (tester) async {
      var longPressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CarSubmitButton(
              isLoading: false,
              onTap: () {},
              onLongPress: () => longPressed = true,
            ),
          ),
        ),
      );

      await tester.longPress(find.text(AppStrings.savePlate));
      await tester.pump();

      expect(longPressed, isTrue);
    });

    testWidgets('renders with custom icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CarSubmitButton(
              isLoading: false,
              onTap: null,
              icon: Icons.star,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('has correct width (double.infinity)', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CarSubmitButton(isLoading: false, onTap: null),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, equals(double.infinity));
    });

    testWidgets('does not crash when onTap is null and tapped', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CarSubmitButton(isLoading: false, onTap: null),
          ),
        ),
      );

      await tester.tap(find.text(AppStrings.savePlate));
      await tester.pump();
    });
  });
}
