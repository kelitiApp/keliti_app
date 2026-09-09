import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/food_item.dart';
import '../cubit/food_history_cubit.dart';
import 'food_result_page.dart';

(String, StatusTone) _labelFor(FoodVerdict v) => switch (v) {
      FoodVerdict.safe => ('آمن', StatusTone.primary),
      FoodVerdict.caution => ('باعتدال', StatusTone.warning),
      FoodVerdict.avoid => ('تجنّب', StatusTone.error),
    };

class FoodQuestionHistoryPage extends StatelessWidget {
  const FoodQuestionHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final entries = context.watch<FoodHistoryCubit>().state.entries;

    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppPageHeader(title: 'سجل الأسئلة'),
          const SizedBox(height: AppSpacing.lg),
          if (entries.isEmpty)
            const AppEmptyState(icon: Icons.history_rounded, title: 'لا يوجد سجل بعد')
          else
            for (final item in entries) ...[
              AppCard(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => FoodResultPage(item: item))),
                child: Row(
                  children: [
                    StatusChip(label: _labelFor(item.verdict).$1, tone: _labelFor(item.verdict).$2),
                    const Spacer(),
                    Text(item.name, style: AppTextStyles.titleSmall),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
        ],
      ),
    );
  }
}
