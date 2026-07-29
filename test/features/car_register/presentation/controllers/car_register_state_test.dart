import 'package:car_register_app/core/error/failure.dart';
import 'package:car_register_app/features/car_register/data/models/car_number_model.dart';
import 'package:car_register_app/features/car_register/presentation/controllers/car_register_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CarRegisterState', () {
    group('CarRegisterInitial', () {
      test('creates instance', () {
        const state = CarRegisterInitial();
        expect(state, isA<CarRegisterState>());
      });
    });

    group('CarRegisterLoading', () {
      test('creates instance', () {
        const state = CarRegisterLoading();
        expect(state, isA<CarRegisterState>());
      });
    });

    group('CarRegisterLoaded', () {
      test('creates with default values', () {
        const state = CarRegisterLoaded();
        expect(state.carNumbers, isEmpty);
        expect(state.isAddingNumber, isFalse);
        expect(state.isDeletingNumber, isFalse);
        expect(state.currentPage, equals(AppPageView.add));
        expect(state.successMessage, isNull);
      });

      test('stores provided carNumbers', () {
        final numbers = [
          CarNumberModel(number: 'ABC123'),
          CarNumberModel(number: 'XYZ789'),
        ];
        final state = CarRegisterLoaded(carNumbers: numbers);
        expect(state.carNumbers.length, equals(2));
        expect(state.carNumbers, equals(numbers));
      });

      test('stores isAddingNumber flag', () {
        const state = CarRegisterLoaded(isAddingNumber: true);
        expect(state.isAddingNumber, isTrue);
      });

      test('stores isDeletingNumber flag', () {
        const state = CarRegisterLoaded(isDeletingNumber: true);
        expect(state.isDeletingNumber, isTrue);
      });

      test('stores currentPage', () {
        const state = CarRegisterLoaded(currentPage: AppPageView.list);
        expect(state.currentPage, equals(AppPageView.list));
      });

      test('stores successMessage', () {
        const state = CarRegisterLoaded(successMessage: 'Saved!');
        expect(state.successMessage, equals('Saved!'));
      });

      group('copyWith', () {
        test('preserves fields not provided, resets successMessage to null', () {
          final numbers = [CarNumberModel(number: 'ABC123')];
          const state = CarRegisterLoaded(
            isAddingNumber: true,
            isDeletingNumber: true,
            currentPage: AppPageView.list,
            successMessage: 'done',
          );
          // successMessage is explicitly set to null when not provided to copyWith
          final fullState = state.copyWith(carNumbers: numbers);
          expect(fullState.carNumbers, equals(numbers));
          expect(fullState.isAddingNumber, isTrue);
          expect(fullState.isDeletingNumber, isTrue);
          expect(fullState.currentPage, equals(AppPageView.list));
          expect(fullState.successMessage, isNull);
        });

        test('updates carNumbers when provided', () {
          const state = CarRegisterLoaded();
          final newNumbers = [CarNumberModel(number: 'NEW')];
          final copy = state.copyWith(carNumbers: newNumbers);
          expect(copy.carNumbers, equals(newNumbers));
        });

        test('updates isAddingNumber when provided', () {
          const state = CarRegisterLoaded();
          final copy = state.copyWith(isAddingNumber: true);
          expect(copy.isAddingNumber, isTrue);
        });

        test('updates isDeletingNumber when provided', () {
          const state = CarRegisterLoaded();
          final copy = state.copyWith(isDeletingNumber: true);
          expect(copy.isDeletingNumber, isTrue);
        });

        test('updates currentPage when provided', () {
          const state = CarRegisterLoaded();
          final copy = state.copyWith(currentPage: AppPageView.list);
          expect(copy.currentPage, equals(AppPageView.list));
        });

        test('sets successMessage to null explicitly', () {
          const state = CarRegisterLoaded(successMessage: 'old');
          final copy = state.copyWith();
          expect(copy.successMessage, isNull);
        });
      });
    });

    group('CarRegisterFailure', () {
      test('creates with required failure', () {
        const failure = UnknownFailure('error');
        const state = CarRegisterFailure(failure: failure);
        expect(state.failure, equals(failure));
        expect(state.carNumbers, isEmpty);
        expect(state.currentPage, equals(AppPageView.add));
      });

      test('stores provided carNumbers', () {
        const failure = UnknownFailure('error');
        final numbers = [CarNumberModel(number: 'ABC')];
        final state = CarRegisterFailure(
          failure: failure,
          carNumbers: numbers,
        );
        expect(state.carNumbers, equals(numbers));
      });

      test('stores provided currentPage', () {
        const failure = UnknownFailure('error');
        const state = CarRegisterFailure(
          failure: failure,
          currentPage: AppPageView.list,
        );
        expect(state.currentPage, equals(AppPageView.list));
      });
    });

    group('AppPageView enum', () {
      test('has add value', () {
        expect(AppPageView.add, isA<AppPageView>());
      });

      test('has list value', () {
        expect(AppPageView.list, isA<AppPageView>());
      });

      test('two distinct values', () {
        expect(AppPageView.add, isNot(equals(AppPageView.list)));
      });
    });
  });
}
