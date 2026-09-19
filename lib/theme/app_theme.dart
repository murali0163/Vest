import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens for Vest.
/// Palette pulled from a fabric-swatch story: stone canvas, ink text,
/// blush / moss / mustard as the three "thread" accents.
class VestColors {
  static const canvas = Color(0xFFEDEAE3);
  static const canvasAlt = Color(0xFFE3DFD5);
  static const ink = Color(0xFF23262B);
  static const inkFaint = Color(0xFF6B6C6E);
  static const blush = Color(0xFFC97B84); // primary accent
  static const moss = Color(0xFF6B7A5E); // occasion / secondary
  static const mustard = Color(0xFFD4A85A); // budget / highlight
  static const line = Color(0xFFCFC9BC); // hairline / stitch color
  static const card = Color(0xFFF6F4EF);
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
        fontSize: 13.5,
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
        fontSize: 10.5,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.6,
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
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
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