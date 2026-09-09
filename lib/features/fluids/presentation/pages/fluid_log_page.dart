import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../cubit/fluids_cubit.dart';

class FluidLogPage extends StatelessWidget {
  const FluidLogPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FluidsCubit>().state;
    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppPageHeader(title: 'سجل السوائل'),
          const SizedBox(height: AppSpacing.lg),
          _LogRow(label: 'اليوم', consumed: state.todayTotalMl, limit: state.dailyLimitMl, highlight: true),
          const SizedBox(height: AppSpacing.sm),
          for (final entry in state.pastDayTotals.entries) ...[
            _LogRow(label: entry.key, consumed: entry.value.$1, limit: entry.value.$2),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class _LogRow extends StatelessWidget {
  const _LogRow({required this.label, required this.consumed, required this.limit, this.highlight = false});

  final String label;
  final int consumed;
  final int limit;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final over = consumed > limit;
    return AppCard(
      borderColor: over ? AppColors.error : AppColors.border,
      child: Row(
        children: [
          Text(
            label,
            style: AppTextStyles.titleSmall.copyWith(color: highlight ? AppColors.primary : AppColors.textPrimary),
          ),
          const Spacer(),
          Text(
            '$limit / $consumed مل',
            style: AppTextStyles.bodyMedium.copyWith(
              color: over ? AppColors.error : (highlight ? AppColors.primary : AppColors.textPrimary),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
