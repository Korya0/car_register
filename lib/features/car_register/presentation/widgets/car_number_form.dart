// ignore_for_file: deprecated_member_use

import 'package:car_register_app/core/resources/theme/app_colors.dart';
import 'package:car_register_app/core/utils/validators.dart';
import 'package:car_register_app/core/widgets/animations/animate_do.dart';
import 'package:car_register_app/core/widgets/common/custom_button.dart';
import 'package:car_register_app/core/widgets/common/custom_text_form_field.dart';
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
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomFadeInDown(
      duration: 600,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: _buildContainerDecoration(),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(),
              SizedBox(height: 20.h),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  /// BuildContainerDecoration
  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      color: AppColors.backgroundSecondary,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }

  /// TextField
  Widget _buildTextField() {
    return CustomTextFormField(
      controller: _controller,
      hintText: 'أدخل رقم اللوحه',

      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: Validators.validateCarNumber,
      suffixIcon: Icon(
        Icons.onetwothree,
        size: 50,
        color: AppColors.textAndIconPrimary.withAlpha(100),
      ),
    );
  }

  /// _buildSubmitButton
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        text: 'حفظ اللوحه',
        backgroundColor: AppColors.primary,
        textColor: AppColors.textAndIconThritly,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        isLoading: widget.state.isAddingNumber,
        onTap: widget.state.isAddingNumber ? null : _handleSubmit,
      ),
    );
  }

  /// _handleSubmit
  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final carNumber = _controller.text.trim();

    if (_isCarNumberExists(carNumber)) {
      ToastMessage.error(context, 'هذا الرقم موجود بالفعل');
      return;
    }

    _addCarNumber(carNumber);
  }

  /// _isCarNumberExists
  bool _isCarNumberExists(String carNumber) {
    return widget.state.carNumbers.contains(carNumber);
  }

  /// _addCarNumber
  void _addCarNumber(String carNumber) {
    context.read<CarRegisterCubit>().addCarNumber(carNumber);
    _controller.clear();
    FocusScope.of(context).unfocus();
  }
}
