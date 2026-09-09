import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/food_item.dart';
import '../cubit/food_history_cubit.dart';
import 'food_alternatives_page.dart';

(Color, Color, IconData) _verdictVisual(FoodVerdict v) => switch (v) {
      FoodVerdict.safe => (AppColors.primaryLight, AppColors.primary, Icons.check_circle_rounded),
      FoodVerdict.caution => (AppColors.warningLight, AppColors.accentAmberDeep, Icons.warning_amber_rounded),
      FoodVerdict.avoid => (AppColors.errorLight, AppColors.error, Icons.block_rounded),
    };

class FoodResultPage extends StatefulWidget {
  const FoodResultPage({super.key, required this.item});

  final FoodItem item;

  @override
  State<FoodResultPage> createState() => _FoodResultPageState();
}

class _FoodResultPageState extends State<FoodResultPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<FoodHistoryCubit>().addQuery(widget.item));
  }

  @override
  Widget build(BuildContext context) {
    final (bg, fg, icon) = _verdictVisual(widget.item.verdict);

    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppPageHeader(title: widget.item.name),
          const SizedBox(height: AppSpacing.lg),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: bg, borderRadius: AppRadius.radiusLg),
            child: Column(
              children: [
                Icon(icon, color: fg, size: 32),
                const SizedBox(height: AppSpacing.xs),
                Text(widget.item.headline, style: AppTextStyles.titleLarge.copyWith(color: fg), textAlign: TextAlign.center),
                const SizedBox(height: 4),
                Text(widget.item.subline, style: AppTextStyles.bodySmall.copyWith(color: fg), textAlign: TextAlign.center),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('المحتوى الغذائي (لكل 100غ)', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.sm),
          for (final n in widget.item.nutrients) ...[
            AppCard(
              child: Row(
                children: [
                  Text(
                    n.value,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: n.status == 'مرتفع' ? AppColors.error : (n.status == 'متوسط' ? AppColors.accentAmberDeep : AppColors.primary),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Text(n.label, style: AppTextStyles.titleSmall),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          if (widget.item.note != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: AppRadius.radiusMd),
              child: Text(widget.item.note!, textAlign: TextAlign.right, style: AppTextStyles.bodySmall),
            ),
          ],
          if (widget.item.verdict == FoodVerdict.avoid && FoodItem.safeAlternatives.containsKey(widget.item.name)) ...[
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              label: 'عرض بدائل غذائية آمنة',
              variant: AppButtonVariant.outlined,
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => FoodAlternativesPage(foodName: widget.item.name))),
            ),
          ],
        ],
      ),
    );
  }
}
