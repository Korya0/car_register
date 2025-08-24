// ignore_for_file: await_only_futures, avoid_print

import 'package:car_register_app/core/config/app_config.dart';
import 'package:gsheets/gsheets.dart';

class GoogleSheetsService {
  static final GoogleSheetsService _instance = GoogleSheetsService._internal();
  factory GoogleSheetsService() => _instance;
  GoogleSheetsService._internal();

  GSheets? _gsheets;
  Worksheet? _worksheet;

  Future<bool> initialize() async {
    try {
      // Load credentials from JSON file
      final credentials = await AppConfig.getCredentials();
      _gsheets = GSheets(credentials);

      final spreadsheet = await _gsheets!.spreadsheet(AppConfig.spreadsheetId);
      _worksheet = await _getWorksheet(spreadsheet);

      _worksheet ??= await _createWorksheet(spreadsheet);

      return _worksheet != null;
    } catch (e) {
      print('Error initializing Google Sheets: $e');
      return false;
    }
  }

  Future<Worksheet?> _getWorksheet(Spreadsheet spreadsheet) async {
    try {
      return await spreadsheet.worksheetByTitle(AppConfig.sheetName);
    } catch (e) {
      return null;
    }
  }

  Future<Worksheet?> _createWorksheet(Spreadsheet spreadsheet) async {
    try {
      final worksheet = await spreadsheet.addWorksheet(AppConfig.sheetName);
      await worksheet.values.insertRow(1, [AppConfig.columnName]);
      return worksheet;
    } catch (e) {
      print('Error creating worksheet: $e');
      return null;
    }
  }

  Future<List<String>> getAllNumbers() async {
    if (_worksheet == null) return [];

    try {
      final rows = await _worksheet!.values.allRows();
      if (rows.isEmpty) return [];

      // Skip header row and return all numbers
      return rows
          .skip(1)
          .map((row) => row.first)
          .where((cell) => cell.isNotEmpty)
          .toList();
    } catch (e) {
      print('Error fetching numbers: $e');
      return [];
    }
  }

  Future<bool> addNumber(String number) async {
    if (_worksheet == null) return false;

    try {
      await _worksheet!.values.appendRow([number]);
      return true;
    } catch (e) {
      print('Error adding number: $e');
      return false;
    }
  }

  Future<bool> deleteNumber(String number) async {
    if (_worksheet == null) return false;

    try {
      final rows = await _worksheet!.values.allRows();
      for (int i = 0; i < rows.length; i++) {
        if (rows[i].isNotEmpty && rows[i].first == number) {
          await _worksheet!.deleteRow(i + 1);
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error deleting number: $e');
      return false;
    }
  }

  Future<bool> numberExists(String number) async {
    final numbers = await getAllNumbers();
    return numbers.contains(number);
  }
}
