import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/assistance_request.dart';
import '../cubit/assistance_cubit.dart';
import 'request_detail_page.dart';

class MyRequestsPage extends StatelessWidget {
  const MyRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final requests = context.watch<AssistanceCubit>().state.requests;

    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppPageHeader(title: 'طلباتي'),
          const SizedBox(height: AppSpacing.lg),
          if (requests.isEmpty)
            const AppEmptyState(icon: Icons.inbox_outlined, title: 'لا توجد طلبات بعد')
          else
            for (final r in requests) ...[
              AppCard(
                onTap: () =>
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => RequestDetailPage(requestId: r.id))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        StatusChip(
                          label: r.status == RequestStatus.sent ? 'قيد المتابعة' : 'تم التواصل',
                          tone: r.status == RequestStatus.sent ? StatusTone.warning : StatusTone.primary,
                        ),
                        const Spacer(),
                        Text('${r.dateLabel}، ${r.timeLabel}', style: AppTextStyles.bodySmall),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      alignment: WrapAlignment.end,
                      spacing: 6,
                      children: [for (final s in r.symptoms) StatusChip(label: s, tone: StatusTone.neutral)],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: AppRadius.radiusPill,
                            child: LinearProgressIndicator(
                              value: r.severity / 5,
                              minHeight: 6,
                              backgroundColor: AppColors.surfaceMuted,
                              valueColor: const AlwaysStoppedAnimation(AppColors.accentAmberDeep),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text('${r.severity} من 5', style: AppTextStyles.caption),
                      ],
                    ),
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
