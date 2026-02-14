import 'package:flutter/material.dart';

/// Nur Vakti Renk Paleti
/// İslami estetik: yeşil, krem, altın tonları
class NurColors {
  NurColors._();

  // ─── Açık Tema ───
  static const Color lightBackground = Color(0xFFFFF8F0);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightPrimary = Color(0xFF2D6A4F);
  static const Color lightPrimaryVariant = Color(0xFF1B4332);
  static const Color lightSecondary = Color(0xFFB7935F);
  static const Color lightSecondaryVariant = Color(0xFF9A7B4F);
  static const Color lightAccent = Color(0xFFD4A574);
  static const Color lightText = Color(0xFF2D2D2D);
  static const Color lightTextSecondary = Color(0xFF6B6B6B);
  static const Color lightDivider = Color(0xFFE8E0D8);
  static const Color lightIcon = Color(0xFF4A4A4A);

  // ─── Koyu Tema ───
  static const Color darkBackground = Color(0xFF0F1A2E);
  static const Color darkSurface = Color(0xFF16213E);
  static const Color darkCard = Color(0xFF1A2744);
  static const Color darkPrimary = Color(0xFF52B788);
  static const Color darkPrimaryVariant = Color(0xFF40916C);
  static const Color darkSecondary = Color(0xFFD4A574);
  static const Color darkSecondaryVariant = Color(0xFFB7935F);
  static const Color darkAccent = Color(0xFFE8C99B);
  static const Color darkText = Color(0xFFE8E8E8);
  static const Color darkTextSecondary = Color(0xFFA0A0A0);
  static const Color darkDivider = Color(0xFF2A3A5C);
  static const Color darkIcon = Color(0xFFB0B0B0);

  // ─── Ortak ───
  static const Color gold = Color(0xFFD4A574);
  static const Color goldShimmer = Color(0xFFE8C99B);
  static const Color emerald = Color(0xFF2D6A4F);
  static const Color cream = Color(0xFFFFF8F0);
  static const Color error = Color(0xFFCF6679);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);

  // ─── Gradient'ler ───
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2D6A4F), Color(0xFF40916C)],
  );

  static const LinearGradient darkPrimaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A2744), Color(0xFF16213E)],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFB7935F), Color(0xFFD4A574), Color(0xFFE8C99B)],
  );

  static const LinearGradient calendarHeaderGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF2D6A4F), Color(0xFF1B4332)],
  );

  static const LinearGradient darkCalendarHeaderGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1A2744), Color(0xFF0F1A2E)],
  );
}
