// ignore_for_file: prefer_is_empty

class Validators {
  static final RegExp _digitsOnly = RegExp(r'^\d+$');

  static bool isDigitsOnly(String value) => _digitsOnly.hasMatch(value);

  static String? validateCarNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال رقم السيارة';
    }

    final carNumber = value.trim();

    if (!_digitsOnly.hasMatch(carNumber)) {
      return 'يُسمح بالأرقام فقط';
    }

    if (carNumber.length < 1 || carNumber.length > 8) {
      return 'رقم السيارة يجب أن يكون بين رقم واحد إلى ثمانية';
    }

    return null;
  }
}
