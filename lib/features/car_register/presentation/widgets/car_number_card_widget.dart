// car_number_card.dart
import 'package:car_register_app/core/theme/app_colors.dart';
import 'package:car_register_app/core/widgets/animations/animate_do.dart';
import 'package:car_register_app/core/widgets/common/text_app.dart';
import 'package:flutter/material.dart';

class CarNumberCard extends StatelessWidget {
  final String number;
  final int index;
  final bool isDeleting;
  final VoidCallback onDelete;

  const CarNumberCard({
    super.key,
    required this.number,
    required this.index,
    required this.isDeleting,
    required this.onDelete,
  });

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
          title: _buildTitle(),
          subtitle: _buildSubtitle(),
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

  Widget _buildTitle() {
    return TextApp(
      text: number,
      type: TextAppType.bodyLarge,
      color: AppColors.textAndIconPrimary,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    );
  }

  Widget _buildSubtitle() {
    return TextApp(
      text: 'تاريخ التسجيل: ${DateTime.now().toString().substring(0, 10)}',
      type: TextAppType.bodySmall,
      color: AppColors.textAndIconSecondary,
      fontSize: 12,
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
