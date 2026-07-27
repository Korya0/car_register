import 'package:car_register_app/core/constants/app_strings.dart';
import 'package:car_register_app/core/style/font/app_text_styles.dart';
import 'package:car_register_app/core/style/theme/app_colors.dart';
import 'package:car_register_app/core/widgets/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomFadeInUp(
      duration: 800,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 30.h),
            Icon(
              Icons.car_crash_outlined,
              size: 0.15.sh,
              color: AppColors.primary,
            ),
            SizedBox(height: 20.h),
            Text(
              AppStrings.noPlatesRegistered,
              style: AppTextStyles.emptyTitle,
            ),
            SizedBox(height: 12.h),
            Text(
              AppStrings.startByAddingPlate,
              style: AppTextStyles.emptySubtitle,
            ),
          ],
        ),
      ),
    );
  }
}
