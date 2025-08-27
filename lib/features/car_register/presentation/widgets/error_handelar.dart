// error_handler.dart
import 'package:car_register_app/core/widgets/ui_tools/toast_message.dart';
import 'package:flutter/material.dart';
import '../cubit/car_register_cubit.dart';

class ErrorHandler {
  static void handleError(BuildContext context, CarRegisterState state) {
    if (state is! CarRegisterError) return;

    final errorMessage = _getErrorMessage(state.message);
    ToastMessage.error(context, errorMessage);
  }

  static String _getErrorMessage(String originalMessage) {
    if (_isNetworkError(originalMessage)) {
      return 'تحقق من اتصال الإنترنت وحاول مرة أخرى';
    }

    if (_isQuotaError(originalMessage)) {
      return 'تم تجاوز حد الاستخدام، حاول لاحقاً';
    }

    if (_isPermissionError(originalMessage)) {
      return 'لا يوجد صلاحية للوصول للملف';
    }

    if (_isAdditionError(originalMessage)) {
      return 'فشل في إضافة رقم السيارة: $originalMessage';
    }

    if (_isDeletionError(originalMessage)) {
      return 'فشل في حذف رقم السيارة: $originalMessage';
    }

    if (_isLoadingError(originalMessage)) {
      return 'خطأ في تحميل البيانات: $originalMessage';
    }

    return 'حدث خطأ غير متوقع: $originalMessage';
  }

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

  static bool _isAdditionError(String message) {
    final additionKeywords = ['إضافة', 'add', 'insert'];

    return additionKeywords.any(
      (keyword) => message.toLowerCase().contains(keyword.toLowerCase()),
    );
  }

  static bool _isDeletionError(String message) {
    final deletionKeywords = ['حذف', 'delete', 'remove'];

    return deletionKeywords.any(
      (keyword) => message.toLowerCase().contains(keyword.toLowerCase()),
    );
  }

  static bool _isLoadingError(String message) {
    final loadingKeywords = ['تحميل', 'load', 'fetch', 'retrieve'];

    return loadingKeywords.any(
      (keyword) => message.toLowerCase().contains(keyword.toLowerCase()),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    ToastMessage.success(context, message);
  }

  static void showWarning(BuildContext context, String message) {
    ToastMessage.warning(context, message);
  }

  static void showInfo(BuildContext context, String message) {
    ToastMessage.info(context, message);
  }
}
