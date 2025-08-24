// splash_view.dart
import 'package:car_register_app/core/resources/router/app_routes.dart';
import 'package:car_register_app/features/loc_app/presentation/cubits/lock_app_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<LockAppCubit, bool>(
          listener: (context, isActive) {
            Future.delayed(const Duration(seconds: 3), () {
              if (context.mounted) {
                try {
                  if (isActive) {
                    context.goNamed(AppRoutes.home);
                  } else {
                    context.goNamed(AppRoutes.lockApp);
                  }
                } catch (e) {
                  // Fallback to home screen on error
                  context.goNamed(AppRoutes.home);
                }
              }
            });
          },
          child: const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
