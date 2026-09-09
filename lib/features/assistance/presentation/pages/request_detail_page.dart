import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/assistance_request.dart';
import '../cubit/assistance_cubit.dart';

class RequestDetailPage extends StatelessWidget {
  const RequestDetailPage({super.key, required this.requestId});

  final String requestId;

  @override
  Widget build(BuildContext context) {
    final request = context.read<AssistanceCubit>().byId(requestId);
    if (request == null) return const SizedBox.shrink();

    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppPageHeader(title: 'تفاصيل الطلب'),
          Row(
            children: [
              StatusChip(
                label: request.status == RequestStatus.sent ? 'قيد المتابعة' : 'تم التواصل',
                tone: request.status == RequestStatus.sent ? StatusTone.warning : StatusTone.primary,
              ),
              const Spacer(),
              Text('${request.dateLabel}، ${request.timeLabel}', style: AppTextStyles.bodyMedium),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('الأعراض المختارة', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: 6,
            children: [for (final s in request.symptoms) StatusChip(label: s, tone: StatusTone.primary)],
          ),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('شدة التعب', style: AppTextStyles.titleSmall),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: AppRadius.radiusPill,
                        child: LinearProgressIndicator(
                          value: request.severity / 5,
                          minHeight: 8,
                          backgroundColor: AppColors.surfaceMuted,
                          valueColor: const AlwaysStoppedAnimation(AppColors.accentAmberDeep),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text('${request.severity} من 5', style: AppTextStyles.bodyMedium),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('مسار الطلب', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            child: Column(
              children: [
                _TimelineRow(label: 'تم استلام طلبك', time: request.timeLabel),
                const SizedBox(height: AppSpacing.sm),
                _TimelineRow(label: 'تم إشعار ${request.targetName}', time: request.timeLabel),
                if (request.status == RequestStatus.contacted) ...[
                  const SizedBox(height: AppSpacing.sm),
                  const _TimelineRow(label: 'تم التواصل معك هاتفياً', time: null, subtitle: 'بواسطة الممرضة سهى'),
                ],
              ],
            ),
          ),
          if (request.centerNote != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Text('ملاحظة من المركز', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
            const SizedBox(height: AppSpacing.xs),
            AppCard(child: Text(request.centerNote!, textAlign: TextAlign.right, style: AppTextStyles.bodyMedium)),
          ],
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.label, required this.time, this.subtitle});

  final String label;
  final String? time;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.check_circle, color: AppColors.primary, size: 18),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(label, textAlign: TextAlign.right, style: AppTextStyles.bodyMedium),
              if (subtitle != null) Text(subtitle!, textAlign: TextAlign.right, style: AppTextStyles.caption),
            ],
          ),
        ),
        if (time != null) Text(time!, style: AppTextStyles.caption),
      ],
    );
  }
}
