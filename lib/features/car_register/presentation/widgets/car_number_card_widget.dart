import 'package:car_register_app/core/constants/app_strings.dart';
import 'package:car_register_app/core/style/font/app_text_styles.dart';
import 'package:car_register_app/core/style/theme/app_colors.dart';
import 'package:car_register_app/core/widgets/animate_do.dart';
import 'package:car_register_app/features/car_register/data/models/car_number_model.dart';
import 'package:flutter/material.dart';

class CarNumberCard extends StatelessWidget {

  const CarNumberCard({
    required this.model,
    required this.index,
    required this.isDeleting,
    required this.onDelete,
    super.key,
  });
  final CarNumberModel model;
  final int index;
  final bool isDeleting;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return CustomFadeInRight(
      duration: 600 + (index * 100),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: _buildLeadingIcon(),
          title: Text(model.number, style: AppTextStyles.titleLarge),
          subtitle: Text(
            '${AppStrings.registrationDate}${model.createdAt.toString().substring(0, 10)}',
            style: AppTextStyles.bodyXSmall,
          ),
          trailing: _buildTrailing(),
        ),
      ),
    );
  }

  Widget _buildLeadingIcon() {
    return CircleAvatar(
      radius: 28,
      backgroundColor: AppColors.primary.withValues(alpha: 0.15),
      child: const Icon(
        Icons.directions_car,
        color: AppColors.primary,
        size: 28,
      ),
    );
  }

  Widget _buildTrailing() {
    if (isDeleting) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.red),
        ),
      );
    }
    return IconButton(
      icon: const Icon(Icons.delete_forever, color: AppColors.red, size: 26),
      onPressed: onDelete,
    );
  }
}
