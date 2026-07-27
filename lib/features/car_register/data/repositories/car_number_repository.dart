import 'package:car_register_app/core/error/result.dart';
import 'package:car_register_app/core/utils/app_logger.dart';
import 'package:car_register_app/features/car_register/data/datasources/car_number_local_datasource.dart';
import 'package:car_register_app/features/car_register/data/datasources/car_number_remote_datasource.dart';
import 'package:car_register_app/features/car_register/data/models/car_number_model.dart';

class CarNumberRepository {
  final CarNumberRemoteDataSource _remote;
  final CarNumberLocalDataSource _local;

  CarNumberRepository(this._remote, this._local);

  Future<Result<void>> initialize() async {
    await _local.initialize();
    final result = await _remote.initialize();
    result.when(
      success: (_) => AppLogger.success('Repository: initialized'),
      failure: (f) => AppLogger.warn('Repository: init failed — ${f.message}'),
    );
    return result;
  }

  Future<Result<List<CarNumberModel>>> getAllNumbers({bool forceRefresh = false}) async {
    final remoteResult = await _remote.getAllNumbers(forceRefresh: forceRefresh);
    if (remoteResult is Success<List<CarNumberModel>>) return remoteResult;
    AppLogger.warn('Repository: getAllNumbers remote failed, using local');
    return Result.success(await _local.getAllNumbers());
  }

  Future<Result<bool>> addNumber(CarNumberModel number) async {
    final remoteResult = await _remote.addNumber(number);
    if (remoteResult is Success<bool> && remoteResult.data) {
      AppLogger.success('Repository: ${number.number} added');
      return remoteResult;
    }
    AppLogger.warn('Repository: addNumber remote failed, using local');
    return Result.success(await _local.addNumber(number));
  }

  Future<Result<bool>> deleteNumber(String number) async {
    final remoteResult = await _remote.deleteNumber(number);
    if (remoteResult is Success<bool> && remoteResult.data) {
      AppLogger.success('Repository: $number deleted');
      return remoteResult;
    }
    AppLogger.warn('Repository: deleteNumber remote failed, using local');
    return Result.success(await _local.deleteNumber(number));
  }

  Future<Result<bool>> deleteNumbers(List<String> numbers) async {
    final remoteResult = await _remote.deleteNumbers(numbers);
    if (remoteResult is Success<bool> && remoteResult.data) {
      AppLogger.success('Repository: ${numbers.length} numbers deleted');
      return remoteResult;
    }
    AppLogger.warn('Repository: deleteNumbers remote failed, using local');
    return Result.success(await _local.deleteNumbers(numbers));
  }

  Future<Result<bool>> clearAll() async {
    final remoteResult = await _remote.clearAll();
    if (remoteResult is Success<bool> && remoteResult.data) {
      AppLogger.success('Repository: all numbers cleared');
      return remoteResult;
    }
    AppLogger.warn('Repository: clearAll remote failed, using local');
    return Result.success(await _local.clearAll());
  }

  Future<Result<bool>> numberExists(String number) {
    return _remote.numberExists(number);
  }
}
