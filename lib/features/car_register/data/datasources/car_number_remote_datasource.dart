import 'package:car_register_app/core/error/result.dart';
import 'package:car_register_app/features/car_register/data/models/car_number_model.dart';

abstract class CarNumberRemoteDataSource {
  Future<Result<void>> initialize();
  Future<Result<List<CarNumberModel>>> getAllNumbers({bool forceRefresh = false});
  Future<Result<bool>> addNumber(CarNumberModel number);
  Future<Result<bool>> deleteNumber(String number);
  Future<Result<bool>> deleteNumbers(List<String> numbers);
  Future<Result<bool>> clearAll();
  Future<Result<bool>> numberExists(String number);
}
