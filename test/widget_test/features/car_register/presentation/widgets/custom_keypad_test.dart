import 'package:car_register_app/features/car_register/presentation/widgets/custom_keypad.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomKeypad', () {
    testWidgets('renders all 12 keys', (tester) async {
      final actions = <KeypadAction>[];
      final values = <String?>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: CustomKeypad(
                  onKeyPressed: (action, [value]) {
                    actions.add(action);
                    values.add(value);
                  },
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      // All digit keys 1-9 should be visible
      for (var i = 1; i <= 9; i++) {
        await tester.ensureVisible(find.text('$i'));
        await tester.pump();
        expect(find.text('$i'), findsAtLeast(1),
            reason: 'Digit $i should be present');
      }

      // Make sure last row keys are visible
      await tester.ensureVisible(find.text('0'));
      await tester.pump();
      expect(find.text('0'), findsAtLeast(1));

      await tester.ensureVisible(find.text('C'));
      await tester.pump();
      expect(find.text('C'), findsAtLeast(1));

      await tester.ensureVisible(find.text('⌫'));
      await tester.pump();
      expect(find.text('⌫'), findsAtLeast(1));

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('digit buttons call onKeyPressed with correct action and value',
        (tester) async {
      final actions = <KeypadAction>[];
      final values = <String?>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: CustomKeypad(
                  onKeyPressed: (action, [value]) {
                    actions.add(action);
                    values.add(value);
                  },
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.ensureVisible(find.text('5'));
      await tester.pump();
      await tester.tap(find.text('5'));
      await tester.pump();

      expect(actions, equals([KeypadAction.digit]));
      expect(values, equals(['5']));

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('clear button calls onKeyPressed with clear action',
        (tester) async {
      final actions = <KeypadAction>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: CustomKeypad(
                  onKeyPressed: (action, [value]) {
                    actions.add(action);
                  },
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.ensureVisible(find.text('C'));
      await tester.pump();
      await tester.tap(find.text('C'));
      await tester.pump();

      expect(actions, contains(KeypadAction.clear));

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('delete button calls onKeyPressed with delete action',
        (tester) async {
      final actions = <KeypadAction>[];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: CustomKeypad(
                  onKeyPressed: (action, [value]) {
                    actions.add(action);
                  },
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.ensureVisible(find.text('⌫'));
      await tester.pump();
      await tester.tap(find.text('⌫'));
      await tester.pump();

      expect(actions, contains(KeypadAction.delete));

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('keypad uses GridView with 3 columns', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: CustomKeypad(
                  onKeyPressed: (action, [value]) {},
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      final gridView = tester.widget<GridView>(find.byType(GridView));
      final delegate = gridView.gridDelegate
          as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, equals(3));

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('all 12 keys have the KeypadButton type', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: CustomKeypad(
                  onKeyPressed: (action, [value]) {},
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(KeypadButton), findsNWidgets(12));

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('keyboard keys trigger interaction without crash',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: CustomKeypad(
                  onKeyPressed: (action, [value]) {},
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.ensureVisible(find.text('1'));
      await tester.pump();
      await tester.tap(find.text('1'));
      await tester.pump();

      expect(find.text('1'), findsAtLeast(1));

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('accepts custom keySpacing', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: CustomKeypad(
                  onKeyPressed: (action, [value]) {},
                  keySpacing: 20,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      final gridView = tester.widget<GridView>(find.byType(GridView));
      final delegate = gridView.gridDelegate
          as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.mainAxisSpacing, equals(20));
      expect(delegate.crossAxisSpacing, equals(20));

      await tester.pump(const Duration(seconds: 1));
    });
  });
}
