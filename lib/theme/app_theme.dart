import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ─────────────────────────────────────────────
///  SnackSpotter — Design System & App Theme
/// ─────────────────────────────────────────────

class AppTheme {
  AppTheme._();

  // ── Brand Colors ──────────────────────────
  static const Color primaryDark = Color(0xFF0D0D1A);
  static const Color surfaceDark = Color(0xFF141428);
  static const Color cardDark = Color(0xFF1C1C3A);

  static const Color accentOrange = Color(0xFFFF6B35);
  static const Color accentPink = Color(0xFFFF2E93);
  static const Color accentCyan = Color(0xFF00E5FF);
  static const Color accentPurple = Color(0xFF7C4DFF);
  static const Color accentGreen = Color(0xFF00E676);

  static const Color textPrimary = Color(0xFFF5F5F5);
  static const Color textSecondary = Color(0xFFB0B0CC);
  static const Color textMuted = Color(0xFF6B6B8A);

  // ── Gradients ─────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentOrange, accentPink],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0D0D1A),
      Color(0xFF141428),
      Color(0xFF1A1A3E),
    ],
  );

  static const LinearGradient cyanPurpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentCyan, accentPurple],
  );

  static const LinearGradient cardGlowGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x30FF6B35),
      Color(0x10FF2E93),
    ],
  );

  // ── Class Colors (per detection class) ────
  static const Map<String, Color> classColors = {
    'bhujiya': accentOrange,
    'dorito': accentCyan,
    'maggie_masala': accentPink,
  };

  static Color getClassColor(String className) {
    return classColors[className.toLowerCase()] ?? accentPurple;
  }

  // ── Text Styles ───────────────────────────
  static TextStyle get displayLarge => GoogleFonts.outfit(
        fontSize: 48,
        fontWeight: FontWeight.w800,
        color: textPrimary,
        height: 1.1,
      );

  static TextStyle get displayMedium => GoogleFonts.outfit(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        height: 1.2,
      );

  static TextStyle get headlineLarge => GoogleFonts.outfit(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      );

  static TextStyle get headlineMedium => GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      );

  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        height: 1.6,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textSecondary,
      );

  static TextStyle get labelLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0.5,
      );

  static TextStyle get labelSmall => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: textMuted,
        letterSpacing: 1.2,
      );

  static TextStyle get statNumber => GoogleFonts.outfit(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: textPrimary,
      );

  // ── Glassmorphism Decoration ──────────────
  static BoxDecoration glassDecoration({
    double borderRadius = 20,
    Color? borderColor,
    double opacity = 0.08,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      color: Colors.white.withValues(alpha: opacity),
      border: Border.all(
        color: borderColor ?? Colors.white.withValues(alpha: 0.12),
        width: 1,
      ),
    );
  }

  // ── Theme Data ────────────────────────────
  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: primaryDark,
        colorScheme: const ColorScheme.dark(
          primary: accentOrange,
          secondary: accentCyan,
          surface: surfaceDark,
          error: Color(0xFFFF5252),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: headlineMedium,
          iconTheme: const IconThemeData(color: textPrimary),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: accentOrange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: labelLarge,
            elevation: 0,
          ),
        ),
      );
}
