// pin_verification_dialog.dart
import 'package:car_register_app/core/theme/app_colors.dart';
import 'package:car_register_app/core/widgets/ui_tools/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PinVerificationDialog {
  static const String _correctPin = '102030';

  static Future<bool> show(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => _PinDialog(),
        ) ??
        false;
  }
}

class _PinDialog extends StatefulWidget {
  @override
  State<_PinDialog> createState() => _PinDialogState();
}

class _PinDialogState extends State<_PinDialog> {
  final TextEditingController _pinController = TextEditingController();
  int _attempts = 0;
  static const int _maxAttempts = 3;

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
          SizedBox(width: 8),
          Text('التحقق الأمني'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'يرجى إدخال الرقم السري لتأكيد عملية الحذف',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _pinController,
            keyboardType: TextInputType.number,
            obscureText: true,
            textAlign: TextAlign.center,
            maxLength: 6,
            style: TextStyle(fontSize: 20, letterSpacing: 8),
            decoration: InputDecoration(
              hintText: '● ● ● ● ● ●',
              hintStyle: TextStyle(letterSpacing: 8),
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primary),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          if (_attempts > 0) ...[
            SizedBox(height: 10),
            Text(
              'محاولة خاطئة ($_attempts/$_maxAttempts)',
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: _verifyPin,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          child: Text('تأكيد'),
        ),
      ],
    );
  }

  void _verifyPin() {
    final enteredPin = _pinController.text.trim();

    if (enteredPin == PinVerificationDialog._correctPin) {
      HapticFeedback.heavyImpact();
      ToastMessage.success(context, 'تم التحقق بنجاح');
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _attempts++;
        _pinController.clear();
      });

      HapticFeedback.heavyImpact();

      if (_attempts >= _maxAttempts) {
        ToastMessage.error(context, 'تم تجاوز عدد المحاولات المسموحة');
        Navigator.of(context).pop(false);
      } else {
        ToastMessage.error(context, 'الرقم السري غير صحيح');
      }
    }
  }
}
