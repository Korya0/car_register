// ignore_for_file: await_only_futures, avoid_print
import 'package:car_register_app/core/config/app_config.dart';
import 'package:gsheets/gsheets.dart';

enum ValidationLevel { cacheOnly, fullValidation, smartValidation }

class GoogleSheetsService {
  static final GoogleSheetsService _instance = GoogleSheetsService._internal();
  factory GoogleSheetsService() => _instance;
  GoogleSheetsService._internal();

  GSheets? _gsheets;
  Worksheet? _worksheet;

  List<String>? _cachedNumbers;
  DateTime? _lastCacheUpdate;
  static const Duration _cacheValidDuration = Duration(minutes: 5);

  final List<String> _pendingAdditions = [];
  final List<String> _pendingDeletions = [];

  /// تهيئة الخدمة
  Future<bool> initialize() async {
    try {
      final credentials = await AppConfig.getCredentials();
      _gsheets = GSheets(credentials);

      final spreadsheet = await _gsheets!.spreadsheet(AppConfig.spreadsheetId);
      _worksheet = await _getWorksheet(spreadsheet);
      _worksheet ??= await _createWorksheet(spreadsheet);

      if (_worksheet != null) {
        await _refreshCache();
      }

      return _worksheet != null;
    } catch (e) {
      print('Error initializing Google Sheets: $e');
      return false;
    }
  }

  /// الحصول على ورقة العمل
  Future<Worksheet?> _getWorksheet(Spreadsheet spreadsheet) async {
    try {
      return await spreadsheet.worksheetByTitle(AppConfig.sheetName);
    } catch (e) {
      return null;
    }
  }

  /// إنشاء ورقة عمل جديدة
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

  /// الحصول على جميع الأرقام
  Future<List<String>> getAllNumbers({bool forceRefresh = false}) async {
    if (_worksheet == null) return [];

    if (!forceRefresh && _isCacheValid()) {
      return List.from(_cachedNumbers!);
    }

    return await _refreshCache();
  }

  /// تحديث الذاكرة المؤقتة
  Future<List<String>> _refreshCache() async {
    try {
      print('تحديث البيانات من Google Sheets...');
      final rows = await _worksheet!.values.allRows();

      if (rows.isEmpty || rows.length <= 1) {
        _cachedNumbers = [];
      } else {
        _cachedNumbers = rows
            .skip(1)
            .where((row) => row.isNotEmpty)
            .map((row) => row.first.toString().trim())
            .where((cell) => cell.isNotEmpty)
            .toList();
      }

      _lastCacheUpdate = DateTime.now();
      print('تم تحديث ${_cachedNumbers!.length} رقم في الذاكرة المؤقتة');
      return List.from(_cachedNumbers!);
    } catch (e) {
      print('Error refreshing cache: $e');
      return _cachedNumbers ?? [];
    }
  }

  /// التحقق من صحة الذاكرة المؤقتة
  bool _isCacheValid() {
    return _cachedNumbers != null &&
        _lastCacheUpdate != null &&
        DateTime.now().difference(_lastCacheUpdate!) < _cacheValidDuration;
  }

  /// إضافة رقم مع التحقق من الذاكرة المؤقتة فقط
  Future<bool> addNumber(String number) async {
    return await addNumberWithValidation(number, ValidationLevel.cacheOnly);
  }

  /// إضافة رقم مع التحقق الكامل
  Future<bool> addNumberWithFullValidation(String number) async {
    return await addNumberWithValidation(
      number,
      ValidationLevel.fullValidation,
    );
  }

  /// إضافة رقم ذكي
  Future<bool> addNumberSmart(String number) async {
    return await addNumberWithValidation(
      number,
      ValidationLevel.smartValidation,
    );
  }

