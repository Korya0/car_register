// car_number_form.dart
import 'package:car_register_app/core/resources/theme/app_colors.dart';
import 'package:car_register_app/core/widgets/animations/animate_do.dart';
import 'package:car_register_app/core/widgets/ui_tools/toast_message.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/car_number_text_field.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/car_submit_button.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/custom_keypad.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/pin_verification_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cubit/car_register_cubit.dart';

class CarNumberForm extends StatefulWidget {
  final CarRegisterLoaded state;

  const CarNumberForm({super.key, required this.state});

  @override
  State<CarNumberForm> createState() => _CarNumberFormState();
}

class _CarNumberFormState extends State<CarNumberForm> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static const int _maxCarNumberLength = 8;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomFadeInDown(
      duration: 600,
      child: Column(
        children: [
          _buildFormContainer(),
          SizedBox(height: 20.h),
          _buildKeypadContainer(),
        ],
      ),
    );
  }

  Widget _buildFormContainer() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _buildContainerDecoration(),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CarNumberTextField(controller: _controller),
            SizedBox(height: 16.h),
            CarSubmitButton(
              isLoading: widget.state.isAddingNumber,
              onTap: widget.state.isAddingNumber ? null : _handleSubmit,
              onLongPress: widget.state.isAddingNumber
                  ? null
                  : _handleClearAllWithPIN,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypadContainer() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _buildContainerDecoration(),
      child: CustomKeypad(onKeyPressed: _handleKeyPress),
    );
  }

  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      color: AppColors.backgroundSecondary,
      borderRadius: BorderRadius.circular(16),
    );
  }

  void _handleKeyPress(KeypadAction action, [String? value]) {
    if (!mounted) return;
    switch (action) {
      case KeypadAction.digit:
        if (value != null) _addDigit(value);
        break;
      case KeypadAction.delete:
        _deleteLastDigit();
        break;
      case KeypadAction.submit:
        _handleSubmit();
        break;
      case KeypadAction.clear:
        _clearAllDigits();
        break;
    }
  }

  void _addDigit(String digit) {
    if (_controller.text.length < _maxCarNumberLength) {
      setState(() {
        _controller.text += digit;
      });
    } else {
      _showMaxLengthWarning();
    }
  }

  void _deleteLastDigit() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _controller.text = _controller.text.substring(
          0,
          _controller.text.length - 1,
        );
      });
    }
  }

  void _handleSubmit() {
    if (!mounted || !_formKey.currentState!.validate()) return;
    final carNumber = _controller.text.trim();
    if (_isCarNumberExists(carNumber)) {
      ToastMessage.error(context, 'هذا الرقم موجود بالفعل');
      return;
    }
    _addCarNumber(carNumber);
  }

  void _handleClearAllWithPIN() async {
    if (!mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber, color: Colors.orange),
            SizedBox(width: 8),
            Text('تأكيد مسح الكل'),
          ],
        ),
        content: Text(
          'هل تريد حذف جميع الأرقام المسجلة؟\n\nسيتم طلب الرقم السري للتأكيد.',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: Text('متابعة'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final pinVerified = await PinVerificationDialog.show(context);
      if (pinVerified && mounted) {
        context.read<CarRegisterCubit>().clearAll();
        ToastMessage.success(context, 'تم حذف جميع الأرقام بنجاح');
      }
    }
  }

  bool _isCarNumberExists(String carNumber) {
    return widget.state.carNumbers.contains(carNumber);
  }

  void _addCarNumber(String carNumber) {
    if (!mounted) return;
    context.read<CarRegisterCubit>().addCarNumber(carNumber);
    _clearForm();
  }

  void _clearForm() {
    if (!mounted) return;
    setState(() => _controller.clear());
    FocusScope.of(context).unfocus();
  }

  void _clearAllDigits() {
    if (!mounted) return;
    setState(() => _controller.clear());
  }

  void _showMaxLengthWarning() {
    if (!mounted) return;
    ToastMessage.error(context, 'الحد الأقصى $_maxCarNumberLength أرقام');
  }
}
