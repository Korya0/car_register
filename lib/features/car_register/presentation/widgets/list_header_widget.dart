import 'package:car_register_app/core/constants/app_strings.dart';
import 'package:car_register_app/core/style/font/app_text_styles.dart';
import 'package:car_register_app/core/style/theme/app_colors.dart';
import 'package:car_register_app/core/widgets/animate_do.dart';
import 'package:car_register_app/features/car_register/presentation/controllers/car_register_cubit.dart';
import 'package:car_register_app/features/car_register/presentation/controllers/car_register_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ListHeaderWidget extends StatelessWidget {
  const ListHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final count = context.select<CarRegisterCubit, int>((cubit) {
      return switch (cubit.state) {
        final CarRegisterLoaded s => s.carNumbers.length,
        final CarRegisterFailure s => s.carNumbers.length,
        _ => 0,
      };
    });

    return CustomFadeInLeft(
      duration: 700,
      child: Row(
        children: [
          const Icon(Icons.receipt_long_outlined, color: AppColors.primary, size: 28),
          SizedBox(width: 12.w),
          Text(AppStrings.registeredPlates, style: AppTextStyles.titleMedium),
          if (count > 0) ...[
            const Spacer(),
            CircleAvatar(
              backgroundColor: AppColors.textAndIconSecondary,
              radius: 16,
              child: Text('$count', style: AppTextStyles.counterNumber),
            ),
          ],
        ],
      ),
    );
  }
}
