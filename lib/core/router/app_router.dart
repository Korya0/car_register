import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/car_register/presentation/widgets/splash_screen.dart';
import '../../features/car_register/presentation/widgets/home_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/home',
        name: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
}
