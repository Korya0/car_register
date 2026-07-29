import 'dart:convert';
import 'package:car_register_app/core/services/local/shared_pref_local_storage.dart';
import 'package:car_register_app/features/car_register/data/datasources/car_number_local_datasource.dart';
import 'package:car_register_app/features/car_register/data/models/car_number_model.dart';

class SharedPrefCarNumberLocalDataSourceImpl implements CarNumberLocalDataSource {

  SharedPrefCarNumberLocalDataSourceImpl(this._sharedPref);
  final SharedPref _sharedPref;
  static const String _storageKey = 'car_numbers';

  @override
  Future<void> initialize() async {
    await _sharedPref.instantiatePreferences();
  }

  Future<List<CarNumberModel>> _getCache() async {
    final jsonData = _sharedPref.getString(_storageKey);
    if (jsonData != null) {
      final decoded = jsonDecode(jsonData) as List<dynamic>;
      return decoded.map((json) => CarNumberModel.fromJson(json as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<void> _setCache(List<CarNumberModel> cache) async {
    final jsonList = cache.map((e) => e.toJson()).toList();
    await _sharedPref.setString(_storageKey, jsonEncode(jsonList));
  }

  @override
  Future<List<CarNumberModel>> getAllNumbers() async {
    return _getCache();
  }



  @override
  Future<bool> addNumber(CarNumberModel number) async {
    final cache = await _getCache();
    if (cache.any((element) => element.number == number.number)) return false;
    cache.add(number);
    await _setCache(cache);
    return true;
  }

  @override
  Future<bool> deleteNumber(String number) async {
    final cache = await _getCache();
    final initialLength = cache.length;
    cache.removeWhere((element) => element.number == number);
    if (cache.length < initialLength) {
      await _setCache(cache);
      return true;
    }
    return false;
  }

  @override
  Future<bool> deleteNumbers(List<String> numbers) async {
    final cache = await _getCache();
    final targetSet = numbers.toSet();
    final initialLength = cache.length;
    cache.removeWhere((element) => targetSet.contains(element.number));
    if (cache.length < initialLength) {
      await _setCache(cache);
      return true;
    }
    return false;
  }

  @override
  Future<bool> clearAll() async {
    await _setCache([]);
    return true;
  }

  @override
  Future<bool> numberExists(String number) async {
    final cache = await _getCache();
    return cache.any((element) => element.number == number);
  }
}
