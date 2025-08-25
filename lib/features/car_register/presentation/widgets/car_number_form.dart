import 'package:car_register_app/core/resources/theme/app_colors.dart';
import 'package:car_register_app/core/widgets/animations/animate_do.dart';
import 'package:car_register_app/core/widgets/common/custom_button.dart';
import 'package:car_register_app/core/widgets/common/custom_text_form_field.dart';
import 'package:car_register_app/core/widgets/ui_tools/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
              const SizedBox(height: 20),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  /// بناء تصميم الحاوية
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

  /// بناء حقل إدخال النص
  Widget _buildTextField() {
    return CustomTextFormField(
      controller: _controller,
      hintText: 'أدخل رقم السيارة',
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: _validateCarNumber,
      suffixIcon: const Icon(Icons.directions_car, color: AppColors.primary),
    );
  }

  /// التحقق من صحة رقم السيارة
  String? _validateCarNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال رقم السيارة';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'يُسمح بالأرقام فقط';
    }
    if (value.length < 2) {
      return 'رقم السيارة يجب أن يكون رقمين على الأقل';
    }
    return null;
  }

  /// بناء زر الإرسال
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        text: 'حفظ السيارة',
        backgroundColor: AppColors.primary,
        textColor: AppColors.backgroundPrimary,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        isLoading: widget.state.isAddingNumber,
        onTap: widget.state.isAddingNumber ? null : _handleSubmit,
      ),
    );
  }

  /// معالجة إرسال النموذج
  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final carNumber = _controller.text.trim();

    if (_isCarNumberExists(carNumber)) {
      ToastMessage.error(context, 'هذا الرقم موجود بالفعل');
      return;
    }

    _addCarNumber(carNumber);
  }

  /// التحقق من وجود رقم السيارة
  bool _isCarNumberExists(String carNumber) {
    return widget.state.carNumbers.contains(carNumber);
  }

  /// إضافة رقم السيارة
  void _addCarNumber(String carNumber) {
    context.read<CarRegisterCubit>().addCarNumber(carNumber);
    _controller.clear();
    FocusScope.of(context).unfocus();
  }
}
