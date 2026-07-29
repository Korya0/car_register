import 'package:car_register_app/core/style/font/app_text_styles.dart';
import 'package:car_register_app/core/style/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum KeypadAction { digit, delete, submit, clear }

typedef KeypadCallback = void Function(KeypadAction action, [String? value]);

class CustomKeypad extends StatelessWidget {

  const CustomKeypad({
    required this.onKeyPressed,
    super.key,
    this.keySpacing = 12,
    this.keyBorderRadius = 16,
  });
  final KeypadCallback onKeyPressed;
  final double? keySpacing;
  final double? keyBorderRadius;

  static const List<KeypadKey> _keys = [
    KeypadKey(label: '1', action: KeypadAction.digit),
    KeypadKey(label: '2', action: KeypadAction.digit),
    KeypadKey(label: '3', action: KeypadAction.digit),
    KeypadKey(label: '4', action: KeypadAction.digit),
    KeypadKey(label: '5', action: KeypadAction.digit),
    KeypadKey(label: '6', action: KeypadAction.digit),
    KeypadKey(label: '7', action: KeypadAction.digit),
    KeypadKey(label: '8', action: KeypadAction.digit),
    KeypadKey(label: '9', action: KeypadAction.digit),
    KeypadKey(label: 'C', action: KeypadAction.clear, icon: Icons.clear_all),
    KeypadKey(label: '0', action: KeypadAction.digit),
    KeypadKey(
      label: '⌫',
      action: KeypadAction.delete,
      icon: Icons.backspace_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _keys.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: keySpacing!,
        crossAxisSpacing: keySpacing!,
        childAspectRatio: 1.1,
      ),
      itemBuilder: (context, index) {
        final key = _keys[index];
        return KeypadButton(
          keypadKey: key,
          borderRadius: keyBorderRadius!,
          onTap: () => onKeyPressed(key.action, key.label),
        );
      },
    );
  }
}

class KeypadKey {

  const KeypadKey({required this.label, required this.action, this.icon});
  final String label;
  final KeypadAction action;
  final IconData? icon;
}

class KeypadButton extends StatefulWidget {

  const KeypadButton({
    required this.keypadKey,
    required this.borderRadius,
    required this.onTap,
    super.key,
  });
  final KeypadKey keypadKey;
  final double borderRadius;
  final VoidCallback onTap;

  @override
  State<KeypadButton> createState() => _KeypadButtonState();
}

class _KeypadButtonState extends State<KeypadButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 0.92).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) => _handleTapDown(),
            onTapUp: (_) => _handleTapUp(),
            onTapCancel: _handleTapCancel,
            onTap: widget.onTap,
            child: Container(
              constraints: const BoxConstraints(minWidth: 70, minHeight: 70),
              decoration: _buildButtonDecoration(),
              child: Center(child: _buildButtonContent()),
            ),
          ),
        );
      },
    );
  }

  BoxDecoration _buildButtonDecoration() {
    return BoxDecoration(
      color: _getButtonColor(),
      borderRadius: BorderRadius.circular(widget.borderRadius),
      boxShadow: _isPressed
          ? []
          : [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
      border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
    );
  }

  Color _getButtonColor() {
    return _isPressed
        ? AppColors.primary.withValues(alpha: 0.8)
        : AppColors.primary;
  }

  Widget _buildButtonContent() {
    return Text(widget.keypadKey.label, style: AppTextStyles.keypadDigit);
  }

  void _handleTapDown() {
    if (mounted) {
      setState(() => _isPressed = true);
      _animationController.forward();
      HapticFeedback.lightImpact();
    }
  }

  void _handleTapUp() {
    if (mounted) {
      setState(() => _isPressed = false);
      _animationController.reverse();
    }
  }

  void _handleTapCancel() {
    if (mounted) {
      setState(() => _isPressed = false);
      _animationController.reverse();
    }
  }
}
