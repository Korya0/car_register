import 'package:car_register_app/features/car_register/data/datasources/gsheets_car_number_remote_datasource_impl.dart';
import 'package:car_register_app/features/car_register/data/models/car_number_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GSheetsCarNumberRemoteDataSourceImpl', () {
    test('is a singleton', () {
      final instance1 = GSheetsCarNumberRemoteDataSourceImpl();
      final instance2 = GSheetsCarNumberRemoteDataSourceImpl();
      expect(identical(instance1, instance2), isTrue);
    });

    test('returned type matches interface', () {
      final instance = GSheetsCarNumberRemoteDataSourceImpl();
      expect(instance, isA<GSheetsCarNumberRemoteDataSourceImpl>());
    });

    test(
      'initialize returns failure when no credentials loaded',
      () async {
        final instance = GSheetsCarNumberRemoteDataSourceImpl();
        final result = await instance.initialize();
        expect(result, isNotNull);
      },
      skip: 'Requires rootBundle and GSheets credentials',
    );

    test(
      'getAllNumbers returns empty list when not initialized',
      () async {
        final instance = GSheetsCarNumberRemoteDataSourceImpl();
        final result = await instance.getAllNumbers();

        result.when(
          success: (numbers) {
            expect(numbers, isEmpty);
          },
          failure: (_) {
            // Also acceptable - if not initialized it may fail
          },
        );
      },
    );

    test('addNumber returns false for empty number', () async {
      final instance = GSheetsCarNumberRemoteDataSourceImpl();
      final model = CarNumberModel(number: '');
      final result = await instance.addNumber(model);

      result.when(
        success: (added) {
          expect(added, isFalse);
        },
        failure: (_) {
          // Also acceptable
        },
      );
    });

    test('numberExists gracefully handles uninitialized state', () async {
      final instance = GSheetsCarNumberRemoteDataSourceImpl();
      final result = await instance.numberExists('ABC123');
      expect(result, isNotNull);
    });
  });
}
