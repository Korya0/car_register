import 'package:car_register_app/features/car_register/data/models/car_number_model.dart';

abstract class CarNumberLocalDataSource {
  Future<void> initialize();
  Future<List<CarNumberModel>> getAllNumbers();
  Future<bool> addNumber(CarNumberModel number);
  Future<bool> deleteNumber(String number);
  Future<bool> deleteNumbers(List<String> numbers);
  Future<bool> clearAll();
  Future<bool> numberExists(String number);
}
