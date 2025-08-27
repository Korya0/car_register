// list_header_widget.dart
import 'package:car_register_app/core/resources/theme/app_colors.dart';
import 'package:car_register_app/core/widgets/animations/animate_do.dart';
import 'package:car_register_app/core/widgets/common/text_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ListHeaderWidget extends StatelessWidget {
  final List<String> carNumbers;

  const ListHeaderWidget({super.key, required this.carNumbers});

  @override
  Widget build(BuildContext context) {
    return CustomFadeInLeft(
      duration: 700,
      child: Row(
        children: [
          const Icon(
            Icons.receipt_long_outlined,
            color: AppColors.primary,
            size: 28,
          ),
          SizedBox(width: 12.w),
          TextApp(
            text: 'اللوحات المسجلة',
            type: TextAppType.bodyLarge,
            color: AppColors.textAndIconPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          if (carNumbers.isNotEmpty) ...[const Spacer(), _buildCounter()],
        ],
      ),
    );
  }

  Widget _buildCounter() {
    return CircleAvatar(
      backgroundColor: AppColors.textAndIconSecondary,
      radius: 16,
      child: TextApp(
        text: '${carNumbers.length}',
        type: TextAppType.bodySmall,
        color: AppColors.textAndIconThritly,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
