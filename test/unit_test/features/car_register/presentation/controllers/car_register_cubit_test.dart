import 'package:car_register_app/core/constants/app_strings.dart';
import 'package:car_register_app/core/error/failure.dart';
import 'package:car_register_app/core/error/result.dart';
import 'package:car_register_app/features/car_register/data/datasources/car_number_local_datasource.dart';
import 'package:car_register_app/features/car_register/data/datasources/car_number_remote_datasource.dart';
import 'package:car_register_app/features/car_register/data/models/car_number_model.dart';
import 'package:car_register_app/features/car_register/data/repositories/car_number_repository.dart';
import 'package:car_register_app/features/car_register/presentation/controllers/car_register_cubit.dart';
import 'package:car_register_app/features/car_register/presentation/controllers/car_register_state.dart';
import 'package:flutter_test/flutter_test.dart';

class MockRemote implements CarNumberRemoteDataSource {
  @override
  Future<Result<void>> initialize() async => const Result.success(null);

  @override
  Future<Result<List<CarNumberModel>>> getAllNumbers({
    bool forceRefresh = false,
  }) async => const Result.success([]);

  @override
  Future<Result<bool>> addNumber(CarNumberModel number) async =>
      const Result.success(true);

  @override
  Future<Result<bool>> deleteNumber(String number) async =>
      const Result.success(true);

  @override
  Future<Result<bool>> deleteNumbers(List<String> numbers) async =>
      const Result.success(true);

  @override
  Future<Result<bool>> clearAll() async => const Result.success(true);

  @override
  Future<Result<bool>> numberExists(String number) async =>
      const Result.success(false);
}

class MockLocal implements CarNumberLocalDataSource {
  @override
  Future<void> initialize() async {}

  @override
  Future<List<CarNumberModel>> getAllNumbers() async => [];

  @override
  Future<bool> addNumber(CarNumberModel number) async => true;

  @override
  Future<bool> deleteNumber(String number) async => true;

  @override
  Future<bool> deleteNumbers(List<String> numbers) async => true;

  @override
  Future<bool> clearAll() async => true;

  @override
  Future<bool> numberExists(String number) async => false;
}

/// Testable repository that delegates to mock-controllable behavior
class TestRepository extends CarNumberRepository {
  TestRepository(super.remote, super.local);

  Result<void> initializeResult = const Result.success(null);
  Result<List<CarNumberModel>> getAllNumbersResult = const Result.success([]);
  Result<bool> addNumberResult = const Result.success(true);
  Result<bool> deleteNumberResult = const Result.success(true);
  Result<bool> deleteNumbersResult = const Result.success(true);
  Result<bool> clearAllResult = const Result.success(true);

  @override
  Future<Result<void>> initialize() async => initializeResult;

  @override
  Future<Result<List<CarNumberModel>>> getAllNumbers({
    bool forceRefresh = false,
  }) async => getAllNumbersResult;

  @override
  Future<Result<bool>> addNumber(CarNumberModel number) async =>
      addNumberResult;

  @override
  Future<Result<bool>> deleteNumber(String number) async => deleteNumberResult;

  @override
  Future<Result<bool>> deleteNumbers(List<String> numbers) async =>
      deleteNumbersResult;

  @override
  Future<Result<bool>> clearAll() async => clearAllResult;
}

