import 'package:car_register_app/core/style/font/app_text_styles.dart';
import 'package:car_register_app/core/style/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData theme() {
    final textTheme = TextTheme(
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,
    );

    return ThemeData(
      scaffoldBackgroundColor: AppColors.backgroundPrimary,
      primaryColor: AppColors.primary,
      brightness: Brightness.dark,
      iconTheme: const IconThemeData(color: AppColors.textAndIconPrimary),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundSecondary,
        iconTheme: const IconThemeData(color: AppColors.textAndIconPrimary),
        titleTextStyle: AppTextStyles.appBarTitle,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textAndIconPrimary,
      ),
    );
  }
}
