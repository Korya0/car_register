import 'package:car_register_app/core/resources/theme/app_colors.dart';
import 'package:car_register_app/core/widgets/animations/animate_do.dart';
import 'package:car_register_app/core/widgets/common/custom_button.dart';
import 'package:car_register_app/core/widgets/common/text_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CarNumberDeleteDialog {
  /// عرض حوار تأكيد الحذف
  static void show({
    required BuildContext context,
    required String number,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) =>
          _DeleteConfirmationDialog(number: number, onConfirm: onConfirm),
    );
  }
}

class _DeleteConfirmationDialog extends StatelessWidget {
  final String number;
  final VoidCallback onConfirm;

  const _DeleteConfirmationDialog({
    required this.number,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return CustomFadeInDown(
      duration: 300,
      child: AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: _buildTitle(),
        content: _buildContent(),
        actions: _buildActions(context),
      ),
    );
  }

  /// بناء عنوان الحوار
  Widget _buildTitle() {
    return const TextApp(
      text: 'تأكيد الحذف',
      type: TextAppType.bodyLarge,
      color: AppColors.textAndIconPrimary,
      fontWeight: FontWeight.bold,
    );
  }

  /// بناء محتوى الحوار
  Widget _buildContent() {
    return TextApp(
      text: 'هل تريد حذف الرقم $number؟',
      type: TextAppType.bodyMedium,
      color: AppColors.textAndIconPrimary,
      fontWeight: FontWeight.w400,
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return [
      _buildCancelButton(context),
      SizedBox(height: 18.h),
      _buildConfirmButton(context),
    ];
  }

  /// بناء زر الإلغاء
  Widget _buildCancelButton(BuildContext context) {
    return CustomButton(
      text: 'إلغاء',
      backgroundColor: AppColors.backgroundPrimary,
      textColor: AppColors.textAndIconPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      onTap: () => Navigator.of(context).pop(),
    );
  }

  /// بناء زر التأكيد
  Widget _buildConfirmButton(BuildContext context) {
    return CustomButton(
      text: 'حذف',
      backgroundColor: AppColors.red,
      textColor: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      onTap: () {
        Navigator.of(context).pop();
        onConfirm();
      },
    );
  }
}
