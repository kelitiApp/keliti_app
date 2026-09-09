import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'app_button.dart';

/// Confirmation bottom sheet used for destructive/important actions
/// (stop medication, cancel appointment, logout, delete account, leave
/// community, remove family member ...).
///
/// Returns the id of the option the user picked, or null if dismissed.
Future<String?> showAppConfirmSheet(
  BuildContext context, {
  required IconData icon,
  required String title,
  required String description,
  required String confirmLabel,
  String cancelLabel = 'تراجع',
  bool destructive = true,
  List<(String id, String label)> extraActions = const [],
  Color? iconBackground,
  Color? iconColor,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pageHorizontal,
            AppSpacing.md,
            AppSpacing.pageHorizontal,
            AppSpacing.xl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderStrong,
                  borderRadius: AppRadius.radiusPill,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: iconBackground ?? (destructive ? AppColors.errorLight : AppColors.primaryLight),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? (destructive ? AppColors.error : AppColors.primary),
                  size: 28,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(title, textAlign: TextAlign.center, style: AppTextStyles.titleLarge),
              const SizedBox(height: AppSpacing.xs),
              Text(
                description,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: confirmLabel,
                variant: destructive ? AppButtonVariant.destructive : AppButtonVariant.primary,
                onPressed: () => Navigator.of(sheetContext).pop('confirm'),
              ),
              for (final action in extraActions) ...[
                const SizedBox(height: AppSpacing.sm),
                AppButton(
                  label: action.$2,
                  variant: AppButtonVariant.outlined,
                  onPressed: () => Navigator.of(sheetContext).pop(action.$1),
                ),
              ],
              const SizedBox(height: AppSpacing.sm),
              AppButton(
                label: cancelLabel,
                variant: AppButtonVariant.text,
                onPressed: () => Navigator.of(sheetContext).pop(),
              ),
            ],
          ),
        ),
      );
    },
  );
}
