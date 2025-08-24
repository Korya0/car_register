// ignore_for_file: deprecated_member_use

import 'package:car_register_app/core/resources/theme/app_colors.dart';
import 'package:car_register_app/core/widgets/animations/animate_do.dart';
import 'package:car_register_app/core/widgets/common/custom_button.dart';
import 'package:car_register_app/core/widgets/common/custom_text_form_field.dart';
import 'package:car_register_app/core/widgets/common/text_app.dart';
import 'package:car_register_app/core/widgets/ui_tools/loading_overlay.dart';
import 'package:car_register_app/core/widgets/ui_tools/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/car_register_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final Map<String, AnimationController> _slideOutControllers = {};
  final Map<String, Animation<Offset>> _slideOutAnimations = {};

  @override
  void initState() {
    super.initState();
    context.read<CarRegisterCubit>().initializeApp();
  }

  @override
  void dispose() {
    _controller.dispose();
    for (final controller in _slideOutControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _initializeSlideOutAnimation(String number) {
    if (!_slideOutControllers.containsKey(number)) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this,
      );
      final animation = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(-1.5, 0),
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInBack));

      _slideOutControllers[number] = controller;
      _slideOutAnimations[number] = animation;
    }
  }

  void _deleteCarNumber(String number) {
    showDialog(
      context: context,
      builder: (context) => CustomFadeInDown(
        duration: 300,
        child: AlertDialog(
          backgroundColor: AppColors.backgroundSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const TextApp(
            text: 'تأكيد الحذف',
            type: TextAppType.bodyLarge,
            color: AppColors.textAndIconPrimary,
            fontWeight: FontWeight.bold,
          ),
          content: TextApp(
            text: 'هل تريد حذف الرقم $number؟',
            type: TextAppType.bodyMedium,
            color: AppColors.textAndIconSecondary,
          ),
          actions: [
            CustomButton(
              text: 'إلغاء',
              backgroundColor: AppColors.backgroundPrimary,
              textColor: AppColors.textAndIconSecondary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              onTap: () => Navigator.of(context).pop(),
            ),
            const SizedBox(width: 8),
            CustomButton(
              text: 'حذف',
              backgroundColor: AppColors.red,
              textColor: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              onTap: () {
                Navigator.of(context).pop();
                _animateDeleteAndRemove(number);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _animateDeleteAndRemove(String number) {
    _initializeSlideOutAnimation(number);
    final controller = _slideOutControllers[number]!;
    controller.forward().then((_) {
      context.read<CarRegisterCubit>().deleteCarNumber(number);
      controller.dispose();
      _slideOutControllers.remove(number);
      _slideOutAnimations.remove(number);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomFadeInDown(
          duration: 500,
          child: const TextApp(
            text: 'تسجيل السيارات',
            type: TextAppType.bodyLarge,
            color: AppColors.textAndIconPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.backgroundSecondary,
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocConsumer<CarRegisterCubit, CarRegisterState>(
        listener: (context, state) {
          if (state is CarRegisterError) {
            ToastMessage.error(context, state.message);
          } else if (state is CarRegisterLoaded &&
              state.successMessage != null) {
            ToastMessage.success(context, state.successMessage!);
          }
        },
        builder: (context, state) {
          if (state is CarRegisterLoading) {
            return const LoadingOverlay();
          }

          if (state is CarRegisterError) {
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
                          const Icon(
                            Icons.error_outline,
                            size: 80,
                            color: AppColors.red,
                          ),
                          const SizedBox(height: 24),
                          TextApp(
                            text: state.message,
                            type: TextAppType.bodyLarge,
                            color: AppColors.textAndIconPrimary,
                            textAlign: TextAlign.center,
                            fontWeight: FontWeight.w500,
                          ),
                          const SizedBox(height: 32),
                          CustomButton(
                            text: 'إعادة المحاولة',
                            backgroundColor: AppColors.primary,
                            textColor: AppColors.backgroundPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            onTap: () => context
                                .read<CarRegisterCubit>()
                                .initializeApp(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          if (state is CarRegisterLoaded) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Input Form
                    CustomFadeInDown(
                      duration: 600,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundSecondary,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              CustomTextFormField(
                                controller: _controller,
                                hintText: 'أدخل رقم السيارة',
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'يرجى إدخال رقم السيارة';
                                  }
                                  if (!RegExp(r'^\d+$').hasMatch(value)) {
                                    return 'يُسمح بالأرقام فقط';
                                  }
                                  return null;
                                },
                                suffixIcon: const Icon(
                                  Icons.directions_car,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: CustomButton(
                                  text: 'حفظ السيارة',
                                  backgroundColor: AppColors.primary,
                                  textColor: AppColors.backgroundPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  isLoading: state.isAddingNumber,
                                  onTap: state.isAddingNumber
                                      ? null
                                      : () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            context
                                                .read<CarRegisterCubit>()
                                                .addCarNumber(
                                                  _controller.text.trim(),
                                                );
                                            _controller.clear();
                                          }
                                        },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // List Title
                    CustomFadeInLeft(
                      duration: 700,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.list_alt,
                              color: AppColors.primary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const TextApp(
                            text: 'السيارات المسجلة',
                            type: TextAppType.bodyLarge,
                            color: AppColors.textAndIconPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // List View
                    state.carNumbers.isEmpty
                        ? CustomFadeInUp(
                            duration: 800,
                            child: SizedBox(
                              height: 300,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(32),
                                      decoration: BoxDecoration(
                                        color: AppColors.backgroundSecondary,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: AppColors.primary.withOpacity(
                                            0.3,
                                          ),
                                          width: 2,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.directions_car_outlined,
                                        size: 80,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    const TextApp(
                                      text: 'لا توجد سيارات مسجلة',
                                      type: TextAppType.bodyLarge,
                                      color: AppColors.textAndIconPrimary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                    ),
                                    const SizedBox(height: 12),
                                    const TextApp(
                                      text: 'ابدأ بإضافة رقم السيارة الأول',
                                      type: TextAppType.bodyMedium,
                                      color: AppColors.textAndIconSecondary,
                                      fontSize: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.carNumbers.length,
                            itemBuilder: (context, index) {
                              final number = state.carNumbers[index];
                              _initializeSlideOutAnimation(number);
                              return SlideTransition(
                                position: _slideOutAnimations[number]!,
                                child: CustomFadeInRight(
                                  duration: 600 + (index * 100),
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      color: AppColors.backgroundSecondary,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: AppColors.primary.withOpacity(
                                          0.2,
                                        ),
                                        width: 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(16),
                                      leading: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              AppColors.primary,
                                              AppColors.primary.withOpacity(
                                                0.7,
                                              ),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                        ),
                                        child: Center(
                                          child: TextApp(
                                            text: '${index + 1}',
                                            type: TextAppType.bodyMedium,
                                            color: AppColors.backgroundPrimary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      title: TextApp(
                                        text: number,
                                        type: TextAppType.bodyLarge,
                                        color: AppColors.textAndIconPrimary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                      subtitle: const TextApp(
                                        text: 'رقم السيارة المسجلة',
                                        type: TextAppType.bodySmall,
                                        color: AppColors.textAndIconSecondary,
                                        fontSize: 12,
                                      ),
                                      trailing: state.isDeletingNumber
                                          ? const LoadingIndicator()
                                          : GestureDetector(
                                              onTap: () =>
                                                  _deleteCarNumber(number),
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                  12,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.red
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: AppColors.red
                                                        .withOpacity(0.3),
                                                    width: 1,
                                                  ),
                                                ),
                                                child: const Icon(
                                                  Icons.delete_outline,
                                                  color: AppColors.red,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            );
          }

          return const LoadingOverlay();
        },
      ),
    );
  }
}
