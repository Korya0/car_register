import 'package:car_register_app/core/constants/app_constants.dart';
import 'package:car_register_app/core/error/error_handler.dart';
import 'package:car_register_app/core/error/result.dart';
import 'package:car_register_app/features/car_register/data/datasources/car_number_remote_datasource.dart';
import 'package:car_register_app/features/car_register/data/models/car_number_model.dart';
import 'package:flutter/services.dart';
import 'package:gsheets/gsheets.dart';

class GSheetsCarNumberRemoteDataSourceImpl
    implements CarNumberRemoteDataSource {
  factory GSheetsCarNumberRemoteDataSourceImpl() => _instance;
  GSheetsCarNumberRemoteDataSourceImpl._internal();
  static final GSheetsCarNumberRemoteDataSourceImpl _instance =
      GSheetsCarNumberRemoteDataSourceImpl._internal();

  // ignore: use_late_for_private_fields_and_variables — nullable fields implicitly null
  GSheets? _gsheets;
  // ignore: use_late_for_private_fields_and_variables
  Worksheet? _worksheet;

  List<CarNumberModel>? _cachedNumbers;
  DateTime? _lastCacheUpdate;
  static const Duration _cacheValidDuration = Duration(minutes: 5);

  @override
  Future<Result<void>> initialize() async {
    try {
      final jsonString = await rootBundle.loadString(
        AppConstants.googleSheetCredentials,
      );
      _gsheets = GSheets(jsonString);
      final spreadsheet = await _gsheets!.spreadsheet(
        AppConstants.spreadsheetId,
      );
      _worksheet = await _getOrCreateWorksheet(spreadsheet);
      if (_worksheet != null) await _refreshCache();
      return const Result.success(null);
    } catch (e) {
      return Result.failure(handleException(e));
    }
  }

  Future<Worksheet?> _getOrCreateWorksheet(Spreadsheet spreadsheet) async {
    try {
      final worksheet = spreadsheet.worksheetByTitle(AppConstants.sheetName);
      if (worksheet != null) return worksheet;

      final newWorksheet = await spreadsheet.addWorksheet(
        AppConstants.sheetName,
      );
      await newWorksheet.values.insertRow(1, [
        AppConstants.columnName,
        AppConstants.dateColumnName,
      ]);
      return newWorksheet;
    } catch (_) {
      try {
        final newWorksheet = await spreadsheet.addWorksheet(
          AppConstants.sheetName,
        );
        await newWorksheet.values.insertRow(1, [
          AppConstants.columnName,
          AppConstants.dateColumnName,
        ]);
        return newWorksheet;
      } catch (_) {
        return null;
      }
    }
  }

  @override
  Future<Result<List<CarNumberModel>>> getAllNumbers({
    bool forceRefresh = false,
  }) async {
    if (_worksheet == null) return const Result.success([]);
    if (!forceRefresh && _isCacheValid() && _cachedNumbers != null) {
      return Result.success(List.from(_cachedNumbers!));
    }
    return _refreshCache();
  }

  Future<Result<List<CarNumberModel>>> _refreshCache() async {
    try {
      final rows = await _worksheet!.values.allRows();
      if (rows.isEmpty || rows.length <= 1) {
        _cachedNumbers = [];
      } else {
        _cachedNumbers = rows
            .skip(1)
            .where((row) => row.isNotEmpty)
            .map((row) {
              final number = row.first.trim();
              final createdAtStr = row.length > 1 ? row[1].trim() : '';
              DateTime? createdAt;
              if (createdAtStr.isNotEmpty) {
                createdAt = DateTime.tryParse(createdAtStr);
              }
              return CarNumberModel(number: number, createdAt: createdAt);
            })
            .where((model) => model.number.isNotEmpty)
            .toList();
      }

      _lastCacheUpdate = DateTime.now();
      return Result.success(List.from(_cachedNumbers!));
    } catch (e) {
      return Result.failure(handleException(e));
    }
  }

  bool _isCacheValid() {
    return _cachedNumbers != null &&
        _lastCacheUpdate != null &&
        DateTime.now().difference(_lastCacheUpdate!) < _cacheValidDuration;
  }

  @override
  Future<Result<bool>> addNumber(CarNumberModel number) async {
    if (_worksheet == null || number.number.trim().isEmpty) {
      return const Result.success(false);
    }
    try {
      final trimmedNumber = number.number.trim();
      if (_cachedNumbers?.any((model) => model.number == trimmedNumber) ??
          false) {
        return const Result.success(false);
      }

      await _worksheet!.values.appendRow([
        trimmedNumber,
        number.createdAt.toIso8601String(),
      ]);

      _cachedNumbers ??= [];
      _cachedNumbers!.add(number.copyWith(number: trimmedNumber));

      return const Result.success(true);
    } catch (e) {
      await _refreshCache();
      return Result.failure(handleException(e));
    }
  }

  @override
  Future<Result<bool>> deleteNumber(String number) async {
    if (_worksheet == null || number.trim().isEmpty) {
      return const Result.success(false);
    }
    try {
      final trimmedNumber = number.trim();
      final rows = await _worksheet!.values.allRows();
      for (var i = rows.length - 1; i >= 1; i--) {
        if (rows[i].isNotEmpty && rows[i].first.trim() == trimmedNumber) {
          await _worksheet!.deleteRow(i + 1);
          _cachedNumbers?.removeWhere((model) => model.number == trimmedNumber);
          return const Result.success(true);
        }
      }
      return const Result.success(false);
    } catch (e) {
      await _refreshCache();
      return Result.failure(handleException(e));
    }
  }

  @override
  Future<Result<bool>> deleteNumbers(List<String> numbers) async {
    if (_worksheet == null || numbers.isEmpty) {
      return const Result.success(false);
    }
    try {
      final target = numbers.map((e) => e.trim()).toSet();
      final rows = await _worksheet!.values.allRows();
      var anyDeleted = false;
      for (var i = rows.length - 1; i >= 1; i--) {
        if (rows[i].isNotEmpty) {
          final value = rows[i].first.trim();
          if (target.contains(value)) {
            await _worksheet!.deleteRow(i + 1);
            _cachedNumbers?.removeWhere((model) => model.number == value);
            anyDeleted = true;
          }
        }
      }
      return Result.success(anyDeleted);
    } catch (e) {
      await _refreshCache();
      return Result.failure(handleException(e));
    }
  }

  @override
  Future<Result<bool>> clearAll() async {
    if (_worksheet == null) return const Result.success(false);
    try {
      final rows = await _worksheet!.values.allRows();
      for (var i = rows.length - 1; i >= 2; i--) {
        await _worksheet!.deleteRow(i);
      }
      _cachedNumbers = [];
      _lastCacheUpdate = DateTime.now();
      return const Result.success(true);
    } catch (e) {
      await _refreshCache();
      return Result.failure(handleException(e));
    }
  }

  @override
  Future<Result<bool>> numberExists(String number) async {
    try {
      final trimmedNumber = number.trim();
      if (_isCacheValid() && _cachedNumbers != null) {
        return Result.success(
          _cachedNumbers!.any((model) => model.number == trimmedNumber),
        );
      }
      final result = await getAllNumbers();
      return result.when(
        success: (models) => Result.success(
          models.any((model) => model.number == trimmedNumber),
        ),
        failure: Result.failure,
      );
    } catch (e) {
      return Result.failure(handleException(e));
    }
  }
}
