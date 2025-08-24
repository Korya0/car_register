import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppTransitions {
  AppTransitions._();

  // Default transition duration
  static const Duration _duration = Duration(milliseconds: 300);
  static const Duration _reverseDuration = Duration(milliseconds: 250);

  static CustomTransitionPage size({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    Duration? duration,
    Duration? reverseDuration,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: duration ?? _duration,
      reverseTransitionDuration: reverseDuration ?? _reverseDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return Align(
          child: SizeTransition(sizeFactor: animation, child: child),
        );
      },
    );
  }
}