  /// إضافة رقم مع مستوى تحقق محدد
  Future<bool> addNumberWithValidation(
    String number,
    ValidationLevel validationLevel,
  ) async {
    if (_worksheet == null || number.trim().isEmpty) return false;

    final trimmedNumber = number.trim();
    bool numberExists = false;

    try {
      // تحديد طريقة التحقق
      switch (validationLevel) {
        case ValidationLevel.cacheOnly:
          numberExists = _cachedNumbers?.contains(trimmedNumber) == true;
          print('تحقق سريع من الذاكرة المؤقتة');
          break;

        case ValidationLevel.fullValidation:
          print('تحقق كامل من Google Sheets...');
          final allNumbers = await _refreshCache();
          numberExists = allNumbers.contains(trimmedNumber);
          break;

        case ValidationLevel.smartValidation:
          if (_isCacheValid()) {
            numberExists = _cachedNumbers!.contains(trimmedNumber);
            print('تحقق ذكي من الذاكرة المؤقتة (صالحة)');
          } else {
            print('تحقق ذكي: تحديث الذاكرة المؤقتة...');
            final allNumbers = await _refreshCache();
            numberExists = allNumbers.contains(trimmedNumber);
          }
          break;
      }

      if (numberExists) {
        print('الرقم موجود مسبقاً: $trimmedNumber');
        return false;
      }

      // إضافة الرقم
      await _worksheet!.values.appendRow([trimmedNumber]);

      // تحديث الذاكرة المؤقتة محلياً
      _cachedNumbers ??= [];
      _cachedNumbers!.add(trimmedNumber);

      print('تم إضافة الرقم بنجاح: $trimmedNumber');
      return true;
    } catch (e) {
      print('Error adding number: $e');
      // في حالة الخطأ، نعيد تحديث الكاش
      await _refreshCache();
      return false;
    }
  }

