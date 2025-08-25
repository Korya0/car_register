import 'package:car_register_app/core/widgets/ui_tools/toast_message.dart';
import 'package:flutter/material.dart';
import '../cubit/car_register_cubit.dart';

class ErrorHandler {
  /// معالجة الأخطاء وعرض الرسائل المناسبة
  static void handleError(BuildContext context, CarRegisterState state) {
    if (state is! CarRegisterError) return;

    final errorMessage = _getErrorMessage(state.message);
    ToastMessage.error(context, errorMessage);
  }

  /// الحصول على رسالة خطأ مناسبة
  static String _getErrorMessage(String originalMessage) {
    // أخطاء الشبكة
    if (_isNetworkError(originalMessage)) {
      return 'تحقق من اتصال الإنترنت وحاول مرة أخرى';
    }

    // أخطاء الحد الأقصى للاستخدام
    if (_isQuotaError(originalMessage)) {
      return 'تم تجاوز حد الاستخدام، حاول لاحقاً';
    }

    // أخطاء الصلاحيات
    if (_isPermissionError(originalMessage)) {
      return 'لا يوجد صلاحية للوصول للملف';
    }

    // أخطاء الإضافة
    if (_isAdditionError(originalMessage)) {
      return 'فشل في إضافة رقم السيارة: $originalMessage';
    }

    // أخطاء الحذف
    if (_isDeletionError(originalMessage)) {
      return 'فشل في حذف رقم السيارة: $originalMessage';
    }

    // أخطاء التحميل
    if (_isLoadingError(originalMessage)) {
      return 'خطأ في تحميل البيانات: $originalMessage';
    }

    // خطأ عام
    return 'حدث خطأ غير متوقع: $originalMessage';
  }

  /// التحقق من أخطاء الشبكة
  static bool _isNetworkError(String message) {
    final networkKeywords = [
      'network',
      'internet',
      'connection',
      'timeout',
      'شبكة',
      'اتصال',
    ];

    return networkKeywords.any(
      (keyword) => message.toLowerCase().contains(keyword.toLowerCase()),
    );
  }

  /// التحقق من أخطاء الحد الأقصى
  static bool _isQuotaError(String message) {
    final quotaKeywords = [
      'quota',
      'limit',
      'exceeded',
      'rate limit',
      'حد',
      'تجاوز',
    ];

    return quotaKeywords.any(
      (keyword) => message.toLowerCase().contains(keyword.toLowerCase()),
    );
  }

  /// التحقق من أخطاء الصلاحيات
  static bool _isPermissionError(String message) {
    final permissionKeywords = [
      'permission',
      'unauthorized',
      'access denied',
      'forbidden',
      'صلاحية',
      'مرفوض',
    ];

    return permissionKeywords.any(
      (keyword) => message.toLowerCase().contains(keyword.toLowerCase()),
    );
  }

  /// التحقق من أخطاء الإضافة
  static bool _isAdditionError(String message) {
    final additionKeywords = ['إضافة', 'add', 'insert'];

    return additionKeywords.any(
      (keyword) => message.toLowerCase().contains(keyword.toLowerCase()),
    );
  }

  /// التحقق من أخطاء الحذف
  static bool _isDeletionError(String message) {
    final deletionKeywords = ['حذف', 'delete', 'remove'];

    return deletionKeywords.any(
      (keyword) => message.toLowerCase().contains(keyword.toLowerCase()),
    );
  }

  /// التحقق من أخطاء التحميل
  static bool _isLoadingError(String message) {
    final loadingKeywords = ['تحميل', 'load', 'fetch', 'retrieve'];

    return loadingKeywords.any(
      (keyword) => message.toLowerCase().contains(keyword.toLowerCase()),
    );
  }

  /// إظهار رسالة نجاح
  static void showSuccess(BuildContext context, String message) {
    ToastMessage.success(context, message);
  }

  /// إظهار رسالة تحذير
  static void showWarning(BuildContext context, String message) {
    ToastMessage.warning(context, message);
  }

  /// إظهار رسالة معلومات
  static void showInfo(BuildContext context, String message) {
    ToastMessage.info(context, message);
  }
}
