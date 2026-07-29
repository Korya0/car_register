import 'package:car_register_app/core/style/font/app_text_styles.dart';
import 'package:car_register_app/core/style/theme/app_colors.dart';
import 'package:car_register_app/core/widgets/animate_do.dart';
import 'package:flutter/material.dart';

enum ToastType { success, error, warning, info }

class ToastMessage {
  static OverlayEntry? _currentToast;

  static void show(
    BuildContext context,
    String message, {
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    _currentToast?.remove();
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => _ToastWidget(message: message, type: type),
    );
    _currentToast = overlayEntry;
    overlay.insert(overlayEntry);
    Future.delayed(duration, () {
      overlayEntry.remove();
      _currentToast = null;
    });
  }

  static void success(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    show(context, message, type: ToastType.success, duration: duration);
  }

  static void error(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
  }) {
    show(context, message, type: ToastType.error, duration: duration);
  }

  static void warning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    show(context, message, type: ToastType.warning, duration: duration);
  }

  static void info(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    show(context, message, duration: duration);
  }
}

class _ToastWidget extends StatelessWidget {

  const _ToastWidget({required this.message, required this.type});
  final String message;
  final ToastType type;

  Color get _backgroundColor {
    switch (type) {
      case ToastType.success:
        return AppColors.primary;
      case ToastType.error:
        return Colors.red.shade600;
      case ToastType.warning:
        return Colors.orange.shade600;
      case ToastType.info:
        return AppColors.textAndIconThritly;
    }
  }

  Color get _textColor {
    switch (type) {
      case ToastType.success:
        return AppColors.backgroundPrimary;
      case ToastType.error:
      case ToastType.warning:
        return Colors.white;
      case ToastType.info:
        return AppColors.textAndIconPrimary;
    }
  }

  IconData get _icon {
    switch (type) {
      case ToastType.success:
        return Icons.check_circle;
      case ToastType.error:
        return Icons.error;
      case ToastType.warning:
        return Icons.warning;
      case ToastType.info:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 20,
      left: 20,
      right: 20,
      child: CustomFadeInDown(
        duration: 300,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: _backgroundColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_icon, color: _textColor, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: AppTextStyles.toast.copyWith(color: _textColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
