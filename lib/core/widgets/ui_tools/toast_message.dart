// ignore_for_file: deprecated_member_use

import 'package:car_register_app/core/theme/app_colors.dart';
import 'package:car_register_app/core/widgets/animations/animate_do.dart';
import 'package:car_register_app/core/widgets/common/text_app.dart';
import 'package:flutter/material.dart';

enum ToastType { success, error, warning, info }

enum ToastPosition { top, bottom, center }

class ToastMessage {
  static OverlayEntry? _currentToast;

  static show(
    BuildContext context,
    String message, {
    ToastType type = ToastType.info,
    ToastPosition position = ToastPosition.bottom,
    Duration duration = const Duration(seconds: 3),
    IconData? icon,
  }) {
    // إزالة Toast السابق إذا كان موجود
    if (_currentToast != null && _currentToast!.mounted) {
      _currentToast!.remove();
    }

    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _ToastWidget(
        message: message,
        type: type,
        position: position,
        icon: icon,
        onDismiss: () {
          if (overlayEntry.mounted) {
            overlayEntry.remove();
          }
          _currentToast = null;
        },
      ),
    );

    _currentToast = overlayEntry;
    overlay.insert(overlayEntry);

    Future.delayed(duration).then((_) {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
      _currentToast = null;
    });
  }

  // Quick methods for different types
  static success(
    BuildContext context,
    String message, {
    ToastPosition position = ToastPosition.top,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context,
      message,
      type: ToastType.success,
      position: position,
      duration: duration,
      icon: Icons.check_circle,
    );
  }

  static error(
    BuildContext context,
    String message, {
    ToastPosition position = ToastPosition.top,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context,
      message,
      type: ToastType.error,
      position: position,
      duration: duration,
      icon: Icons.error,
    );
  }

  static warning(
    BuildContext context,
    String message, {
    ToastPosition position = ToastPosition.center,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context,
      message,
      type: ToastType.warning,
      position: position,
      duration: duration,
      icon: Icons.warning,
    );
  }

  static info(
    BuildContext context,
    String message, {
    ToastPosition position = ToastPosition.bottom,
    Duration duration = const Duration(seconds: 2),
  }) {
    show(
      context,
      message,
      type: ToastType.info,
      position: position,
      duration: duration,
      icon: Icons.info,
    );
  }
}

class _ToastWidget extends StatefulWidget {
  const _ToastWidget({
    required this.message,
    required this.type,
    required this.position,
    required this.onDismiss,
    this.icon,
  });

  final String message;
  final ToastType type;
  final ToastPosition position;
  final IconData? icon;
  final VoidCallback onDismiss;

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget> {
  final bool _isVisible = true;

  Color _getBackgroundColor() {
    switch (widget.type) {
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

  Color _getTextColor() {
    switch (widget.type) {
      case ToastType.success:
        return AppColors.backgroundPrimary;
      case ToastType.error:
      case ToastType.warning:
        return Colors.white;
      case ToastType.info:
        return AppColors.textAndIconPrimary;
    }
  }

  Color _getIconColor() {
    return _getTextColor();
  }

  Widget _getPositionedToast() {
    final toast = _buildToastContent();

    switch (widget.position) {
      case ToastPosition.top:
        return Positioned(
          top: MediaQuery.of(context).padding.top + 20,
          left: 20,
          right: 20,
          child: CustomFadeInDown(duration: 300, child: toast),
        );
      case ToastPosition.center:
        return Positioned(
          top: MediaQuery.of(context).size.height * 0.4,
          left: 20,
          right: 20,
          child: CustomFadeInUp(duration: 300, child: toast),
        );
      case ToastPosition.bottom:
        return Positioned(
          bottom: MediaQuery.of(context).padding.bottom + 50,
          left: 20,
          right: 20,
          child: CustomFadeInUp(duration: 300, child: toast),
        );
    }
  }

  Widget _buildToastContent() {
    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: _getBackgroundColor(),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, color: _getIconColor(), size: 20),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: TextApp(
                  text: widget.message,
                  type: TextAppType.bodyMedium,
                  color: _getTextColor(),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getPositionedToast();
  }
}
