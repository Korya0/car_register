import 'package:car_register_app/core/services/local/shared_pref_local_storage.dart';
import 'package:car_register_app/features/car_register/data/datasources/shared_pref_car_number_local_datasource_impl.dart';
import 'package:car_register_app/features/car_register/data/models/car_number_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPref sharedPref;
  late SharedPrefCarNumberLocalDataSourceImpl dataSource;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    sharedPref = SharedPref();
    await sharedPref.instantiatePreferences();
    dataSource = SharedPrefCarNumberLocalDataSourceImpl(sharedPref);
  });

  group('SharedPrefCarNumberLocalDataSourceImpl', () {
    group('getAllNumbers', () {
      test('returns empty list when no numbers stored', () async {
        final numbers = await dataSource.getAllNumbers();
        expect(numbers, isEmpty);
      });
    });

    group('addNumber', () {
      test('adds a new number successfully', () async {
        final model = CarNumberModel(number: 'ABC123');
        final added = await dataSource.addNumber(model);
        expect(added, isTrue);

        final numbers = await dataSource.getAllNumbers();
        expect(numbers.length, equals(1));
        expect(numbers.first.number, equals('ABC123'));
      });

      test('returns false when adding duplicate number', () async {
        final model = CarNumberModel(number: 'ABC123');
        await dataSource.addNumber(model);
        final addedAgain = await dataSource.addNumber(model);
        expect(addedAgain, isFalse);
      });

      test('adds multiple distinct numbers', () async {
        await dataSource.addNumber(CarNumberModel(number: '111'));
        await dataSource.addNumber(CarNumberModel(number: '222'));
        await dataSource.addNumber(CarNumberModel(number: '333'));

        final numbers = await dataSource.getAllNumbers();
        expect(numbers.length, equals(3));
      });
    });

    group('deleteNumber', () {
      test('deletes an existing number', () async {
        await dataSource.addNumber(CarNumberModel(number: 'ABC123'));
        final deleted = await dataSource.deleteNumber('ABC123');
        expect(deleted, isTrue);

        final numbers = await dataSource.getAllNumbers();
        expect(numbers, isEmpty);
      });

      test('returns false when deleting non-existent number', () async {
        final deleted = await dataSource.deleteNumber('NONEXISTENT');
        expect(deleted, isFalse);
      });

      test('deletes only the specified number', () async {
        await dataSource.addNumber(CarNumberModel(number: '111'));
        await dataSource.addNumber(CarNumberModel(number: '222'));
        await dataSource.deleteNumber('111');

        final numbers = await dataSource.getAllNumbers();
        expect(numbers.length, equals(1));
        expect(numbers.first.number, equals('222'));
      });
    });

    group('deleteNumbers', () {
      test('deletes multiple numbers', () async {
        await dataSource.addNumber(CarNumberModel(number: '111'));
        await dataSource.addNumber(CarNumberModel(number: '222'));
        await dataSource.addNumber(CarNumberModel(number: '333'));

        final deleted = await dataSource.deleteNumbers(['111', '333']);
        expect(deleted, isTrue);

        final numbers = await dataSource.getAllNumbers();
        expect(numbers.length, equals(1));
        expect(numbers.first.number, equals('222'));
      });

      test('returns false when none of the numbers exist', () async {
        final deleted = await dataSource.deleteNumbers(['NONEXISTENT']);
        expect(deleted, isFalse);
      });

      test('handles empty list', () async {
        final deleted = await dataSource.deleteNumbers([]);
        expect(deleted, isFalse);
      });
    });

    group('clearAll', () {
      test('clears all stored numbers', () async {
        await dataSource.addNumber(CarNumberModel(number: '111'));
        await dataSource.addNumber(CarNumberModel(number: '222'));

        final cleared = await dataSource.clearAll();
        expect(cleared, isTrue);

        final numbers = await dataSource.getAllNumbers();
        expect(numbers, isEmpty);
      });

      test('clearing empty storage returns true', () async {
        final cleared = await dataSource.clearAll();
        expect(cleared, isTrue);
      });
    });

    group('numberExists', () {
      test('returns true for existing number', () async {
        await dataSource.addNumber(CarNumberModel(number: 'ABC123'));
        final exists = await dataSource.numberExists('ABC123');
        expect(exists, isTrue);
      });

      test('returns false for non-existent number', () async {
        final exists = await dataSource.numberExists('NONEXISTENT');
        expect(exists, isFalse);
      });

      test('returns false after number is deleted', () async {
        await dataSource.addNumber(CarNumberModel(number: 'ABC123'));
        await dataSource.deleteNumber('ABC123');
        final exists = await dataSource.numberExists('ABC123');
        expect(exists, isFalse);
      });
    });
  });
}
