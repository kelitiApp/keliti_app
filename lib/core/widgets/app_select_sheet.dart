import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Generic bottom sheet list picker (gender, blood type, dialysis type,
/// relation, severity ...). Returns the selected value or null if dismissed.
Future<T?> showAppSelectSheet<T>(
  BuildContext context, {
  required String title,
  required List<T> options,
  required String Function(T) labelBuilder,
  T? selected,
}) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: AppColors.borderStrong, borderRadius: AppRadius.radiusPill),
              ),
              const SizedBox(height: AppSpacing.md),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
                child: Text(title, style: AppTextStyles.titleLarge, textAlign: TextAlign.right),
              ),
              const SizedBox(height: AppSpacing.sm),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
                  itemCount: options.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final option = options[index];
                    final isSelected = option == selected;
                    return ListTile(
                      onTap: () => Navigator.of(sheetContext).pop(option),
                      title: Text(
                        labelBuilder(option),
                        textAlign: TextAlign.right,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: isSelected ? AppColors.primary : AppColors.textPrimary,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                      trailing: isSelected ? const Icon(Icons.check_circle, color: AppColors.primary) : null,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
