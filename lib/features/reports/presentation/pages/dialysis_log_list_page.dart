import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../cubit/reports_cubit.dart';
import 'dialysis_session_detail_page.dart';

class DialysisLogListPage extends StatelessWidget {
  const DialysisLogListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ReportsCubit>().state;

    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppPageHeader(title: 'سجل جلسات الغسيل'),
          const SizedBox(height: AppSpacing.lg),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(color: AppColors.primary, borderRadius: AppRadius.radiusLg),
            child: Row(
              children: [
                Text('${state.completedSessionsThisMonth}',
                    style: AppTextStyles.statValueLarge.copyWith(color: Colors.white)),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('هذا الشهر', style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70)),
                      Text('جلسة مكتملة من أصل ${state.totalSessionsThisMonth}',
                          style: AppTextStyles.bodyMedium.copyWith(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('أغسطس 2026', style: AppTextStyles.titleMedium, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.sm),
          for (final log in state.dialysisLogs) ...[
            AppCard(
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => DialysisSessionDetailPage(logId: log.id))),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: AppColors.primary, size: 18),
                  const Spacer(),
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(log.dateLabel, style: AppTextStyles.titleSmall),
                        const SizedBox(height: 4),
                        Text('${log.place} . 4 ساعات', style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  const AppIconBadge(icon: Icons.water_drop_rounded),
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
