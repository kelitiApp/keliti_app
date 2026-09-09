import 'package:flutter/material.dart';

import '../theme/theme.dart';

enum StatusTone { primary, warning, error, neutral, info, purple }

/// Small colored pill label used for statuses ("نشط", "متوقف", "مجدول",
/// "متأخرة", "تم التواصل" ...).
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.label, this.tone = StatusTone.primary, this.icon});

  final String label;
  final StatusTone tone;
  final IconData? icon;

  (Color, Color) get _colors => switch (tone) {
        StatusTone.primary => (AppColors.primaryLight, AppColors.primary),
        StatusTone.warning => (AppColors.warningLight, AppColors.accentAmberDeep),
        StatusTone.error => (AppColors.errorLight, AppColors.error),
        StatusTone.neutral => (AppColors.surfaceMuted, AppColors.textSecondary),
        StatusTone.info => (AppColors.infoLight, AppColors.info),
        StatusTone.purple => (AppColors.accentPurpleLight, AppColors.accentPurple),
      };

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = _colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: AppRadius.radiusPill),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: fg),
            const SizedBox(width: 4),
          ],
          Text(label, style: AppTextStyles.caption.copyWith(color: fg, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
