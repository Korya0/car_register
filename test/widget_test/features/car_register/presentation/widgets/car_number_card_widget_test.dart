import 'package:car_register_app/core/constants/app_strings.dart';
import 'package:car_register_app/features/car_register/data/models/car_number_model.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/car_number_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final testModel = CarNumberModel(
    number: '12345678',
    createdAt: DateTime(2024, 6, 15),
  );

  group('CarNumberCard', () {
    testWidgets('renders with number and date', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CarNumberCard(
              model: testModel,
              index: 0,
              isDeleting: false,
              onDelete: () {},
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('12345678'), findsOneWidget);
      expect(
        find.text('${AppStrings.registrationDate}2024-06-15'),
        findsOneWidget,
      );

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('shows delete icon when not deleting', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CarNumberCard(
              model: testModel,
              index: 0,
              isDeleting: false,
              onDelete: () {},
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byIcon(Icons.delete_forever), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('shows loading spinner when isDeleting is true',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CarNumberCard(
              model: testModel,
              index: 0,
              isDeleting: true,
              onDelete: () {},
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.delete_forever), findsNothing);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('calls onDelete when delete icon is tapped', (tester) async {
      var deleted = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: CarNumberCard(
                model: testModel,
                index: 0,
                isDeleting: false,
                onDelete: () => deleted = true,
              ),
            ),
          ),
        ),
      );
      // Pump through the animate_do animation: first pump fires the delay timer
      // and starts the animation, second pump completes it
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 700));

      await tester.tap(find.byIcon(Icons.delete_forever));
      await tester.pump();

      expect(deleted, isTrue);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('renders car icon in leading', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CarNumberCard(
              model: testModel,
              index: 0,
              isDeleting: false,
              onDelete: () {},
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byIcon(Icons.directions_car), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('renders with correct card elevation', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CarNumberCard(
              model: testModel,
              index: 0,
              isDeleting: false,
              onDelete: () {},
            ),
          ),
        ),
      );
      await tester.pump();

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, equals(4));

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('does not have delete icon when loading', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CarNumberCard(
              model: testModel,
              index: 0,
              isDeleting: true,
              onDelete: () {},
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(IconButton), findsNothing);

      await tester.pump(const Duration(seconds: 1));
    });
  });
}
