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

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _HomeViewBody());
  }

  /// Build app bar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
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
      centerTitle: true,
    );
  }
}

class _HomeViewBody extends StatefulWidget {
  const _HomeViewBody();

  @override
  State<_HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<_HomeViewBody> {
  CarRegisterState? _lastState;

  @override
  void initState() {
    super.initState();
    context.read<CarRegisterCubit>().initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CarRegisterCubit, CarRegisterState>(
      // listener
      listener: (context, state) {
        if (_lastState.runtimeType != state.runtimeType) {
          ErrorHandler.handleError(context, state);
        }
        _lastState = state;
      },

      // builder
      builder: _buildBody,
    );
  }

  /// بناء محتوى الشاشة
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
      return _buildLoadedContent(state);
    }

    return const LoadingOverlay();
  }

  Widget _buildLoadedContent(CarRegisterLoaded state) {
    final reversedCarNumbers = state.carNumbers.reversed.toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CarNumberForm(state: state),
            SizedBox(height: 30.h),
            ListHeaderWidget(carNumbers: state.carNumbers),
            SizedBox(height: 16.h),
            reversedCarNumbers.isEmpty
                ? const EmptyStateWidget()
                : CarNumbersList(numbers: reversedCarNumbers, state: state),
          ],
        ),
      ),
    );
  }
}
