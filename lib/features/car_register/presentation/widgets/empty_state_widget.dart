import 'package:car_register_app/core/resources/theme/app_colors.dart';
import 'package:car_register_app/core/widgets/animations/animate_do.dart';
import 'package:car_register_app/core/widgets/common/text_app.dart';
import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomFadeInUp(
      duration: 800,
      child: SizedBox(
        height: 300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIcon(),
              const SizedBox(height: 20),
              _buildTitle(),
              const SizedBox(height: 12),
              _buildSubtitle(),
            ],
          ),
        ),
      ),
    );
  }

  /// بناء الأيقونة
  Widget _buildIcon() {
    return const Icon(Icons.car_crash, size: 80, color: AppColors.primary);
  }

  /// بناء العنوان الرئيسي
  Widget _buildTitle() {
    return const TextApp(
      text: 'لا توجد سيارات مسجلة',
      type: TextAppType.bodyLarge,
      color: AppColors.textAndIconPrimary,
      fontWeight: FontWeight.w600,
      fontSize: 20,
    );
  }

  /// بناء العنوان الفرعي
  Widget _buildSubtitle() {
    return const TextApp(
      text: 'ابدأ بإضافة رقم السيارة الأول',
      type: TextAppType.bodyMedium,
      color: AppColors.textAndIconSecondary,
      fontSize: 16,
    );
  }
}
