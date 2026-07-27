import 'package:car_register_app/core/router/app_routes.dart';
import 'package:car_register_app/core/router/app_transitions.dart';
import 'package:car_register_app/core/utils/app_logger.dart';
import 'package:car_register_app/features/car_register/presentation/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.home,
        pageBuilder: (context, state) => AppTransitions.size(
          context: context,
          state: state,
          child: const HomeView(),
        ),
      ),
    ],
    errorPageBuilder: (context, state) {
      AppLogger.error(
        'Router: navigation error - ${state.error}',
        error: state.error,
      );
      return AppTransitions.size(
        context: context,
        state: state,
        child: const Scaffold(
          body: Center(child: Text('Something went wrong!')),
        ),
      );
    },
  );
}