void main() {
  late MockRemote mockRemote;
  late MockLocal mockLocal;
  late TestRepository testRepo;
  late CarRegisterCubit cubit;

  setUp(() {
    mockRemote = MockRemote();
    mockLocal = MockLocal();
    testRepo = TestRepository(mockRemote, mockLocal);
    cubit = CarRegisterCubit(testRepo);
  });

  tearDown(() {
    cubit.close();
  });

  group('CarRegisterCubit', () {
    group('initial state', () {
      test('starts with CarRegisterInitial', () {
        expect(cubit.state, isA<CarRegisterInitial>());
      });
    });

    group('initializeApp', () {
      test('transitions from Loading to Loaded on success', () async {
        await cubit.initializeApp();
        expect(cubit.state, isA<CarRegisterLoaded>());
      });

      test('transitions to Failure when initialization fails', () async {
        testRepo.initializeResult = const Result.failure(NetworkFailure());
        await cubit.initializeApp();
        expect(cubit.state, isA<CarRegisterFailure>());
        final failureState = cubit.state as CarRegisterFailure;
        expect(failureState.failure, isA<NetworkFailure>());
      });
    });

    group('addCarNumber', () {
      test('adds number and emits Loaded with success message', () async {
        testRepo.getAllNumbersResult = const Result.success([]);
        await cubit.initializeApp();

        await cubit.addCarNumber('ABC123');

        final state = cubit.state;
        expect(state, isA<CarRegisterLoaded>());
        final loaded = state as CarRegisterLoaded;
        expect(loaded.carNumbers.any((n) => n.number == 'ABC123'), isTrue);
        expect(loaded.successMessage, equals(AppStrings.savedSuccessfully));
      });

      test('emits Failure when repository fails to add', () async {
        testRepo
          ..getAllNumbersResult = const Result.success([])
          ..addNumberResult = const Result.failure(NetworkFailure());
        await cubit.initializeApp();

        await cubit.addCarNumber('ABC123');

        expect(cubit.state, isA<CarRegisterFailure>());
      });

      test(
        'emits Failure with duplicate message when number already exists',
        () async {
          testRepo
            ..getAllNumbersResult = const Result.success([])
            ..addNumberResult = const Result.success(false);
          await cubit.initializeApp();

          await cubit.addCarNumber('ABC123');

          final state = cubit.state;
          expect(state, isA<CarRegisterFailure>());
          final failure = (state as CarRegisterFailure).failure;
          expect(failure.message, equals(AppStrings.numberAlreadyExists));
        },
      );
    });

    group('deleteCarNumber', () {
      test('deletes number and emits Loaded with success', () async {
        final existingNumbers = [CarNumberModel(number: 'ABC123')];
        testRepo.getAllNumbersResult = Result.success(existingNumbers);
        await cubit.initializeApp();

        await cubit.deleteCarNumber('ABC123');

        final state = cubit.state;
        expect(state, isA<CarRegisterLoaded>());
        final loaded = state as CarRegisterLoaded;
        expect(loaded.carNumbers.any((n) => n.number == 'ABC123'), isFalse);
        expect(loaded.successMessage, equals(AppStrings.deletedSuccessfully));
      });

      test('emits Failure when repository fails to delete', () async {
        testRepo
          ..getAllNumbersResult = const Result.success([])
          ..deleteNumberResult = const Result.failure(NetworkFailure());
        await cubit.initializeApp();

        await cubit.deleteCarNumber('ABC123');

        expect(cubit.state, isA<CarRegisterFailure>());
      });
    });

    group('deleteMultiple', () {
      test('emits Loaded state after deleting selected numbers', () async {
        final existingNumbers = [
          CarNumberModel(number: '111'),
          CarNumberModel(number: '222'),
          CarNumberModel(number: '333'),
        ];
        testRepo.getAllNumbersResult = Result.success(existingNumbers);
        await cubit.initializeApp();

        await cubit.deleteMultiple(['111', '333']);

        final state = cubit.state;
        expect(state, isA<CarRegisterLoaded>());
        final loaded = state as CarRegisterLoaded;
        expect(loaded.carNumbers.length, equals(1));
        expect(loaded.carNumbers.first.number, equals('222'));
        expect(loaded.successMessage, equals(AppStrings.deletedSuccessfully));
      });

      test('emits Failure when repository fails', () async {
        testRepo
          ..getAllNumbersResult = const Result.success([])
          ..deleteNumbersResult = const Result.failure(NetworkFailure());
        await cubit.initializeApp();

        await cubit.deleteMultiple(['111']);

        expect(cubit.state, isA<CarRegisterFailure>());
      });
    });

    group('clearAll', () {
      test(
        'clears all numbers and emits Loaded with success message',
        () async {
          final existingNumbers = [
            CarNumberModel(number: '111'),
            CarNumberModel(number: '222'),
          ];
          testRepo.getAllNumbersResult = Result.success(existingNumbers);
          await cubit.initializeApp();

          await cubit.clearAll();

          final state = cubit.state;
          expect(state, isA<CarRegisterLoaded>());
          final loaded = state as CarRegisterLoaded;
          expect(loaded.carNumbers, isEmpty);
          expect(
            loaded.successMessage,
            equals(AppStrings.allDeletedSuccessfully),
          );
        },
      );
    });

    group('setCurrentPage', () {
      test('updates currentPage in loaded state', () async {
        testRepo.getAllNumbersResult = const Result.success([]);
        await cubit.initializeApp();

        cubit.setCurrentPage(AppPageView.list);

        final loaded = cubit.state as CarRegisterLoaded;
        expect(loaded.currentPage, equals(AppPageView.list));
      });

      test('does nothing when state is not loaded', () {
        cubit.setCurrentPage(AppPageView.list);
        expect(cubit.state, isA<CarRegisterInitial>());
      });
    });

    group('clearSuccessMessage', () {
      test('clears successMessage in loaded state', () async {
        testRepo.getAllNumbersResult = const Result.success([]);
        await cubit.initializeApp();

        await cubit.addCarNumber('ABC123');
        cubit.clearSuccessMessage();

        final loaded = cubit.state as CarRegisterLoaded;
        expect(loaded.successMessage, isNull);
      });
    });

    group('clearFailure', () {
      test('transitions from Failure to Loaded state', () async {
        testRepo.initializeResult = const Result.failure(NetworkFailure());
        await cubit.initializeApp();
        expect(cubit.state, isA<CarRegisterFailure>());

        cubit.clearFailure();
        expect(cubit.state, isA<CarRegisterLoaded>());
      });
    });
  });
}
