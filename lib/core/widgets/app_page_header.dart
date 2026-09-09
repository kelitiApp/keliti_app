import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'app_circle_icon_button.dart';

/// Header used on form / detail / onboarding pages: a circular back button
/// aligned to the top corner with the title (and optional subtitle) below
/// it, right-aligned. Matches the recurring header pattern across the
/// design set (e.g. "إضافة دواء", "بطاقتي الطبية", onboarding steps).
class AppPageHeader extends StatelessWidget {
  const AppPageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
    this.showBack = true,
    this.trailing,
    this.stepProgress,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final bool showBack;
  final Widget? trailing;

  /// Optional 0..1 list of step-dot fill states for onboarding flows.
  final List<bool>? stepProgress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (trailing != null) trailing! else const SizedBox(width: AppDimensions.circleButtonSize),
            const Spacer(),
            if (showBack)
              AppCircleIconButton(
                icon: Icons.chevron_right,
                onPressed: onBack ?? () => Navigator.of(context).maybePop(),
              ),
          ],
        ),
        if (stepProgress != null) ...[
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              for (int i = 0; i < stepProgress!.length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.xxs),
                Expanded(
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: stepProgress![i] ? AppColors.primary : AppColors.surfaceMuted,
                      borderRadius: AppRadius.radiusPill,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        Text(title, textAlign: TextAlign.right, style: AppTextStyles.headlineSmall),
        if (subtitle != null) ...[
          const SizedBox(height: AppSpacing.xxs),
          Text(
            subtitle!,
            textAlign: TextAlign.right,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ],
    );
  }
}
