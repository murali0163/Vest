import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens for Vest.
/// Palette pulled from a fabric-swatch story: stone canvas, ink text,
/// blush / moss / mustard as the three "thread" accents.
class VestColors {
  static const canvas = Color(0xFFEEECE5);
  static const canvasAlt = Color(0xFFE5E1D8);
  static const ink = Color(0xFF25282C);
  static const inkFaint = Color(0xFF62615D);
  static const blush = Color(0xFFC67F88);
  static const moss = Color(0xFF748168);
  static const mustard = Color(0xFFD7AA60);
  static const line = Color(0xFFD5D0C6);
  static const card = Color(0xFFF8F6F1);
  static const selectedSurface = Color(0xFFE5E8DF);
  static const disabled = Color(0xFFE0DDD5);
}

class VestType {
  static TextTheme textTheme(Brightness brightness) {
    final base = brightness == Brightness.dark
        ? Typography.whiteMountainView
        : Typography.blackMountainView;
    return base.copyWith(
      displayLarge: GoogleFonts.fraunces(
        fontSize: 40,
        fontWeight: FontWeight.w600,
        height: 1.05,
        letterSpacing: -0.5,
        color: VestColors.ink,
      ),
      displayMedium: GoogleFonts.fraunces(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.1,
        color: VestColors.ink,
      ),
      headlineSmall: GoogleFonts.fraunces(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: VestColors.ink,
      ),
      titleMedium: GoogleFonts.workSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: VestColors.ink,
      ),
      bodyLarge: GoogleFonts.workSans(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: VestColors.ink,
      ),
      bodyMedium: GoogleFonts.workSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: VestColors.inkFaint,
      ),
      labelLarge: GoogleFonts.ibmPlexMono(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
        color: VestColors.ink,
      ),
      labelSmall: GoogleFonts.ibmPlexMono(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.3,
        color: VestColors.inkFaint,
      ),
    );
  }
}

ThemeData buildVestTheme() {
  final textTheme = VestType.textTheme(Brightness.light);
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: VestColors.canvas,
    colorScheme: ColorScheme.fromSeed(
      seedColor: VestColors.blush,
      brightness: Brightness.light,
      primary: VestColors.ink,
      secondary: VestColors.blush,
      surface: VestColors.card,
      onSurface: VestColors.ink,
      onPrimary: VestColors.card,
    ),
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: VestColors.canvas,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      foregroundColor: VestColors.ink,
      titleTextStyle: textTheme.titleMedium,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: VestColors.ink,
        foregroundColor: VestColors.canvas,
        disabledBackgroundColor: VestColors.disabled,
        disabledForegroundColor: VestColors.inkFaint,
        minimumSize: const Size.fromHeight(54),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: GoogleFonts.workSans(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        elevation: 0,
      ),
    ),
    dividerTheme: const DividerThemeData(color: VestColors.line, thickness: 1),
  );
}
