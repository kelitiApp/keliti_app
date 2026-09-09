import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Pill-shaped selectable option used for relation type, gender, symptoms,
/// severity, category filters, etc.
class SelectableChip extends StatelessWidget {
  const SelectableChip({
    super.key,
    required this.label,
    required this.selected,
    this.onTap,
    this.icon,
    this.checkOnSelect = false,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool checkOnSelect;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : AppColors.surfaceAlt,
      borderRadius: AppRadius.radiusPill,
      child: InkWell(
        borderRadius: AppRadius.radiusPill,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: AppRadius.radiusPill,
            border: Border.all(color: selected ? AppColors.primary : AppColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: AppDimensions.iconSm, color: selected ? Colors.white : AppColors.textSecondary),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: selected ? Colors.white : AppColors.textPrimary,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
              if (checkOnSelect && selected) ...[
                const SizedBox(width: 6),
                const Icon(Icons.check_circle, size: 16, color: Colors.white),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