  /// حذف رقم محسّن
  Future<bool> deleteNumber(String number) async {
    if (_worksheet == null || number.trim().isEmpty) return false;

    final trimmedNumber = number.trim();

    // التحقق من الذاكرة المؤقتة أولاً
    if (_cachedNumbers?.contains(trimmedNumber) != true) {
      print('الرقم غير موجود في الذاكرة المؤقتة: $trimmedNumber');
      return false;
    }

    try {
      final rows = await _worksheet!.values.allRows();

      // البحث من النهاية للبداية لتجنب مشاكل الفهرسة
      for (int i = rows.length - 1; i >= 1; i--) {
        if (rows[i].isNotEmpty &&
            rows[i].first.toString().trim() == trimmedNumber) {
          await _worksheet!.deleteRow(i + 1);

          // تحديث الذاكرة المؤقتة محلياً
          _cachedNumbers?.remove(trimmedNumber);

          print('تم حذف الرقم: $trimmedNumber');
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error deleting number: $e');
      // إعادة تحديث الكاش في حالة الخطأ
      await _refreshCache();
      return false;
    }
  }

  /// حذف مجموعة أرقام
  Future<bool> deleteNumbers(List<String> numbers) async {
    if (_worksheet == null || numbers.isEmpty) return false;

    try {
      final target = numbers.map((e) => e.trim()).toSet();
      final rows = await _worksheet!.values.allRows();
      bool anyDeleted = false;

      for (int i = rows.length - 1; i >= 1; i--) {
        if (rows[i].isNotEmpty) {
          final value = rows[i].first.toString().trim();
          if (target.contains(value)) {
            await _worksheet!.deleteRow(i + 1);
            _cachedNumbers?.remove(value);
            anyDeleted = true;
          }
        }
      }

      return anyDeleted;
    } catch (e) {
      print('Error deleting numbers: $e');
      await _refreshCache();
      return false;
    }
  }

  /// مسح جميع الأرقام (مع الحفاظ على صف العنوان)
  Future<bool> clearAll() async {
    if (_worksheet == null) return false;
    try {
      final rows = await _worksheet!.values.allRows();
      for (int i = rows.length - 1; i >= 2; i--) {
        await _worksheet!.deleteRow(i);
      }
      _cachedNumbers = [];
      _lastCacheUpdate = DateTime.now();
      return true;
    } catch (e) {
      print('Error clearing all numbers: $e');
      await _refreshCache();
      return false;
    }
  }

  /// التحقق من وجود رقم
  Future<bool> numberExists(String number) async {
    if (number.trim().isEmpty) return false;

    if (_isCacheValid()) {
      return _cachedNumbers!.contains(number.trim());
    }

    final numbers = await getAllNumbers();
    return numbers.contains(number.trim());
  }

  /// إضافة رقم للطابور
  void queueAddition(String number) {
    if (number.trim().isNotEmpty &&
        !_pendingAdditions.contains(number.trim())) {
      _pendingAdditions.add(number.trim());
    }
  }

  /// إضافة رقم للحذف في الطابور
  void queueDeletion(String number) {
    if (number.trim().isNotEmpty &&
        !_pendingDeletions.contains(number.trim())) {
      _pendingDeletions.add(number.trim());
    }
  }

  /// معالجة العمليات المجمعة المحسنة
  Future<Map<String, int>> processPendingOperations() async {
    if (_worksheet == null) {
      return {'added': 0, 'deleted': 0, 'failed': 0};
    }

    int addedCount = 0;
    int deletedCount = 0;
    int failedCount = 0;

    try {
      // تحديث الكاش أولاً
      await _refreshCache();

      // معالجة الإضافات
      for (String number in List.from(_pendingAdditions)) {
        try {
          if (!(_cachedNumbers?.contains(number) ?? false)) {
            await _worksheet!.values.appendRow([number]);
            _cachedNumbers!.add(number);
            addedCount++;
          }
          _pendingAdditions.remove(number);
        } catch (e) {
          failedCount++;
          print('فشل في إضافة $number: $e');
        }
      }

      // معالجة الحذف
      if (_pendingDeletions.isNotEmpty) {
        final rows = await _worksheet!.values.allRows();

        for (String number in List.from(_pendingDeletions)) {
          try {
            bool deleted = false;
            // البحث من النهاية للبداية
            for (int i = rows.length - 1; i >= 1; i--) {
              if (rows[i].isNotEmpty &&
                  rows[i].first.toString().trim() == number) {
                await _worksheet!.deleteRow(i + 1);
                _cachedNumbers?.remove(number);
                deletedCount++;
                deleted = true;
                break;
              }
            }
            _pendingDeletions.remove(number);
            if (!deleted) failedCount++;
          } catch (e) {
            failedCount++;
            print('فشل في حذف $number: $e');
          }
        }
      }

      print(
        'تمت معالجة العمليات: $addedCount إضافة، $deletedCount حذف، $failedCount فشل',
      );
    } catch (e) {
      print('Error in batch operations: $e');
      failedCount += _pendingAdditions.length + _pendingDeletions.length;
      _pendingAdditions.clear();
      _pendingDeletions.clear();
    }

    return {
      'added': addedCount,
      'deleted': deletedCount,
      'failed': failedCount,
    };
  }

  /// التحقق من سلامة البيانات
  Future<bool> validateDataIntegrity() async {
    try {
      final sheetData = await _refreshCache();
      final cacheData = List.from(_cachedNumbers ?? []);

      if (sheetData.length != cacheData.length) {
        print(
          'تضارب في عدد الصفوف: Sheet=${sheetData.length}, Cache=${cacheData.length}',
        );
        return false;
      }

      for (String number in cacheData) {
        if (!sheetData.contains(number)) {
          print('رقم موجود في الكاش وغير موجود في الشيت: $number');
          return false;
        }
      }

      return true;
    } catch (e) {
      print('Error validating data integrity: $e');
      return false;
    }
  }

  /// إعادة مزامنة البيانات
  Future<bool> resyncData() async {
    try {
      print('إعادة مزامنة البيانات...');
      await _refreshCache();
      final isValid = await validateDataIntegrity();

      if (isValid) {
        print('تمت إعادة المزامنة بنجاح');
      } else {
        print('فشلت إعادة المزامنة');
      }

      return isValid;
    } catch (e) {
      print('Error resyncing data: $e');
      return false;
    }
  }

  // === وظائف المراقبة والإحصائيات ===
  int get cachedNumbersCount => _cachedNumbers?.length ?? 0;
  bool get isCacheValid => _isCacheValid();
  DateTime? get lastCacheUpdate => _lastCacheUpdate;
  int get pendingAdditionsCount => _pendingAdditions.length;
  int get pendingDeletionsCount => _pendingDeletions.length;

  /// مسح الذاكرة المؤقتة
  void clearCache() {
    _cachedNumbers = null;
    _lastCacheUpdate = null;
    print('تم مسح الذاكرة المؤقتة');
  }

  /// إعادة تهيئة محسنة
  Future<bool> reinitialize() async {
    clearCache();
    _pendingAdditions.clear();
    _pendingDeletions.clear();
    _gsheets = null;
    _worksheet = null;
    return await initialize();
  }
}
