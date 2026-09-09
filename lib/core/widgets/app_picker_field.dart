import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Field styled like a text input that opens a picker (date/time/selection
/// sheet) when tapped, without needing a TextEditingController. Reused for
/// date pickers, dropdown-like selections, and "choose from list" fields.
class AppPickerField extends StatelessWidget {
  const AppPickerField({
    super.key,
    this.label,
    required this.hint,
    this.value,
    required this.onTap,
    this.icon = Icons.keyboard_arrow_down_rounded,
    this.enabled = true,
  });

  final String? label;
  final String hint;
  final String? value;
  final VoidCallback? onTap;
  final IconData icon;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: AppTextStyles.titleSmall),
          const SizedBox(height: AppSpacing.xs),
        ],
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: AppRadius.radiusMd,
            onTap: enabled ? onTap : null,
            child: Container(
              height: AppDimensions.inputHeight,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius: AppRadius.radiusMd,
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Icon(icon, color: AppColors.textTertiary, size: AppDimensions.iconSm),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      hasValue ? value! : hint,
                      textAlign: TextAlign.right,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: hasValue ? AppColors.textPrimary : AppColors.textTertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
