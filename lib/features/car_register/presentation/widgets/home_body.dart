import 'package:car_register_app/features/car_register/presentation/controllers/car_register_cubit.dart';
import 'package:car_register_app/features/car_register/presentation/controllers/car_register_state.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/add_car_number_widget.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/list_car_numbers_widget.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/error_state_widget.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/skeleton_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CarRegisterCubit, CarRegisterState>(
      builder: (context, state) {
        return switch (state) {
          CarRegisterInitial() || CarRegisterLoading() => const AddPageSkeleton(),
          CarRegisterFailure(failure: final f, carNumbers: final nums) when nums.isEmpty =>
            ErrorStateWidget(
              message: f.message,
              onRetry: () => context.read<CarRegisterCubit>().initializeApp(),
            ),
          CarRegisterLoaded(currentPage: AppPageView.add) ||
          CarRegisterFailure(currentPage: AppPageView.add) =>
            const AddCarNumberWidget(),
          CarRegisterLoaded(currentPage: AppPageView.list) =>
            const ListCarNumbersWidget(),
          _ => const ListPageSkeleton(),
        };
      },
    );
  }
}
