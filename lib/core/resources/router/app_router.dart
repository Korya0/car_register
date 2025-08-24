import 'package:car_register_app/core/resources/router/app_routes.dart';
import 'package:car_register_app/core/resources/router/app_transitions.dart';
import 'package:car_register_app/features/car_register/presentation/views/home_screen.dart';
import 'package:car_register_app/features/loc_app/presentation/views/lock_app_view.dart';
import 'package:car_register_app/features/loc_app/presentation/views/splash_view.dart';
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
          child: const HomeScreen(),
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
  );
}
