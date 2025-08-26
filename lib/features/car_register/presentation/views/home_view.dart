// ignore_for_file: deprecated_member_use

import 'package:car_register_app/core/resources/theme/app_colors.dart';
import 'package:car_register_app/core/widgets/animations/animate_do.dart';
import 'package:car_register_app/core/widgets/common/text_app.dart';
import 'package:car_register_app/core/widgets/ui_tools/loading_overlay.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/car_number_form.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/car_numbers_list.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/empty_state_widget.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/error_handelar.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/error_state_widget.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/list_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cubit/car_register_cubit.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;
  CarRegisterState? _lastState;

  @override
  void initState() {
    super.initState();
    context.read<CarRegisterCubit>().initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: BlocConsumer<CarRegisterCubit, CarRegisterState>(
        listener: (context, state) {
          if (_lastState.runtimeType != state.runtimeType) {
            ErrorHandler.handleError(context, state);
          }
          _lastState = state;
        },
        builder: _buildBody,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  /// Build app bar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: CustomFadeInDown(
        duration: 500,
        child: const TextApp(
          text: 'تسجيل اللوحات',
          type: TextAppType.bodyLarge,
          color: AppColors.textAndIconPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
    );
  }

  /// Body
  Widget _buildBody(BuildContext context, CarRegisterState state) {
    if (state is CarRegisterLoading) {
      return const LoadingOverlay();
    }

    if (state is CarRegisterError) {
      return ErrorStateWidget(
        error: state,
        onRetry: () => context.read<CarRegisterCubit>().initializeApp(),
      );
    }

    if (state is CarRegisterLoaded) {
      return _buildPageContent(state);
    }

    return const LoadingOverlay();
  }

  /// محتوى الصفحات حسب bottom nav
  Widget _buildPageContent(CarRegisterLoaded state) {
    final reversedCarNumbers = state.carNumbers.reversed.toList();

    if (_currentIndex == 0) {
      // الصفحة الأولى -> تسجيل اللوحة
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(12),
        child: CarNumberForm(state: state),
      );
    } else {
      // الصفحة الثانية -> عرض الأرقام
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListHeaderWidget(carNumbers: state.carNumbers),
            SizedBox(height: 16.h),
            reversedCarNumbers.isEmpty
                ? const EmptyStateWidget()
                : CarNumbersList(numbers: reversedCarNumbers, state: state),
          ],
        ),
      );
    }
  }

  /// Bottom Navigation
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      backgroundColor: AppColors.backgroundSecondary,
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.add), label: 'تسجيل لوحة'),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: 'عرض اللوحات'),
      ],
    );
  }
}
