import 'package:car_register_app/core/constants/app_strings.dart';
import 'package:car_register_app/core/style/font/app_text_styles.dart';
import 'package:car_register_app/core/style/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Validators {
  static final RegExp _digitsOnly = RegExp(r'^\d+$');

  static bool isDigitsOnly(String value) => _digitsOnly.hasMatch(value);

  static String? validateCarNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.validationEnterCarNumber;
    }
    final carNumber = value.trim();
    if (!_digitsOnly.hasMatch(carNumber)) {
      return AppStrings.validationDigitsOnly;
    }
    if (carNumber.isEmpty || carNumber.length > 8) {
      return AppStrings.validationCarNumberLength;
    }
    return null;
  }
}

class CarNumberTextField extends StatelessWidget {

  const CarNumberTextField({
    required this.controller,
    super.key,
    this.hintText = AppStrings.enterPlateNumber,
    this.suffixIcon = Icons.directions_car,
  });
  final TextEditingController controller;
  final String? hintText;
  final IconData? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: AppColors.primary,
      cursorErrorColor: AppColors.primary,
      keyboardType: TextInputType.none,
      readOnly: true,
      style: AppTextStyles.bodyLarge,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.hint,
        filled: true,
        fillColor: AppColors.backgroundSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon: Icon(
          suffixIcon,
          size: 28,
          color: AppColors.textAndIconPrimary.withAlpha(120),
        ),
      ),
      validator: Validators.validateCarNumber,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(8),
      ],
    );
  }
}
