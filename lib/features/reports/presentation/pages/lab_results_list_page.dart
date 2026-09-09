import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/report_models.dart';
import '../cubit/reports_cubit.dart';
import 'lab_result_detail_page.dart';

class LabResultsListPage extends StatelessWidget {
  const LabResultsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ReportsCubit>().state;
    final byMonth = <String, List<LabResult>>{};
    for (final r in state.labResults) {
      byMonth.putIfAbsent(r.monthLabel, () => []).add(r);
    }

    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppPageHeader(title: 'نتائج الفحوصات'),
          const SizedBox(height: AppSpacing.lg),
          for (final entry in byMonth.entries) ...[
            Text(entry.key, style: AppTextStyles.titleMedium, textAlign: TextAlign.right),
            const SizedBox(height: AppSpacing.sm),
            for (final result in entry.value) ...[
              AppCard(
                onTap: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => LabResultDetailPage(resultId: result.id))),
                child: Row(
                  children: [
                    StatusChip(
                      label: switch (result.status) {
                        ResultStatus.normal => 'طبيعية',
                        ResultStatus.high => 'قيمة مرتفعة',
                        ResultStatus.low => 'قيمة منخفضة',
                      },
                      tone: result.status == ResultStatus.normal ? StatusTone.primary : StatusTone.error,
                    ),
                    const Spacer(),
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(result.name, style: AppTextStyles.titleSmall),
                          const SizedBox(height: 4),
                          Text('${result.dateLabel} . ${result.labName}', style: AppTextStyles.caption),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    const AppIconBadge(icon: Icons.science_outlined),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}
