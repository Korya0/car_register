import 'package:car_register_app/core/constants/app_constants.dart';
import 'package:car_register_app/core/constants/app_strings.dart';
import 'package:car_register_app/core/utils/app_logger.dart';
import 'package:car_register_app/core/style/font/app_text_styles.dart';
import 'package:car_register_app/core/style/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PinVerificationDialog {
  static Future<bool> show(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => const _PinDialog(),
        ) ??
        false;
  }
}

class _PinDialog extends StatefulWidget {
  const _PinDialog();

  @override
  State<_PinDialog> createState() => _PinDialogState();
}

class _PinDialogState extends State<_PinDialog> {
  final TextEditingController _pinController = TextEditingController();
  int _attempts = 0;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.security, color: AppColors.primary),
          const SizedBox(width: 8),
          const Text(AppStrings.securityVerification),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            AppStrings.enterPinToConfirm,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _pinController,
            keyboardType: TextInputType.number,
            obscureText: true,
            textAlign: TextAlign.center,
            maxLength: 6,
            style: AppTextStyles.pinInput.copyWith(letterSpacing: 8),
            decoration: InputDecoration(
              hintText: AppStrings.pinHint,
              hintStyle: AppTextStyles.pinHint.copyWith(letterSpacing: 8),
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          if (_attempts > 0)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                '${AppStrings.wrongAttemptPrefix}$_attempts${AppStrings.wrongAttemptSeparator}${AppConstants.maxPinAttempts}${AppStrings.wrongAttemptSuffix}',
                style: AppTextStyles.pinError,
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text(AppStrings.cancel),
        ),
        ElevatedButton(
          onPressed: _verifyPin,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          child: const Text(AppStrings.confirm),
        ),
      ],
    );
  }

  void _verifyPin() {
    final enteredPin = _pinController.text.trim();
    if (enteredPin == AppConstants.pinCode) {
      AppLogger.info('PIN verification successful');
      HapticFeedback.heavyImpact();
      Navigator.of(context).pop(true);
    } else {
      _attempts++;
      AppLogger.warn('PIN verification failed (attempt $_attempts/${AppConstants.maxPinAttempts})');
      setState(() {
        _pinController.clear();
      });
      HapticFeedback.heavyImpact();
      if (_attempts >= AppConstants.maxPinAttempts) {
        AppLogger.warn('Max PIN attempts exceeded');
        Navigator.of(context).pop(false);
      }
    }
  }
}
