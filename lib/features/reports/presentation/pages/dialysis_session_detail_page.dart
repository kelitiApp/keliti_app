import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../cubit/reports_cubit.dart';

class DialysisSessionDetailPage extends StatelessWidget {
  const DialysisSessionDetailPage({super.key, required this.logId});

  final String logId;

  @override
  Widget build(BuildContext context) {
    final log = context.read<ReportsCubit>().dialysisLogById(logId);
    if (log == null) return const SizedBox.shrink();

    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppPageHeader(title: 'جلسة ${log.dateLabel.split(' ').first}'),
          const SizedBox(height: AppSpacing.xs),
          Text('${log.dateLabel} . ${log.timeRange} . ${log.place}',
              textAlign: TextAlign.right, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(child: _MetricBox(label: 'الوزن قبل', value: '${log.weightBefore} كغ')),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: _MetricBox(label: 'الوزن بعد', value: '${log.weightAfter} كغ')),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(child: _MetricBox(label: 'الضغط قبل', value: log.bpBefore)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: _MetricBox(label: 'الضغط بعد', value: log.bpAfter)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            child: Row(
              children: [
                Text('${log.fluidsRemovedL} لتر', style: AppTextStyles.titleMedium.copyWith(color: AppColors.primary)),
                const Spacer(),
                Text('السوائل المسحوبة', style: AppTextStyles.caption),
              ],
            ),
          ),
          if (log.nurseNotes != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Text('ملاحظات الممرضة', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
            const SizedBox(height: AppSpacing.xs),
            AppCard(child: Text(log.nurseNotes!, textAlign: TextAlign.right, style: AppTextStyles.bodyMedium)),
          ],
        ],
      ),
    );
  }
}

class _MetricBox extends StatelessWidget {
  const _MetricBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Text(label, style: AppTextStyles.caption),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.titleMedium),
        ],
      ),
    );
  }
}
