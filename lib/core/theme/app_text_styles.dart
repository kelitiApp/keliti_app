import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Centralized typography for the app. Built on the Cairo family which
/// matches the geometric, rounded Arabic/Latin sans used across the designs.
///
/// Cairo is bundled locally (see pubspec.yaml `fonts:`) rather than fetched
/// at runtime via google_fonts, so Arabic text renders correctly offline
/// and on first launch without a network round-trip.
class AppTextStyles {
  const AppTextStyles._();

  static const String fontFamily = 'Cairo';

  static TextStyle _base({
    required double fontSize,
    required FontWeight fontWeight,
    Color color = AppColors.textPrimary,
    double? height,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  /// Large page headings (rare — e.g. splash / success titles).
  static TextStyle get displaySmall =>
      _base(fontSize: 24, fontWeight: FontWeight.w700, height: 1.3);

  /// Page titles in headers ("أدويتي", "المواعيد" ...).
  static TextStyle get headlineSmall =>
      _base(fontSize: 20, fontWeight: FontWeight.w700, height: 1.3);

  /// Section titles within a page ("الجرعة القادمة").
  static TextStyle get titleLarge =>
      _base(fontSize: 18, fontWeight: FontWeight.w700, height: 1.3);

  static TextStyle get titleMedium =>
      _base(fontSize: 16, fontWeight: FontWeight.w600, height: 1.35);

  static TextStyle get titleSmall =>
      _base(fontSize: 14, fontWeight: FontWeight.w600, height: 1.35);

  /// Body text.
  static TextStyle get bodyLarge =>
      _base(fontSize: 15, fontWeight: FontWeight.w500, height: 1.5);

  static TextStyle get bodyMedium =>
      _base(fontSize: 14, fontWeight: FontWeight.w400, height: 1.5);

  static TextStyle get bodySmall => _base(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textSecondary,
  );

  /// Captions / meta text (timestamps, helper text).
  static TextStyle get caption => _base(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  static TextStyle get overline => _base(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.textTertiary,
  );

  /// Buttons.
  static TextStyle get button =>
      _base(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textOnPrimary);

  static TextStyle get buttonSmall =>
      _base(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textOnPrimary);

  /// Big numeric stats ("3", "72.5", "120/80").
  static TextStyle get statValue =>
      _base(fontSize: 26, fontWeight: FontWeight.w700, height: 1.1);

  static TextStyle get statValueLarge =>
      _base(fontSize: 34, fontWeight: FontWeight.w700, height: 1.1);
}
