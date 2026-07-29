import 'package:car_register_app/core/error/failure.dart';
import 'package:car_register_app/core/error/result.dart';
import 'package:car_register_app/features/car_register/data/datasources/car_number_local_datasource.dart';
import 'package:car_register_app/features/car_register/data/datasources/car_number_remote_datasource.dart';
import 'package:car_register_app/features/car_register/data/models/car_number_model.dart';
import 'package:car_register_app/features/car_register/data/repositories/car_number_repository.dart';
import 'package:flutter_test/flutter_test.dart';

class MockRemoteDataSource implements CarNumberRemoteDataSource {
  Result<void> initializeResult = const Result.success(null);
  Result<List<CarNumberModel>> getAllNumbersResult = const Result.success([]);
  Result<bool> addNumberResult = const Result.success(true);
  Result<bool> deleteNumberResult = const Result.success(true);
  Result<bool> deleteNumbersResult = const Result.success(true);
  Result<bool> clearAllResult = const Result.success(true);
  Result<bool> numberExistsResult = const Result.success(false);

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

  @override
  Future<Result<bool>> numberExists(String number) async => numberExistsResult;
}

class MockLocalDataSource implements CarNumberLocalDataSource {
  List<CarNumberModel> storedNumbers = [];
  bool initializeCalled = false;

  @override
  Future<void> initialize() async {
    initializeCalled = true;
  }

  @override
  Future<List<CarNumberModel>> getAllNumbers() async => storedNumbers;

  @override
  Future<bool> addNumber(CarNumberModel number) async {
    if (storedNumbers.any((e) => e.number == number.number)) return false;
    storedNumbers = [...storedNumbers, number];
    return true;
  }

  @override
  Future<bool> deleteNumber(String number) async {
    final before = storedNumbers.length;
    storedNumbers = storedNumbers.where((e) => e.number != number).toList();
    return storedNumbers.length < before;
  }

  @override
  Future<bool> deleteNumbers(List<String> numbers) async {
    final targetSet = numbers.toSet();
    final before = storedNumbers.length;
    storedNumbers = storedNumbers
        .where((e) => !targetSet.contains(e.number))
        .toList();
    return storedNumbers.length < before;
  }

  @override
  Future<bool> clearAll() async {
    storedNumbers = [];
    return true;
  }

  @override
  Future<bool> numberExists(String number) async =>
      storedNumbers.any((e) => e.number == number);
}

void main() {
  late MockRemoteDataSource mockRemote;
  late MockLocalDataSource mockLocal;
  late CarNumberRepository repository;

  setUp(() {
    mockRemote = MockRemoteDataSource();
    mockLocal = MockLocalDataSource();
    repository = CarNumberRepository(mockRemote, mockLocal);
  });

  group('CarNumberRepository', () {
    group('initialize()', () {
      test('initializes local and remote datasources', () async {
        final result = await repository.initialize();
        expect(mockLocal.initializeCalled, isTrue);
        expect(result, isA<Success<void>>());
      });

      test('returns failure when remote initialization fails', () async {
        mockRemote.initializeResult = const Result.failure(NetworkFailure());
        final result = await repository.initialize();
        expect(result, isA<FailureResult<void>>());
      });
    });

    group('getAllNumbers()', () {
      test('returns remote data when remote succeeds', () async {
        final numbers = [CarNumberModel(number: 'ABC123')];
        mockRemote.getAllNumbersResult = Result.success(numbers);

        final result = await repository.getAllNumbers();
        expect(result, isA<Success<List<CarNumberModel>>>());

        result.when(
          success: (data) => expect(data, equals(numbers)),
          failure: (_) => fail('Expected success'),
        );
      });

      test('falls back to local data when remote fails', () async {
        mockRemote.getAllNumbersResult = const Result.failure(NetworkFailure());
        mockLocal.storedNumbers = [CarNumberModel(number: 'LOCAL')];

        final result = await repository.getAllNumbers();
        result.when(
          success: (data) {
            expect(data.length, equals(1));
            expect(data.first.number, equals('LOCAL'));
          },
          failure: (_) => fail('Expected fallback success'),
        );
      });
    });

    group('addNumber()', () {
      test('returns remote result when remote succeeds', () async {
        final model = CarNumberModel(number: 'ABC123');
        final result = await repository.addNumber(model);
        result.when(
          success: (added) => expect(added, isTrue),
          failure: (_) => fail('Expected success'),
        );
      });

      test('falls back to local when remote fails', () async {
        mockRemote.addNumberResult = const Result.failure(NetworkFailure());

        final model = CarNumberModel(number: 'ABC123');
        final result = await repository.addNumber(model);

        result.when(
          success: (added) => expect(added, isTrue),
          failure: (_) => fail('Expected fallback success'),
        );
        expect(mockLocal.storedNumbers.length, equals(1));
      });
    });

    group('deleteNumber()', () {
      test('returns remote result when remote succeeds', () async {
        final result = await repository.deleteNumber('ABC123');
        result.when(
          success: (deleted) => expect(deleted, isTrue),
          failure: (_) => fail('Expected success'),
        );
      });

      test('falls back to local when remote fails', () async {
        mockRemote.deleteNumberResult = const Result.failure(NetworkFailure());
        mockLocal.storedNumbers = [CarNumberModel(number: 'ABC123')];

        final result = await repository.deleteNumber('ABC123');
        result.when(
          success: (deleted) => expect(deleted, isTrue),
          failure: (_) => fail('Expected fallback success'),
        );
        expect(mockLocal.storedNumbers, isEmpty);
      });
    });

    group('deleteNumbers()', () {
      test('returns remote result when remote succeeds', () async {
        final result = await repository.deleteNumbers(['111', '222']);
        result.when(
          success: (deleted) => expect(deleted, isTrue),
          failure: (_) => fail('Expected success'),
        );
      });

      test('falls back to local when remote fails', () async {
        mockRemote.deleteNumbersResult = const Result.failure(NetworkFailure());
        mockLocal.storedNumbers = [
          CarNumberModel(number: '111'),
          CarNumberModel(number: '222'),
        ];

        final result = await repository.deleteNumbers(['111']);
        result.when(
          success: (deleted) => expect(deleted, isTrue),
          failure: (_) => fail('Expected fallback success'),
        );
        expect(mockLocal.storedNumbers.length, equals(1));
      });
    });

    group('clearAll()', () {
      test('returns remote result when remote succeeds', () async {
        final result = await repository.clearAll();
        result.when(
          success: (cleared) => expect(cleared, isTrue),
          failure: (_) => fail('Expected success'),
        );
      });

      test('falls back to local when remote fails', () async {
        mockRemote.clearAllResult = const Result.failure(NetworkFailure());

        final result = await repository.clearAll();
        result.when(
          success: (cleared) => expect(cleared, isTrue),
          failure: (_) => fail('Expected fallback success'),
        );
      });
    });

    group('numberExists()', () {
      test('delegates to remote datasource', () async {
        mockRemote.numberExistsResult = const Result.success(true);
        final result = await repository.numberExists('ABC123');
        result.when(
          success: (exists) => expect(exists, isTrue),
          failure: (_) => fail('Expected success'),
        );
      });
    });
  });
}
