import 'package:car_register_app/core/resources/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData theme() {
    final textTheme = TextTheme(
      bodyLarge: GoogleFonts.changa(
        color: AppColors.textAndIconPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.changa(
        color: AppColors.textAndIconSecondary,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.25,
        height: 1.4,
      ),
      bodySmall: GoogleFonts.changa(
        color: AppColors.textAndIconThritly,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.2,
        height: 1.3,
      ),
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
        titleTextStyle: GoogleFonts.changa(
          color: AppColors.textAndIconPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textAndIconPrimary,
      ),
    );
  }
}
