import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/food_item.dart';

class FoodAlternativesPage extends StatelessWidget {
  const FoodAlternativesPage({super.key, required this.foodName});

  final String foodName;

  @override
  Widget build(BuildContext context) {
    final alternatives = FoodItem.safeAlternatives[foodName] ?? const [];

    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppPageHeader(title: 'بدائل آمنة لـ"$foodName"'),
          const SizedBox(height: AppSpacing.lg),
          for (final alt in alternatives) ...[
            AppCard(
              child: Row(
                children: [
                  const StatusChip(label: 'آمن', tone: StatusTone.primary),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(alt.$1, style: AppTextStyles.titleSmall),
                      Text('بوتاسيوم: ${alt.$2}', style: AppTextStyles.caption),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          const SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: AppRadius.radiusMd),
            child: Text(
              'هاي البدائل بتحدث تلقائياً كل ما تتغير نتيجة فحوصاتك',
              textAlign: TextAlign.right,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryDark),
            ),
          ),
        ],
      ),
    );
  }
}
