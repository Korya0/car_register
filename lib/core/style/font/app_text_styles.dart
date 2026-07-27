import 'package:car_register_app/core/style/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get keypadDigit => GoogleFonts.changa(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.backgroundPrimary,
  );

  static TextStyle get titleLarge => GoogleFonts.changa(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textAndIconPrimary,
  );

  static TextStyle get titleMedium => GoogleFonts.changa(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textAndIconPrimary,
  );

  static TextStyle get titleSmall => GoogleFonts.changa(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textAndIconPrimary,
  );

  static TextStyle get bodyLarge => GoogleFonts.changa(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textAndIconPrimary,
  );

  static TextStyle get bodyMedium => GoogleFonts.changa(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textAndIconSecondary,
  );

  static TextStyle get bodySmall => GoogleFonts.changa(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textAndIconPrimary,
  );

  static TextStyle get bodyXSmall => GoogleFonts.changa(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textAndIconSecondary,
  );

  static TextStyle get button => GoogleFonts.changa(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textAndIconThritly,
  );

  static TextStyle get buttonSecondary => GoogleFonts.changa(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.backgroundPrimary,
  );

  static TextStyle get selectedCount => GoogleFonts.changa(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static TextStyle get errorMessage => GoogleFonts.changa(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.red,
  );

  static TextStyle get hint => GoogleFonts.changa(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textAndIconSecondary.withAlpha(100),
  );

  static TextStyle get toast => GoogleFonts.changa(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textAndIconPrimary,
  );

  static TextStyle get counterNumber => GoogleFonts.changa(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textAndIconThritly,
  );

  static TextStyle get emptyTitle => GoogleFonts.changa(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textAndIconPrimary,
  );

  static TextStyle get emptySubtitle => GoogleFonts.changa(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textAndIconSecondary.withAlpha(100),
  );

  static TextStyle get appBarTitle => GoogleFonts.changa(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textAndIconPrimary,
  );

  static TextStyle get errorDescription => GoogleFonts.changa(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textAndIconPrimary,
  );

  static TextStyle get pinInput => GoogleFonts.changa(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textAndIconPrimary,
  );

  static TextStyle get pinHint => GoogleFonts.changa(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textAndIconSecondary,
  );

  static TextStyle get pinError => GoogleFonts.changa(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.red,
  );
}
