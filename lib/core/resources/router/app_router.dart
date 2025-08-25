// app_router.dart
import 'package:car_register_app/core/resources/router/app_routes.dart';
import 'package:car_register_app/core/resources/router/app_transitions.dart';
import 'package:car_register_app/core/utils/di/injuction.dart';
import 'package:car_register_app/features/car_register/presentation/cubit/car_register_cubit.dart';
import 'package:car_register_app/features/car_register/presentation/views/home_view.dart';
import 'package:car_register_app/features/loc_app/presentation/views/lock_app_view.dart';
import 'package:car_register_app/features/loc_app/presentation/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.home,
        pageBuilder: (context, state) => AppTransitions.size(
          context: context,
          state: state,
          child: BlocProvider<CarRegisterCubit>(
            create: (context) => sl<CarRegisterCubit>(),
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: const HomeView(),
            ),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutes.splash,
        pageBuilder: (context, state) => AppTransitions.size(
          context: context,
          state: state,
          child: const SplashView(),
        ),
      ),
      GoRoute(
        path: AppRoutes.lockApp,
        name: AppRoutes.lockApp,
        pageBuilder: (context, state) => AppTransitions.size(
          context: context,
          state: state,
          child: const LockAppView(),
        ),
      ),
    ],
    errorPageBuilder: (context, state) => AppTransitions.size(
      context: context,
      state: state,
      child: const Scaffold(body: Center(child: Text('Something went wrong!'))),
    ),
  );
}
