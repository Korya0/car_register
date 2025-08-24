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

  // لتتبع آخر حالة
  CarRegisterState? _lastState;

  // لمعرفة الكارد اللي بيتحذف الآن
  String? _deletingNumber;

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
                setState(() => _deletingNumber = number);
                context.read<CarRegisterCubit>().deleteCarNumber(number).then((
                  _,
                ) {
                  if (mounted) {
                    setState(() => _deletingNumber = null);
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  // معالجة الأخطاء
  void _handleError(CarRegisterState state) {
    if (state is CarRegisterError) {
      String errorMessage = state.message;
      if (errorMessage.contains('إضافة')) {
        errorMessage = 'فشل في إضافة رقم السيارة: ${state.message}';
      } else if (errorMessage.contains('حذف')) {
        errorMessage = 'فشل في حذف رقم السيارة: ${state.message}';
      } else if (errorMessage.contains('تحميل') ||
          errorMessage.contains('شبكة')) {
        errorMessage = 'خطأ في تحميل البيانات: ${state.message}';
      }
      ToastMessage.error(context, errorMessage);
    }
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
          if (_lastState.runtimeType != state.runtimeType) {
            if (state is CarRegisterError) {
              _handleError(state);
            }
          }
          _lastState = state;
        },
        builder: (context, state) {
          if (state is CarRegisterLoading) {
            return const LoadingOverlay();
          }

          if (state is CarRegisterError) {
            return _buildErrorState(state);
          }

          if (state is CarRegisterLoaded) {
            final reversedCarNumbers = state.carNumbers.reversed.toList();
            return _buildLoadedState(state, reversedCarNumbers);
          }

          return const LoadingOverlay();
        },
      ),
    );
  }

  Widget _buildErrorState(CarRegisterError state) {
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
                    Icons.warning_amber_rounded,
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
                    text: '🔄 إعادة المحاولة',
                    backgroundColor: AppColors.primary,
                    textColor: AppColors.backgroundPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    onTap: () =>
                        context.read<CarRegisterCubit>().initializeApp(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadedState(CarRegisterLoaded state, List<String> numbers) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildForm(state),
            const SizedBox(height: 30),
            _buildListTitle(state),
            const SizedBox(height: 16),
            numbers.isEmpty
                ? _buildEmptyState()
                : _buildCarList(numbers, state),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(CarRegisterLoaded state) {
    return CustomFadeInDown(
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
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
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
                          if (_formKey.currentState!.validate()) {
                            final carNumber = _controller.text.trim();
                            if (state.carNumbers.contains(carNumber)) {
                              ToastMessage.error(
                                context,
                                'هذا الرقم موجود بالفعل',
                              );
                              return;
                            }
                            context.read<CarRegisterCubit>().addCarNumber(
                              carNumber,
                            );
                            _controller.clear();
                            FocusScope.of(context).unfocus();
                          }
                        },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTitle(CarRegisterLoaded state) {
    return CustomFadeInLeft(
      duration: 700,
      child: Row(
        children: [
          const Icon(Icons.list_alt, color: AppColors.primary, size: 28),
          const SizedBox(width: 12),
          const TextApp(
            text: 'السيارات المسجلة',
            type: TextAppType.bodyLarge,
            color: AppColors.textAndIconPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          if (state.carNumbers.isNotEmpty) ...[
            const Spacer(),
            CircleAvatar(
              backgroundColor: AppColors.primary,
              radius: 16,
              child: TextApp(
                text: '${state.carNumbers.length}',
                type: TextAppType.bodySmall,
                color: AppColors.backgroundPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return CustomFadeInUp(
      duration: 800,
      child: SizedBox(
        height: 300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.car_crash, size: 80, color: AppColors.primary),
              SizedBox(height: 20),
              TextApp(
                text: 'لا توجد سيارات مسجلة',
                type: TextAppType.bodyLarge,
                color: AppColors.textAndIconPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
              SizedBox(height: 12),
              TextApp(
                text: 'ابدأ بإضافة رقم السيارة الأول',
                type: TextAppType.bodyMedium,
                color: AppColors.textAndIconSecondary,
                fontSize: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarList(List<String> numbers, CarRegisterLoaded state) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: numbers.length,
      itemBuilder: (context, index) {
        final number = numbers[index];
        _initializeSlideOutAnimation(number);

        return SlideTransition(
          position: _slideOutAnimations[number]!,
          child: CustomFadeInRight(
            duration: 600 + (index * 100),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.primary.withOpacity(0.15),
                  child: const Icon(
                    Icons.directions_car,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
                title: TextApp(
                  text: number,
                  type: TextAppType.bodyLarge,
                  color: AppColors.textAndIconPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                subtitle: TextApp(
                  text:
                      'تاريخ التسجيل: ${DateTime.now().toString().substring(0, 10)}',
                  type: TextAppType.bodySmall,
                  color: AppColors.textAndIconSecondary,
                  fontSize: 12,
                ),
                trailing: _deletingNumber == number
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.red,
                          ),
                        ),
                      )
                    : IconButton(
                        icon: const Icon(
                          Icons.delete_forever,
                          color: AppColors.red,
                          size: 26,
                        ),
                        onPressed: () => _deleteCarNumber(number),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
