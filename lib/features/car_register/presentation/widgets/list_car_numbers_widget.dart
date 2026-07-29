import 'package:car_register_app/features/car_register/data/models/car_number_model.dart';
import 'package:car_register_app/features/car_register/presentation/controllers/car_register_cubit.dart';
import 'package:car_register_app/features/car_register/presentation/controllers/car_register_state.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/car_numbers_list.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/empty_state_widget.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/list_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ListCarNumbersWidget extends StatelessWidget {
  const ListCarNumbersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ListHeaderWidget(),
          SizedBox(height: 16.h),
          const _NumbersListSection(),
        ],
      ),
    );
  }
}

class _NumbersListSection extends StatelessWidget {
  const _NumbersListSection();

  @override
  Widget build(BuildContext context) {
    final numbers = context.select<CarRegisterCubit, List<CarNumberModel>>((cubit) {
      final state = cubit.state;
      final nums = switch (state) {
        final CarRegisterLoaded s => s.carNumbers,
        final CarRegisterFailure s => s.carNumbers,
        _ => const <CarNumberModel>[],
      };
      return List<CarNumberModel>.from(nums.reversed);
    });

    if (numbers.isEmpty) return const EmptyStateWidget();
    return CarNumbersList(numbers: numbers);
  }
}
