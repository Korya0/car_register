import 'package:car_register_app/core/constants/app_assets.dart';
import 'package:car_register_app/core/resources/theme/app_colors.dart';
import 'package:car_register_app/core/widgets/animations/animate_do.dart';
import 'package:car_register_app/core/widgets/common/text_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

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
            Lottie.asset(
              AppAssets.infoLottie,
              height: 0.15.sh,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20.h),
            TextApp(
              text: 'لا توجد لوحات مسجلة',
              type: TextAppType.bodyLarge,
              color: AppColors.textAndIconPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
            SizedBox(height: 12.h),
            TextApp(
              text: 'ابدأ بإضافة رقم اللوحه ',
              type: TextAppType.bodyMedium,
              color: AppColors.textAndIconSecondary,
              fontSize: 16,
            ),
          ],
        ),
      ),
    );
  }
}
