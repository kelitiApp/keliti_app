import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'app_button.dart';

enum ResultTone { success, warning, error, info }

/// Full-page result view: icon + title + description + optional summary
/// card + one or two action buttons. Used for every "تم بنجاح" /
/// "تنبيه" / status confirmation screen across the app.
class AppResultView extends StatelessWidget {
  const AppResultView({
    super.key,
    required this.title,
    this.description,
    this.tone = ResultTone.success,
    this.icon,
    this.summary,
    this.primaryLabel,
    this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
    this.banner,
  });

  final String title;
  final String? description;
  final ResultTone tone;
  final IconData? icon;
  final Widget? summary;
  final String? primaryLabel;
  final VoidCallback? onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  /// Optional small warning/info banner shown under the description.
  final String? banner;

  (Color, Color, IconData) get _visual => switch (tone) {
        ResultTone.success => (AppColors.primaryLight, AppColors.primary, Icons.check_rounded),
        ResultTone.warning => (AppColors.warningLight, AppColors.accentAmberDeep, Icons.warning_amber_rounded),
        ResultTone.error => (AppColors.errorLight, AppColors.error, Icons.close_rounded),
        ResultTone.info => (AppColors.infoLight, AppColors.info, Icons.info_outline_rounded),
      };

  @override
  Widget build(BuildContext context) {
    final (bg, fg, defaultIcon) = _visual;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
                  child: Icon(icon ?? defaultIcon, size: 38, color: fg),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(title, textAlign: TextAlign.center, style: AppTextStyles.titleLarge),
                if (description != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    description!,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                ],
                if (summary != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  summary!,
                ],
                if (banner != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.warningLight,
                      borderRadius: AppRadius.radiusSm,
                    ),
                    child: Text(
                      banner!,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.accentAmberDeep),
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.xl),
                if (primaryLabel != null)
                  AppButton(
                    label: primaryLabel!,
                    onPressed: onPrimary,
                    variant: tone == ResultTone.error ? AppButtonVariant.destructive : AppButtonVariant.primary,
                  ),
                if (secondaryLabel != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  AppButton(label: secondaryLabel!, onPressed: onSecondary, variant: AppButtonVariant.outlined),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
