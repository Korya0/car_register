import 'package:car_register_app/core/style/theme/app_colors.dart';
import 'package:car_register_app/features/car_register/presentation/controllers/car_register_cubit.dart';
import 'package:car_register_app/features/car_register/presentation/controllers/car_register_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.select<CarRegisterCubit, int>((cubit) {
      final state = cubit.state;
      final page = switch (state) {
        CarRegisterLoaded s => s.currentPage,
        CarRegisterFailure s => s.currentPage,
        _ => AppPageView.add,
      };
      return page == AppPageView.add ? 0 : 1;
    });

    return BottomNavigationBar(
      backgroundColor: AppColors.backgroundSecondary,
      currentIndex: currentIndex,
      onTap: (index) {
        context.read<CarRegisterCubit>().setCurrentPage(
              index == 0 ? AppPageView.add : AppPageView.list,
            );
      },
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.add, size: 28), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.list, size: 28), label: ''),
      ],
    );
  }
}
