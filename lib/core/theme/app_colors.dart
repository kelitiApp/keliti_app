import 'package:flutter/material.dart';

/// Centralized color palette for the Kelayti (كليتي) design system.
///
/// Values are extracted/approximated from the provided UI designs and
/// reused consistently across the app instead of being redefined per screen.
class AppColors {
  const AppColors._();

  // Brand — teal/green family used for primary actions, active states,
  // dialysis/health related accents.
  static const Color primary = Color(0xFF2F6F6B);
  static const Color primaryDark = Color(0xFF1E4A47);
  static const Color primaryDarker = Color(0xFF15302E);
  static const Color primaryLight = Color(0xFFE7F2F1);
  static const Color primarySurface = Color(0xFFF3F8F7);

  // Status colors.
  static const Color error = Color(0xFFE2574C);
  static const Color errorLight = Color(0xFFFCEAE8);
  static const Color warning = Color(0xFFD9A441);
  static const Color warningLight = Color(0xFFFBF1DC);
  static const Color success = primary;
  static const Color successLight = primaryLight;
  static const Color info = Color(0xFF5B8DEF);
  static const Color infoLight = Color(0xFFE9F0FD);

  // Accent colors used in community & charts.
  static const Color accentPurple = Color(0xFF8B7FD1);
  static const Color accentPurpleLight = Color(0xFFEFEDFA);
  static const Color accentPink = Color(0xFFF2A6C1);
  static const Color accentPinkLight = Color(0xFFFCEDF3);
  static const Color accentBlue = Color(0xFF6FA8DC);
  static const Color accentAmberDeep = Color(0xFFE8A33D);

  // Neutrals.
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFF5F6F6);
  static const Color surfaceMuted = Color(0xFFF0F1F1);
  static const Color border = Color(0xFFE6E8E8);
  static const Color borderStrong = Color(0xFFD8DBDA);
  static const Color divider = Color(0xFFEFF0F0);

  static const Color textPrimary = Color(0xFF1B1F1E);
  static const Color textSecondary = Color(0xFF6B7573);
  static const Color textTertiary = Color(0xFF9AA3A1);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textDisabled = Color(0xFFB7BDBB);

  static const Color overlay = Color(0x99000000);
  static const Color shadow = Color(0x1A000000);
}
