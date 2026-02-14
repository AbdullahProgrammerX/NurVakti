import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Nur Vakti Typography
class NurTextStyles {
  NurTextStyles._();

  // ─── Display ───
  static TextStyle displayLarge({Color? color}) => GoogleFonts.inter(
    fontSize: 57,
    fontWeight: FontWeight.w700,
    color: color,
    letterSpacing: -0.25,
  );

  static TextStyle displayMedium({Color? color}) => GoogleFonts.inter(
    fontSize: 45,
    fontWeight: FontWeight.w600,
    color: color,
  );

  // ─── Tarih (Takvim Yaprağı) ───
  static TextStyle dateDay({Color? color}) => GoogleFonts.inter(
    fontSize: 72,
    fontWeight: FontWeight.w800,
    color: color,
    height: 1.0,
  );

  static TextStyle dateMonth({Color? color}) => GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: color,
    letterSpacing: 2.0,
  );

  static TextStyle dateYear({Color? color}) => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: color,
  );

  // ─── Hicri Tarih ───
  static TextStyle hijriDate({Color? color}) => GoogleFonts.amiri(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: color,
  );

  // ─── Arapça Metin ───
  static TextStyle arabicText({Color? color}) => GoogleFonts.amiri(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: color,
    height: 2.0,
  );

  static TextStyle arabicLarge({Color? color}) => GoogleFonts.amiri(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: color,
    height: 1.8,
  );

  // ─── Başlıklar ───
  static TextStyle headlineLarge({Color? color}) => GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: color,
  );

  static TextStyle headlineMedium({Color? color}) => GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: color,
  );

  static TextStyle headlineSmall({Color? color}) => GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: color,
  );

  // ─── Gövde Metin ───
  static TextStyle bodyLarge({Color? color}) => GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: color,
    height: 1.6,
  );

  static TextStyle bodyMedium({Color? color}) => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: color,
    height: 1.5,
  );

  static TextStyle bodySmall({Color? color}) => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: color,
    height: 1.4,
  );

  // ─── Label ───
  static TextStyle labelLarge({Color? color}) => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: color,
    letterSpacing: 0.5,
  );

  static TextStyle labelMedium({Color? color}) => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: color,
    letterSpacing: 0.5,
  );

  static TextStyle labelSmall({Color? color}) => GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: color,
    letterSpacing: 0.5,
  );

  // ─── Namaz Vakti ───
  static TextStyle prayerTime({Color? color}) => GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: color,
    fontFeatures: [const FontFeature.tabularFigures()],
  );

  static TextStyle prayerCountdown({Color? color}) => GoogleFonts.inter(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    color: color,
    fontFeatures: [const FontFeature.tabularFigures()],
  );

  // ─── Zikirmatik ───
  static TextStyle dhikrCount({Color? color}) => GoogleFonts.inter(
    fontSize: 64,
    fontWeight: FontWeight.w800,
    color: color,
    fontFeatures: [const FontFeature.tabularFigures()],
  );
}
