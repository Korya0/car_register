// Main Form Widget
// car_number_form.dart
// ignore_for_file: deprecated_member_use

import 'package:car_register_app/core/resources/theme/app_colors.dart';
import 'package:car_register_app/core/utils/validators.dart';
import 'package:car_register_app/core/widgets/animations/animate_do.dart';
import 'package:car_register_app/core/widgets/common/custom_button.dart';
import 'package:car_register_app/core/widgets/common/custom_text_form_field.dart';
import 'package:car_register_app/core/widgets/ui_tools/loading_overlay.dart';
import 'package:car_register_app/core/widgets/ui_tools/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return CustomFadeInDown(duration: 600, child: _buildFormContainer());
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
                  : _handleClearAllLongPress,
            ),
            SizedBox(height: 18.h),
            CustomKeypad(onKeyPressed: _handleKeyPress),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      color: AppColors.backgroundSecondary,
      borderRadius: BorderRadius.circular(16),
    );
  }

  void _handleKeyPress(KeypadAction action, [String? value]) {
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
      _controller.text += digit;
    } else {
      _showMaxLengthWarning();
    }
  }

  void _deleteLastDigit() {
    if (_controller.text.isNotEmpty) {
      _controller.text = _controller.text.substring(
        0,
        _controller.text.length - 1,
      );
    }
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final carNumber = _controller.text.trim();

    if (_isCarNumberExists(carNumber)) {
      ToastMessage.error(context, 'هذا الرقم موجود بالفعل');
      return;
    }

    _addCarNumber(carNumber);
  }

  void _handleClearAllLongPress() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('تأكيد مسح الكل'),
          content: const Text('هل تريد حذف جميع الأرقام المسجلة؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('حذف الكل'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      context.read<CarRegisterCubit>().clearAll();
    }
  }

  bool _isCarNumberExists(String carNumber) {
    return widget.state.carNumbers.contains(carNumber);
  }

  void _addCarNumber(String carNumber) {
    context.read<CarRegisterCubit>().addCarNumber(carNumber);
    _clearForm();
  }

  void _clearForm() {
    _controller.clear();
    FocusScope.of(context).unfocus();
  }

  void _clearAllDigits() {
    _controller.clear();
  }

  void _showMaxLengthWarning() {
    ToastMessage.error(context, 'الحد الأقصى $_maxCarNumberLength أرقام');
  }
}

// ==========================================
// Custom Text Field Widget
// widgets/car_number_text_field.dart

class CarNumberTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final IconData? suffixIcon;

  const CarNumberTextField({
    super.key,
    required this.controller,
    this.hintText = 'أدخل رقم اللوحة',
    this.suffixIcon = Icons.directions_car,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: controller,
      hintText: hintText ?? '',
      keyboardType: TextInputType.none,
      readOnly: true,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(8),
      ],
      validator: Validators.validateCarNumber,

      suffixIcon: Icon(
        suffixIcon,
        size: 28,
        color: AppColors.textAndIconPrimary.withAlpha(120),
      ),
    );
  }
}

// ==========================================
// Custom Submit Button Widget
// widgets/car_submit_button.dart

class CarSubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final String text;
  final IconData? icon;

  const CarSubmitButton({
    super.key,
    required this.isLoading,
    required this.onTap,
    this.onLongPress,
    this.text = 'حفظ اللوحة',
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        text: text,
        backgroundColor: AppColors.primary,
        textColor: AppColors.textAndIconThritly,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        isLoading: isLoading,
        onTap: onTap,
        onLongPress: onLongPress,
        padding: const EdgeInsets.symmetric(vertical: 14),
        borderRadius: 12,
        child: isLoading
            ? LoadingIndicator()
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: AppColors.textAndIconThritly),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textAndIconThritly,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ==========================================
// Custom Keypad Widget
// widgets/custom_keypad.dart

enum KeypadAction { digit, delete, submit, clear }

typedef KeypadCallback = void Function(KeypadAction action, [String? value]);

class CustomKeypad extends StatelessWidget {
  final KeypadCallback onKeyPressed;
  final double? keySpacing;
  final double? keyBorderRadius;

  const CustomKeypad({
    super.key,
    required this.onKeyPressed,
    this.keySpacing = 10,
    this.keyBorderRadius = 12,
  });

  static const List<KeypadKey> _keys = [
    KeypadKey(label: '1', action: KeypadAction.digit),
    KeypadKey(label: '2', action: KeypadAction.digit),
    KeypadKey(label: '3', action: KeypadAction.digit),
    KeypadKey(label: '4', action: KeypadAction.digit),
    KeypadKey(label: '5', action: KeypadAction.digit),
    KeypadKey(label: '6', action: KeypadAction.digit),
    KeypadKey(label: '7', action: KeypadAction.digit),
    KeypadKey(label: '8', action: KeypadAction.digit),
    KeypadKey(label: '9', action: KeypadAction.digit),
    KeypadKey(label: 'C', action: KeypadAction.clear, icon: Icons.clear_all),
    KeypadKey(label: '0', action: KeypadAction.digit),
    KeypadKey(label: '⌫', action: KeypadAction.delete, icon: Icons.backspace),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final keySize = _calculateKeySize(screenWidth);

    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _keys.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: keySpacing!,
            crossAxisSpacing: keySpacing!,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (context, index) {
            final key = _keys[index];
            return KeypadButton(
              keypadKey: key,
              size: keySize,
              borderRadius: keyBorderRadius!,
              onTap: () => onKeyPressed(key.action, key.label),
            );
          },
        ),
        SizedBox(height: 12),

        // Submit button separate from keypad
      ],
    );
  }

  double _calculateKeySize(double screenWidth) {
    return (screenWidth - 12 * 2 - 16 * 2) / 3;
  }
}

// ==========================================
// Keypad Button Widget
// widgets/keypad_button.dart

class KeypadKey {
  final String label;
  final KeypadAction action;
  final IconData? icon;

  const KeypadKey({required this.label, required this.action, this.icon});
}

class KeypadButton extends StatefulWidget {
  final KeypadKey keypadKey;
  final double size;
  final double borderRadius;
  final VoidCallback onTap;

  const KeypadButton({
    super.key,
    required this.keypadKey,
    required this.size,
    required this.borderRadius,
    required this.onTap,
  });

  @override
  State<KeypadButton> createState() => _KeypadButtonState();
}

class _KeypadButtonState extends State<KeypadButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) => _handleTapDown(),
            onTapUp: (_) => _handleTapUp(),

            onTapCancel: _handleTapCancel,
            onTap: widget.onTap,
            child: Container(
              constraints: const BoxConstraints(minWidth: 64, minHeight: 64),
              decoration: _buildButtonDecoration(),
              child: Center(child: _buildButtonContent()),
            ),
          ),
        );
      },
    );
  }

  BoxDecoration _buildButtonDecoration() {
    return BoxDecoration(
      color: _getButtonColor(),
      borderRadius: BorderRadius.circular(widget.borderRadius),
      boxShadow: _isPressed
          ? []
          : [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
    );
  }

  Color _getButtonColor() {
    // All buttons have the same color now
    return _isPressed ? AppColors.primary.withOpacity(0.8) : AppColors.primary;
  }

  Widget _buildButtonContent() {
    if (widget.keypadKey.icon != null) {
      return Icon(
        widget.keypadKey.icon,
        size: _getIconSize(),
        color: AppColors.backgroundPrimary,
      );
    }

    return Text(
      widget.keypadKey.label,
      style: TextStyle(
        fontSize: _getFontSize(),
        fontWeight: FontWeight.bold,
        color: AppColors.backgroundPrimary,
      ),
    );
  }

  double _getIconSize() {
    // Made all icons smaller
    return 25;
  }

  double _getFontSize() {
    // Made font smaller
    return 25;
  }

  void _handleTapDown() {
    setState(() => _isPressed = true);
    _animationController.forward();
    HapticFeedback.lightImpact();
  }

  void _handleTapUp() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }
}
