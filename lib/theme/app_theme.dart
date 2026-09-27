// ==============================================================================
// One Numan Public School (ONPS) — Android ERP Mobile Application
// Design System: Espresso Heritage Academic
// Source: stitch_onps_android_erp_ui 8/espresso_heritage_academic/DESIGN.md
// ==============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AcademicColors {
  // HTML Timetable Preview Colors
  static const Color ink = Color(0xFF3D2A22);
  static const Color muted = Color(0xFF8B7D77);
  static const Color accentNew = Color(0xFF9A5D2F);
  static const Color accentSoft = Color(0xFFF3E8DF);
  static const Color cream = Color(0xFFFBFAF8);
  static const Color line = Color(0xFFE6DFDB);
  static const Color card = Color(0xFFFFFFFF);
  static const Color green = Color(0xFF47745F);
  static const Color greenSoft = Color(0xFFE7F1EC);
  static const Color blue = Color(0xFF36758C);
  static const Color blueSoft = Color(0xFFE3F3F7);
  static const Color appBackground = Color(0xFFE9E5E1);

  // Brand Surfaces & Chrome
  static const Color primary = Color(0xFF5C4033);          // Primary Espresso
  static const Color primaryDark = Color(0xFF3E2A22);      // Deep Espresso
  static const Color accent = Color(0xFFC58B5A);           // Tertiary Caramel
  static const Color caramel = accent;
  static const Color caramelDark = Color(0xFF9E6335);
  static const Color caramelLight = Color(0xFFDFC0A4);
  static const Color secondary = Color(0xFF765844);        // Secondary Mocha
  static const Color canvas = Color(0xFFFBF9F7);           // Canvas Cream
  static const Color surface = Color(0xFFFFFFFF);          // Surface Ivory
  static const Color border = Color(0xFFE6DFDC);           // Border Beige

  // Text Contrast Hierarchy
  static const Color textPrimary = Color(0xFF2B221E);      // Text Cocoa
  static const Color textSecondary = Color(0xFF817470);    // Text Taupe

  // Functional Semantics
  static const Color success = Color(0xFF2E7D4F);
  static const Color successContainer = Color(0xFFE8F5E9);

  static const Color warning = Color(0xFFA66A00);
  static const Color warningContainer = Color(0xFFFFF8E1);

  static const Color danger = Color(0xFFB5443C);
  static const Color dangerContainer = Color(0xFFFFEBEE);
  static const Color error = danger;

  static const Color info = Color(0xFF35758A);
  static const Color infoContainer = Color(0xFFE0F7FA);

  // Soft Inset Shadow
  static List<BoxShadow> get cardShadow => [
    const BoxShadow(
      color: Color.fromRGBO(92, 64, 51, 0.05),
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get elevatedShadow => [
    const BoxShadow(
      color: Color.fromRGBO(92, 64, 51, 0.08),
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
  ];
}

class AcademicTheme {
  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AcademicColors.canvas,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AcademicColors.primary,
        onPrimary: Colors.white,
        primaryContainer: AcademicColors.primaryDark,
        onPrimaryContainer: Colors.white,
        secondary: AcademicColors.secondary,
        onSecondary: Colors.white,
        secondaryContainer: AcademicColors.accent,
        onSecondaryContainer: Colors.white,
        surface: AcademicColors.surface,
        onSurface: AcademicColors.textPrimary,
        error: AcademicColors.danger,
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AcademicColors.canvas,
        foregroundColor: AcademicColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.newsreader(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AcademicColors.textPrimary,
        ),
        iconTheme: const IconThemeData(color: AcademicColors.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: AcademicColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AcademicColors.border, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AcademicColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        hintStyle: GoogleFonts.manrope(
          fontSize: 14,
          color: AcademicColors.textSecondary,
        ),
        labelStyle: GoogleFonts.manrope(
          fontSize: 14,
          color: AcademicColors.textSecondary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AcademicColors.border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AcademicColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AcademicColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AcademicColors.danger, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AcademicColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 44),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AcademicColors.primary,
          backgroundColor: AcademicColors.surface,
          minimumSize: const Size(0, 44),
          side: const BorderSide(color: AcademicColors.border, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.newsreader(fontSize: 32, fontWeight: FontWeight.normal, color: AcademicColors.textPrimary),
        headlineLarge: GoogleFonts.newsreader(fontSize: 24, fontWeight: FontWeight.w600, color: AcademicColors.textPrimary),
        headlineMedium: GoogleFonts.newsreader(fontSize: 20, fontWeight: FontWeight.bold, color: AcademicColors.textPrimary),
        headlineSmall: GoogleFonts.newsreader(fontSize: 18, fontWeight: FontWeight.w600, color: AcademicColors.textPrimary),
        titleLarge: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.bold, color: AcademicColors.textPrimary),
        titleMedium: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.bold, color: AcademicColors.textPrimary),
        bodyLarge: GoogleFonts.manrope(fontSize: 15, color: AcademicColors.textPrimary),
        bodyMedium: GoogleFonts.manrope(fontSize: 13.5, color: AcademicColors.textPrimary),
        bodySmall: GoogleFonts.manrope(fontSize: 12, color: AcademicColors.textSecondary),
        labelLarge: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w600, color: AcademicColors.textPrimary),
        labelSmall: GoogleFonts.manrope(fontSize: 10.5, fontWeight: FontWeight.w700, color: AcademicColors.textSecondary),
      ),
    );
  }
}
