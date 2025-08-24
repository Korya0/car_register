import 'dart:convert';
import 'package:flutter/services.dart';

class AppConfig {
  // Google Sheets Configuration
  static const String spreadsheetId =
      '1oFT2fPcKhFImGXZDJpRh9c0DdCM60AENtzoDMKjU_ow';
  static const String credentialsPath =
      'assets/carnumbersapp-469914-3fcef272fb5e.json';

  // App Constants
  static const String appName = 'Car Register';
  static const String sheetName = 'Sheet1';
  static const String columnName = 'num';

  // Colors
  static const int primaryColor = 0xFF2196F3; // Blue
  static const int lightBlueColor = 0xFFE3F2FD; // Light Blue
  static const int backgroundColor = 0xFFFFFFFF; // White

  // Delays
  static const int splashDelay = 2000; // 2 seconds

  // Messages
  static const String carAlreadyRegistered = 'هذه السيارة مسجلة بالفعل';
  static const String digitsOnlyAllowed = 'يُسمح بالأرقام فقط';
  static const String internetRequired = 'مطلوب اتصال بالإنترنت';
  static const String somethingWentWrong = 'حدث خطأ ما، يرجى المحاولة مرة أخرى';
  static const String savedSuccessfully = 'تم الحفظ بنجاح';
  static const String deletedSuccessfully = 'تم الحذف بنجاح';

  // Method to load credentials from JSON file
  static Future<String> getCredentials() async {
    try {
      final String jsonString = await rootBundle.loadString(credentialsPath);
      return jsonString;
    } catch (e) {
      throw Exception('فشل في تحميل ملف الاعتماديات: $e');
    }
  }
}
