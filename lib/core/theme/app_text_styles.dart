import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // ── Display (Bebas-style impact via Oswald) ────────────────────────────────
  static TextStyle displayLarge({Color? color}) => GoogleFonts.oswald(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.textPrimary,
        letterSpacing: 1.5,
        height: 1.0,
      );

  static TextStyle displayMedium({Color? color}) => GoogleFonts.oswald(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.textPrimary,
        letterSpacing: 1.0,
        height: 1.05,
      );

  static TextStyle displaySmall({Color? color}) => GoogleFonts.oswald(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textPrimary,
        letterSpacing: 0.8,
        height: 1.1,
      );

  // ── Titles (Inter bold) ───────────────────────────────────────────────────
  static TextStyle titleLarge({Color? color}) => GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: color ?? AppColors.textPrimary,
        letterSpacing: -0.3,
        height: 1.2,
      );

  static TextStyle titleMedium({Color? color}) => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.textPrimary,
        letterSpacing: -0.2,
        height: 1.3,
      );

  static TextStyle titleSmall({Color? color}) => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.textPrimary,
        letterSpacing: -0.1,
        height: 1.3,
      );

  // ── Body ─────────────────────────────────────────────────────────────────
  static TextStyle bodyLarge({Color? color}) => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.textPrimary,
        height: 1.6,
      );

  static TextStyle bodyMedium({Color? color}) => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.textSecondary,
        height: 1.55,
      );

  static TextStyle bodySmall({Color? color}) => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.textHint,
        height: 1.5,
      );

  // ── Labels ────────────────────────────────────────────────────────────────
  static TextStyle labelLarge({Color? color}) => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.textPrimary,
        letterSpacing: 0.3,
        height: 1.4,
      );

  static TextStyle labelSmall({Color? color}) => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.textSecondary,
        letterSpacing: 0.8,
        height: 1.4,
      );

  // ── Section headers (drama style) ─────────────────────────────────────────
  static TextStyle sectionTitle({Color? color}) => GoogleFonts.oswald(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textPrimary,
        letterSpacing: 1.2,
        height: 1.1,
      );

  // ── Reader text ───────────────────────────────────────────────────────────
  static TextStyle readerBody({
    required double fontSize,
    required Color color,
    double? height,
  }) =>
      GoogleFonts.crimsonText(
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
        color: color,
        height: height ?? 1.9,
        letterSpacing: 0.15,
      );

  static TextStyle readerChapterTitle({
    required double fontSize,
    required Color color,
  }) =>
      GoogleFonts.oswald(
        fontSize: fontSize + 6,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.1,
        letterSpacing: 2.0,
      );
}
