// error_state_widget.dart
import 'package:car_register_app/core/resources/theme/app_colors.dart';
import 'package:car_register_app/core/widgets/animations/animate_do.dart';
import 'package:car_register_app/core/widgets/common/custom_button.dart';
import 'package:car_register_app/core/widgets/common/text_app.dart';
import 'package:flutter/material.dart';
import '../cubit/car_register_cubit.dart';

class ErrorStateWidget extends StatelessWidget {
  final CarRegisterError error;
  final VoidCallback onRetry;

  const ErrorStateWidget({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: CustomFadeInUp(
        duration: 500,
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 100,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildErrorIcon(),
                  const SizedBox(height: 24),
                  _buildErrorMessage(),
                  const SizedBox(height: 32),
                  _buildRetryButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorIcon() {
    return const Icon(
      Icons.warning_amber_rounded,
      size: 80,
      color: AppColors.red,
    );
  }

  Widget _buildErrorMessage() {
    return TextApp(
      text: error.message,
      type: TextAppType.bodyLarge,
      color: AppColors.textAndIconPrimary,
      textAlign: TextAlign.center,
      fontWeight: FontWeight.w500,
    );
  }

  Widget _buildRetryButton() {
    return CustomButton(
      text: '🔄 إعادة المحاولة',
      backgroundColor: AppColors.primary,
      textColor: AppColors.backgroundPrimary,
      fontSize: 16,
      fontWeight: FontWeight.bold,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      onTap: onRetry,
    );
  }
}
