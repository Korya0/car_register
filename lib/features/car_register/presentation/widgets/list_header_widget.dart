import 'package:car_register_app/core/resources/theme/app_colors.dart';
import 'package:car_register_app/core/widgets/animations/animate_do.dart';
import 'package:car_register_app/core/widgets/common/text_app.dart';
import 'package:flutter/material.dart';

class ListHeaderWidget extends StatelessWidget {
  final List<String> carNumbers;

  const ListHeaderWidget({super.key, required this.carNumbers});

  @override
  Widget build(BuildContext context) {
    return CustomFadeInLeft(
      duration: 700,
      child: Row(
        children: [
          _buildIcon(),
          const SizedBox(width: 12),
          _buildTitle(),
          if (carNumbers.isNotEmpty) ...[const Spacer(), _buildCounter()],
        ],
      ),
    );
  }

  /// بناء الأيقونة
  Widget _buildIcon() {
    return const Icon(Icons.list_alt, color: AppColors.primary, size: 28);
  }

  /// بناء العنوان
  Widget _buildTitle() {
    return const TextApp(
      text: 'السيارات المسجلة',
      type: TextAppType.bodyLarge,
      color: AppColors.textAndIconPrimary,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );
  }

  /// بناء عداد العناصر
  Widget _buildCounter() {
    return CircleAvatar(
      backgroundColor: AppColors.primary,
      radius: 16,
      child: TextApp(
        text: '${carNumbers.length}',
        type: TextAppType.bodySmall,
        color: AppColors.backgroundPrimary,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
