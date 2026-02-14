import 'package:flutter/material.dart';
import 'colors.dart';
import 'text_styles.dart';

/// Nur Vakti Tema Yönetimi
class NurTheme {
  NurTheme._();

  // ─── Açık Tema ───
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: NurColors.lightBackground,
    colorScheme: const ColorScheme.light(
      primary: NurColors.lightPrimary,
      primaryContainer: NurColors.lightPrimaryVariant,
      secondary: NurColors.lightSecondary,
      secondaryContainer: NurColors.lightSecondaryVariant,
      surface: NurColors.lightSurface,
      error: NurColors.error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: NurColors.lightText,
      onError: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: NurColors.lightPrimary,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: NurTextStyles.headlineSmall(color: Colors.white),
    ),
    cardTheme: CardThemeData(
      color: NurColors.lightCard,
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: NurColors.lightPrimary,
      unselectedItemColor: NurColors.lightTextSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontSize: 11),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: NurColors.lightPrimary,
      foregroundColor: Colors.white,
    ),
    dividerTheme: const DividerThemeData(
      color: NurColors.lightDivider,
      thickness: 1,
    ),
    iconTheme: const IconThemeData(
      color: NurColors.lightIcon,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: NurColors.lightPrimary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: NurTextStyles.labelLarge(),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: NurColors.lightBackground,
      selectedColor: NurColors.lightPrimary.withValues(alpha: 0.15),
      labelStyle: NurTextStyles.labelMedium(color: NurColors.lightText),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: NurColors.lightCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );

  // ─── Koyu Tema ───
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: NurColors.darkBackground,
    colorScheme: const ColorScheme.dark(
      primary: NurColors.darkPrimary,
      primaryContainer: NurColors.darkPrimaryVariant,
      secondary: NurColors.darkSecondary,
      secondaryContainer: NurColors.darkSecondaryVariant,
      surface: NurColors.darkSurface,
      error: NurColors.error,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: NurColors.darkText,
      onError: Colors.black,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: NurColors.darkSurface,
      foregroundColor: NurColors.darkText,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: NurTextStyles.headlineSmall(color: NurColors.darkText),
    ),
    cardTheme: CardThemeData(
      color: NurColors.darkCard,
      elevation: 4,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF16213E),
      selectedItemColor: NurColors.darkPrimary,
      unselectedItemColor: NurColors.darkTextSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontSize: 11),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: NurColors.darkPrimary,
      foregroundColor: Colors.black,
    ),
    dividerTheme: const DividerThemeData(
      color: NurColors.darkDivider,
      thickness: 1,
    ),
    iconTheme: const IconThemeData(
      color: NurColors.darkIcon,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: NurColors.darkPrimary,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: NurTextStyles.labelLarge(),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: NurColors.darkSurface,
      selectedColor: NurColors.darkPrimary.withValues(alpha: 0.2),
      labelStyle: NurTextStyles.labelMedium(color: NurColors.darkText),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: NurColors.darkCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}
