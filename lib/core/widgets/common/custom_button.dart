import 'package:car_register_app/core/resources/theme/app_colors.dart';
import 'package:car_register_app/core/widgets/common/text_app.dart';
import 'package:car_register_app/core/widgets/ui_tools/loading_overlay.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.text,
    this.onTap,
    this.onLongPress,
    this.backgroundColor = AppColors.backgroundSecondary,
    this.textColor,
    this.textType = TextAppType.bodyMedium,
    this.fontSize,
    this.fontWeight,
    this.padding,
    this.borderRadius = 12,
    super.key,
    this.isLoading,
    this.child,
  });

  final String text;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color backgroundColor;
  final Color? textColor;
  final TextAppType textType;
  final double? fontSize;
  final FontWeight? fontWeight;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final bool? isLoading;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child:
            child ??
            Center(
              child: isLoading == true
                  ? LoadingIndicator()
                  : TextApp(
                      text: text,
                      type: textType,
                      color: textColor,
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                    ),
            ),
      ),
    );
  }
}
