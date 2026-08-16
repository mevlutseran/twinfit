import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  static TextStyle displayLarge(BuildContext context, {bool isDark = true}) =>
      GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.8,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
      );

  static TextStyle displayMedium(BuildContext context, {bool isDark = true}) =>
      GoogleFonts.inter(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.6,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
      );

  static TextStyle titleLarge(BuildContext context, {bool isDark = true}) =>
      GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
      );

  static TextStyle titleMedium(BuildContext context, {bool isDark = true}) =>
      GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
      );

  static TextStyle bodyLarge(BuildContext context, {bool isDark = true}) =>
      GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
      );

  static TextStyle bodyMedium(BuildContext context, {bool isDark = true}) =>
      GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
      );

  static TextStyle labelLarge(BuildContext context, {bool isDark = true}) =>
      GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
      );

  static TextStyle labelSmall(BuildContext context, {bool isDark = true}) =>
      GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
      );

  // High-Performance Monospace / Numeric (For Rest Timer, Reps, Weight)
  static TextStyle metricDisplay({
    double fontSize = 36,
    FontWeight fontWeight = FontWeight.w800,
    Color color = AppColors.primary,
  }) =>
      GoogleFonts.jetBrainsMono(
        fontSize: fontSize,
        fontWeight: fontWeight,
        letterSpacing: -1.0,
        color: color,
      );
}
