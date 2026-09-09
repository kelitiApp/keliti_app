import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../cubit/reports_cubit.dart';
import 'share_report_sheet.dart';

enum _DayState { committed, partial, missed, empty }

// 30 days for August, mostly committed with a couple of exceptions —
// illustrative pattern matching the "خريطة الالتزام" heatmap in the design.
const _dayStates = <_DayState>[
  _DayState.empty, _DayState.committed, _DayState.committed, _DayState.committed, _DayState.committed, _DayState.partial, _DayState.committed,
  _DayState.empty, _DayState.committed, _DayState.committed, _DayState.committed, _DayState.committed, _DayState.committed, _DayState.committed,
  _DayState.missed, _DayState.committed, _DayState.committed, _DayState.committed, _DayState.committed, _DayState.committed, _DayState.committed,
  _DayState.committed, _DayState.committed, _DayState.committed, _DayState.committed, _DayState.committed, _DayState.committed, _DayState.committed,
];

class AdherenceReportPage extends StatelessWidget {
  const AdherenceReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ReportsCubit>().state;

    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppPageHeader(title: 'تقرير الالتزام'),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _AdherenceRing(label: 'الأدوية', percent: state.medicationAdherence, color: AppColors.accentPurple),
              _AdherenceRing(label: 'جلسات الغسيل', percent: state.dialysisAdherence, color: AppColors.primary),
              _AdherenceRing(label: 'المواعيد', percent: state.appointmentAdherence, color: AppColors.accentAmberDeep),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('خريطة الالتزام — أغسطس', style: AppTextStyles.titleMedium, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            child: Column(
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _dayStates.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                  ),
                  itemBuilder: (context, index) {
                    final s = _dayStates[index];
                    final color = switch (s) {
                      _DayState.committed => AppColors.primary,
                      _DayState.partial => AppColors.warning,
                      _DayState.missed => AppColors.errorLight,
                      _DayState.empty => AppColors.surfaceMuted,
                    };
                    return Container(decoration: BoxDecoration(color: color, borderRadius: AppRadius.radiusXs));
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _LegendDot(color: AppColors.primary, label: 'ملتزم'),
                    const SizedBox(width: AppSpacing.md),
                    _LegendDot(color: AppColors.warning, label: 'جزئي'),
                    const SizedBox(width: AppSpacing.md),
                    _LegendDot(color: AppColors.errorLight, label: 'فائت'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: 'مشاركة التقرير مع الطبيب',
            variant: AppButtonVariant.outlined,
            icon: Icons.ios_share_rounded,
            onPressed: () => showShareReportSheet(context),
          ),
        ],
      ),
    );
  }
}

class _AdherenceRing extends StatelessWidget {
  const _AdherenceRing({required this.label, required this.percent, required this.color});

  final String label;
  final int percent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 84,
          height: 84,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 84,
                height: 84,
                child: CircularProgressIndicator(
                  value: percent / 100,
                  strokeWidth: 8,
                  backgroundColor: AppColors.surfaceMuted,
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
              Text('$percent%', style: AppTextStyles.titleMedium),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}
