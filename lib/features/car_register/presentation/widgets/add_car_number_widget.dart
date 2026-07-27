import 'package:car_register_app/features/car_register/presentation/controllers/car_register_cubit.dart';
import 'package:car_register_app/features/car_register/presentation/controllers/car_register_state.dart';
import 'package:car_register_app/features/car_register/presentation/widgets/car_number_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCarNumberWidget extends StatelessWidget {
  const AddCarNumberWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isAddingNumber = context.select<CarRegisterCubit, bool>(
      (cubit) => cubit.state is CarRegisterLoaded && (cubit.state as CarRegisterLoaded).isAddingNumber,
    );

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(12),
      child: CarNumberForm(isAddingNumber: isAddingNumber),
    );
  }
}
