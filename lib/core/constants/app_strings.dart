class AppStrings {
  AppStrings._();

  static const String appTitle = 'تسجيل اللوحات';

  static const String enterPlateNumber = 'أدخل رقم اللوحة';
  static const String savePlate = 'حفظ اللوحة';
  static const String plateNumberAlreadyExists = 'هذا الرقم موجود بالفعل';
  static const String maxDigitsReached = 'الحد الأقصى';
  static const String maxDigitsSuffix = 'أرقام';

  static const String validationEnterCarNumber = 'يرجى إدخال رقم السيارة';
  static const String validationDigitsOnly = 'يُسمح بالأرقام فقط';
  static const String validationCarNumberLength =
      'رقم السيارة يجب أن يكون بين رقم واحد إلى ثمانية';

  static const String noPlatesRegistered = 'لا توجد لوحات مسجلة';
  static const String startByAddingPlate = 'ابدأ بإضافة رقم اللوحه ';

  static const String registeredPlates = 'اللوحات المسجلة';

  static const String registrationDate = 'تاريخ التسجيل: ';

  static const String selected = 'محدد';
  static const String selectAll = 'تحديد الكل';
  static const String deselectAll = 'إلغاء الكل';
  static const String delete = 'حذف';

  static const String confirmDelete = 'تأكيد الحذف';
  static const String confirmDeleteSinglePrefix = 'هل تريد حذف الرقم ';
  static const String confirmDeleteSingleSuffix = '؟';
  static const String cancel = 'إلغاء';

  static const String confirmDeleteSelected = 'هل تريد حذف العناصر المحددة؟';
  static const String proceed = 'متابعة';

  static const String confirmClearAll = 'تأكيد مسح الكل';
  static const String confirmClearAllContent =
      'هل تريد حذف جميع الأرقام المسجلة؟\n\nسيتم طلب الرقم السري للتأكيد.';

  static const String securityVerification = 'التحقق الأمني';
  static const String enterPinToConfirm =
      'يرجى إدخال الرقم السري لتأكيد عملية الحذف';
  static const String pinHint = '● ● ● ● ● ●';
  static const String wrongAttemptPrefix = 'محاولة خاطئة (';
  static const String wrongAttemptSeparator = '/';
  static const String wrongAttemptSuffix = ')';
  static const String confirm = 'تأكيد';

  static const String savedSuccessfully = 'تم الحفظ بنجاح';
  static const String deletedSuccessfully = 'تم الحذف بنجاح';
  static const String allDeletedSuccessfully = 'تم حذف جميع الأرقام بنجاح';

  static const String numberAlreadyExists = 'هذا الرقم موجود بالفعل';

  static const String retry = '🔄 إعادة المحاولة';

  static const String errorNetwork = 'تحقق من اتصال الإنترنت وحاول مرة أخرى';
  static const String errorQuotaExceeded = 'تم تجاوز حد الاستخدام، حاول لاحقاً';
  static const String errorPermission = 'لا يوجد صلاحية للوصول للملف';

  static const String failureNetwork = 'تحقق من اتصال الإنترنت وحاول مرة أخرى';
  static const String failureServer = 'حدث خطأ في الخادم';
  static const String failureCache = 'حدث خطأ في التخزين المحلي';
  static const String failurePermission = 'لا يوجد صلاحية للوصول';
  static const String failureQuota = 'تم تجاوز حد الاستخدام، حاول لاحقاً';
  static const String failureNotFound = 'العنصر غير موجود';
  static const String failureDuplicate = 'العنصر موجود مسبقاً';
  static const String failureUnknown = 'حدث خطأ غير متوقع';
}
