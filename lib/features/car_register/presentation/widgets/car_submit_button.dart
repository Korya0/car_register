// car_submit_button.dart
import 'package:car_register_app/core/theme/app_colors.dart';
import 'package:car_register_app/core/widgets/common/custom_button.dart';
import 'package:car_register_app/core/widgets/ui_tools/loading_overlay.dart';
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
    this.text = 'حفظ اللوحة',
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        text: text,
        backgroundColor: AppColors.primary,
        textColor: AppColors.textAndIconThritly,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        isLoading: isLoading,
        onTap: onTap,
        onLongPress: onLongPress,
        padding: const EdgeInsets.symmetric(vertical: 14),
        borderRadius: 12,
        child: isLoading
            ? const LoadingIndicator()
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: AppColors.textAndIconThritly),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textAndIconThritly,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
