import 'package:car_register_app/core/constants/app_strings.dart';
import 'package:car_register_app/core/style/font/app_text_styles.dart';
import 'package:car_register_app/core/style/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CarSubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final String text;
  final IconData? icon;

  const CarSubmitButton({
    super.key,
    required this.isLoading,
    required this.onTap,
    this.onLongPress,
    this.text = AppStrings.savePlate,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: isLoading
                ? const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: AppColors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, color: AppColors.textAndIconThritly),
                        const SizedBox(width: 8),
                      ],
                      Text(text, style: AppTextStyles.button),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
