// ignore_for_file: prefer_is_empty

class Validators {
  static String? validateCarNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال رقم السيارة';
    }

    final carNumber = value.trim();

    if (!RegExp(r'^\d+$').hasMatch(carNumber)) {
      return 'يُسمح بالأرقام فقط';
    }

    if (carNumber.length < 1 || carNumber.length > 8) {
      return 'رقم السيارة يجب أن يكون بين رقم واحد إلى ثمانية';
    }

    return null;
  }
}
