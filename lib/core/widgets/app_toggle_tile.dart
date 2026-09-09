import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Settings row with a title (+ optional description) and a trailing
/// switch. Used across notification/reminder/community settings pages.
class AppToggleTile extends StatelessWidget {
  const AppToggleTile({
    super.key,
    required this.title,
    this.description,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String? description;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Switch(value: value, onChanged: onChanged),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(title, textAlign: TextAlign.right, style: AppTextStyles.titleSmall),
              if (description != null) ...[
                const SizedBox(height: 2),
                Text(
                  description!,
                  textAlign: TextAlign.right,
                  style: AppTextStyles.caption,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
