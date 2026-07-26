// car_number_text_field.dart
import 'package:car_register_app/core/theme/app_colors.dart';
import 'package:car_register_app/core/utils/validators.dart';
import 'package:car_register_app/core/widgets/common/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CarNumberTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final IconData? suffixIcon;

  const CarNumberTextField({
    super.key,
    required this.controller,
    this.hintText = 'أدخل رقم اللوحة',
    this.suffixIcon = Icons.directions_car,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: controller,
      hintText: hintText ?? '',
      keyboardType: TextInputType.none,
      readOnly: true,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(8),
      ],
      validator: Validators.validateCarNumber,
      suffixIcon: Icon(
        suffixIcon,
        size: 28,
        color: AppColors.textAndIconPrimary.withAlpha(120),
      ),
    );
  }
}
