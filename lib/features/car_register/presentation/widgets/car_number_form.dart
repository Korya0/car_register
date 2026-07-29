// ignore_for_file: use_if_null_to_convert_nulls_to_bools, use_build_context_synchronously

import 'package:car_register_app/core/constants/app_constants.dart';
import 'package:car_register_app/core/constants/app_strings.dart';
import 'package:car_register_app/core/style/theme/app_colors.dart';
import 'package:car_register_app/core/widgets/animate_do.dart';
import 'package:car_register_app/core/widgets/toast_message.dart';
import 'package:car_register_app/features/car_register/data/models/car_number_model.dart';
import 'package:car_register_app/features/car_register/presentation/controllers/car_register_cubit.dart';
import 'package:car_register_app/features/car_register/presentation/controllers/car_register_state.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/car_number_text_field.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/car_submit_button.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/custom_keypad.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/pin_verification_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CarNumberForm extends StatefulWidget {

  const CarNumberForm({required this.isAddingNumber, super.key});
  final bool isAddingNumber;

  @override
  State<CarNumberForm> createState() => _CarNumberFormState();
}

class _CarNumberFormState extends State<CarNumberForm> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
              isLoading: widget.isAddingNumber,
              onTap: widget.isAddingNumber ? null : _handleSubmit,
              onLongPress: widget.isAddingNumber
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
      case KeypadAction.delete:
        _deleteLastDigit();
      case KeypadAction.submit:
        _handleSubmit();
      case KeypadAction.clear:
        _clearAllDigits();
    }
  }

  void _addDigit(String digit) {
    if (_controller.text.length < AppConstants.maxCarNumberLength) {
      setState(() => _controller.text += digit);
    } else {
      ToastMessage.error(
        context,
        '${AppStrings.maxDigitsReached} ${AppConstants.maxCarNumberLength} ${AppStrings.maxDigitsSuffix}',
      );
    }
  }

  void _deleteLastDigit() {
    if (_controller.text.isNotEmpty) {
      setState(
        () => _controller.text = _controller.text.substring(
          0,
          _controller.text.length - 1,
        ),
      );
    }
  }

  void _handleSubmit() {
    if (!mounted || !_formKey.currentState!.validate()) return;
    final carNumber = _controller.text.trim();
    final cubit = context.read<CarRegisterCubit>();
    final currentNumbers = switch (cubit.state) {
      final CarRegisterLoaded s => s.carNumbers,
      _ => const <CarNumberModel>[],
    };
    if (currentNumbers.any((model) => model.number == carNumber)) {
      ToastMessage.error(context, AppStrings.plateNumberAlreadyExists);
      return;
    }
    _addCarNumber(carNumber);
  }

  Future<void> _handleClearAllWithPIN() async {
    if (!mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber, color: Colors.orange),
            SizedBox(width: 8),
            Text(AppStrings.confirmClearAll),
          ],
        ),
        content: const Text(AppStrings.confirmClearAllContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text(AppStrings.proceed),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final cubit = context.read<CarRegisterCubit>();
      final pinVerified = await PinVerificationDialog.show(context);
      if (pinVerified && mounted) {
        await cubit.clearAll();
        
        ToastMessage.success(context, AppStrings.allDeletedSuccessfully);
      }
    }
  }

  void _addCarNumber(String carNumber) {
    if (!mounted) return;
    context.read<CarRegisterCubit>().addCarNumber(carNumber);
    setState(_controller.clear);
    FocusScope.of(context).unfocus();
  }

  void _clearAllDigits() {
    if (!mounted) return;
    setState(_controller.clear);
  }
}
