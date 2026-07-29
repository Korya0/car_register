import 'package:car_register_app/features/car_register/data/models/car_number_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CarNumberModel', () {
    final testDate = DateTime(2026, 1, 15, 10, 30);

    group('constructor', () {
      test('creates instance with required number', () {
        final model = CarNumberModel(number: 'ABC123');
        expect(model.number, equals('ABC123'));
      });

      test('creates instance with current date when createdAt is null', () {
        final model = CarNumberModel(number: 'ABC123');
        final now = DateTime.now();
        expect(model.createdAt.year, equals(now.year));
        expect(model.createdAt.month, equals(now.month));
        expect(model.createdAt.day, equals(now.day));
      });

      test('creates instance with provided createdAt', () {
        final model = CarNumberModel(number: 'ABC123', createdAt: testDate);
        expect(model.createdAt, equals(testDate));
      });
    });

    group('fromJson', () {
      test('parses valid JSON correctly', () {
        final json = {
          'number': 'ABC123',
          'createdAt': '2026-01-15T10:30:00.000',
        };
        final model = CarNumberModel.fromJson(json);
        expect(model.number, equals('ABC123'));
        expect(model.createdAt, equals(testDate));
      });

      test('uses current date when createdAt is null', () {
        final json = {'number': 'ABC123'};
        final model = CarNumberModel.fromJson(json);
        expect(model.number, equals('ABC123'));
        expect(model.createdAt, isNotNull);
      });

      test('uses current date when createdAt is null in JSON', () {
        final json = {'number': 'ABC123', 'createdAt': null};
        final model = CarNumberModel.fromJson(json);
        expect(model.number, equals('ABC123'));
        expect(model.createdAt, isNotNull);
      });
    });

    group('toJson', () {
      test('serializes to correct JSON map', () {
        final model = CarNumberModel(number: 'ABC123', createdAt: testDate);
        final json = model.toJson();
        expect(json['number'], equals('ABC123'));
        expect(json['createdAt'], equals('2026-01-15T10:30:00.000'));
      });

      test('toJson and fromJson are inverses', () {
        final original = CarNumberModel(number: 'XYZ789', createdAt: testDate);
        final json = original.toJson();
        final restored = CarNumberModel.fromJson(json);
        expect(restored.number, equals(original.number));
        expect(restored.createdAt, equals(original.createdAt));
      });
    });

    group('copyWith', () {
      test('returns same instance when no parameters provided', () {
        final model = CarNumberModel(number: 'ABC123', createdAt: testDate);
        final copy = model.copyWith();
        expect(copy.number, equals('ABC123'));
        expect(copy.createdAt, equals(testDate));
      });

      test('updates number when provided', () {
        final model = CarNumberModel(number: 'ABC123', createdAt: testDate);
        final copy = model.copyWith(number: 'XYZ789');
        expect(copy.number, equals('XYZ789'));
        expect(copy.createdAt, equals(testDate));
      });

      test('updates createdAt when provided', () {
        final model = CarNumberModel(number: 'ABC123', createdAt: testDate);
        final newDate = DateTime(2026, 6);
        final copy = model.copyWith(createdAt: newDate);
        expect(copy.number, equals('ABC123'));
        expect(copy.createdAt, equals(newDate));
      });
    });

    group('equality', () {
      test('equal when same number', () {
        final model1 = CarNumberModel(number: 'ABC123');
        final model2 = CarNumberModel(number: 'ABC123');
        expect(model1, equals(model2));
      });

      test('not equal when different numbers', () {
        final model1 = CarNumberModel(number: 'ABC123');
        final model2 = CarNumberModel(number: 'XYZ789');
        expect(model1, isNot(equals(model2)));
      });

      test('hashCode is consistent with equality', () {
        final model1 = CarNumberModel(number: 'ABC123');
        final model2 = CarNumberModel(number: 'ABC123');
        expect(model1.hashCode, equals(model2.hashCode));
      });

      test('different numbers have different hashCodes', () {
        final model1 = CarNumberModel(number: 'ABC123');
        final model2 = CarNumberModel(number: 'XYZ789');
        expect(model1.hashCode, isNot(equals(model2.hashCode)));
      });

      test('equality ignores createdAt', () {
        final model1 = CarNumberModel(
          number: 'ABC123',
          createdAt: DateTime(2026),
        );
        final model2 = CarNumberModel(
          number: 'ABC123',
          createdAt: DateTime(2026, 6, 15),
        );
        expect(model1, equals(model2));
      });
    });

    group('edge cases', () {
      test('handles empty string number', () {
        final model = CarNumberModel(number: '');
        expect(model.number, isEmpty);
      });

      test('handles createdAt far in the past', () {
        final farDate = DateTime(2000);
        final model = CarNumberModel(number: 'OLD', createdAt: farDate);
        expect(model.createdAt, equals(farDate));
      });

      test('handles createdAt far in the future', () {
        final futureDate = DateTime(3000, 12, 31);
        final model = CarNumberModel(number: 'FUTURE', createdAt: futureDate);
        expect(model.createdAt, equals(futureDate));
      });
    });
  });
}
