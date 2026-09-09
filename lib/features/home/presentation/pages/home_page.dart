import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/notifications/notifications_cubit.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/session/patient_cubit.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../appointments/data/appointment.dart';
import '../../../appointments/presentation/cubit/appointments_cubit.dart';
import '../../../assistance/presentation/pages/assistance_hub_page.dart';
import '../../../fluids/presentation/cubit/fluids_cubit.dart';
import '../../../medications/presentation/cubit/medications_cubit.dart';
import '../../../medications/presentation/pages/dose_confirm_page.dart';
import '../../../medications/presentation/pages/medications_page.dart';
import '../../../reports/presentation/cubit/reports_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final patient = context.watch<PatientCubit>().state;
    final appointmentsState = context.watch<AppointmentsCubit>().state;
    final medsState = context.watch<MedicationsCubit>().state;
    final fluidsState = context.watch<FluidsCubit>().state;
    final reportsState = context.watch<ReportsCubit>().state;
    final unread = context.watch<NotificationsCubit>().state.unreadCount;

    final nextSession = appointmentsState.upcoming
        .where((a) => a.type == AppointmentType.dialysisSession)
        .isEmpty
        ? null
        : appointmentsState.upcoming.firstWhere((a) => a.type == AppointmentType.dialysisSession);

    final latestWeight = reportsState.weightMeasurements.isEmpty ? null : reportsState.weightMeasurements.last;
    final latestBp = reportsState.bpMeasurements.isEmpty ? null : reportsState.bpMeasurements.last;
    final morningMeds = medsState.active.where((m) => m.doseTimes.any((t) => t.contains('ص'))).toList();

    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AppCircleIconButton(
                    icon: Icons.notifications_none_rounded,
                    filled: false,
                    onPressed: () => Navigator.of(context).pushNamed(AppRoutes.notifications),
                  ),
                  if (unread > 0)
                    Positioned(
                      top: 2,
                      right: 2,
                      child: Container(width: 9, height: 9, decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle)),
                    ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('صباح الخير ${patient.firstName}', style: AppTextStyles.titleLarge),
                  Text('كيف حالك اليوم ؟', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                ],
              ),
              const SizedBox(width: AppSpacing.sm),
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primaryLight,
                child: Text(patient.fullName.substring(0, 1), style: AppTextStyles.titleMedium.copyWith(color: AppColors.primary)),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          if (nextSession != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(color: AppColors.primaryDark, borderRadius: AppRadius.radiusLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_month_rounded, color: Colors.white70, size: 16),
                      const SizedBox(width: 4),
                      Text('الجلسة القادمة', style: AppTextStyles.caption.copyWith(color: Colors.white70)),
                      const Spacer(),
                      const Icon(Icons.water_drop_rounded, color: Colors.white, size: 20),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(nextSession.dateLabel == 'اليوم' ? 'اليوم' : '${nextSession.dateLabel} القادم',
                      style: AppTextStyles.titleLarge.copyWith(color: Colors.white)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(nextSession.timeLabel, style: AppTextStyles.bodyMedium.copyWith(color: Colors.white)),
                      const SizedBox(width: 4),
                      const Icon(Icons.access_time, color: Colors.white70, size: 14),
                      const SizedBox(width: AppSpacing.sm),
                      Text(nextSession.place, style: AppTextStyles.bodyMedium.copyWith(color: Colors.white)),
                      const SizedBox(width: 4),
                      const Icon(Icons.location_on_outlined, color: Colors.white70, size: 14),
                    ],
                  ),
                ],
              ),
            ),
          const SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: AppRadius.radiusMd),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb_outline_rounded, color: AppColors.primary, size: 18),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('ملاحظة ذكية', style: AppTextStyles.titleSmall.copyWith(color: AppColors.primary)),
                      const SizedBox(height: 2),
                      Text(
                        fluidsState.progress < 0.9
                            ? 'لقد حافظت على الحد المسموح به من السوائل لمدة 3 أيام! استمر في هذا الأداء الرائع.'
                            : 'انتبه، اقتربت من حدك اليومي من السوائل.',
                        textAlign: TextAlign.right,
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryDark),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('المؤشرات الحيوية', style: AppTextStyles.titleMedium, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Text('الهدف: ${fluidsState.dailyLimitMl}ml', style: AppTextStyles.caption),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(Icons.water_drop_outlined, color: AppColors.primary, size: 16),
                        const SizedBox(width: 4),
                        Text('كمية السوائل', style: AppTextStyles.bodyMedium),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text('${(fluidsState.progress * 100).round()}%', style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary)),
                    const Spacer(),
                    Text('${fluidsState.todayTotalMl} ml', style: AppTextStyles.statValue),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: AppRadius.radiusPill,
                  child: LinearProgressIndicator(
                    value: fluidsState.progress,
                    minHeight: 6,
                    backgroundColor: AppColors.surfaceMuted,
                    valueColor: AlwaysStoppedAnimation(fluidsState.isOverLimit ? AppColors.error : AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Icon(Icons.monitor_weight_outlined, color: AppColors.textSecondary),
                      const SizedBox(height: 4),
                      Text('الوزن الجاف', style: AppTextStyles.caption),
                      Text(latestWeight == null ? '—' : '${latestWeight.weightKg} kg', style: AppTextStyles.statValue),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Icon(Icons.favorite_border_rounded, color: AppColors.error),
                      const SizedBox(height: 4),
                      Text('ضغط الدم', style: AppTextStyles.caption),
                      Text(
                        latestBp == null ? '—' : '${latestBp.systolic}/${latestBp.diastolic}',
                        style: AppTextStyles.statValue.copyWith(color: AppColors.error),
                      ),
                      const SizedBox(height: 4),
                      const StatusChip(label: 'مستقر', tone: StatusTone.primary),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MedicationsPage())),
                child: const Text('الكل'),
              ),
              const Spacer(),
              Text('أدوية الصباح', style: AppTextStyles.titleMedium),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (morningMeds.isEmpty)
            Text('لا توجد أدوية صباحية اليوم', textAlign: TextAlign.center, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary))
          else
            for (final medication in morningMeds) ...[
              AppCard(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => DoseConfirmPage(medicationId: medication.id, time: medication.doseTimes.firstWhere((t) => t.contains('ص'))),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      medsState.isDoseTaken(medication.id, medication.doseTimes.firstWhere((t) => t.contains('ص')))
                          ? Icons.check_box_rounded
                          : Icons.check_box_outline_blank_rounded,
                      color: AppColors.primary,
                    ),
                    const Spacer(),
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(medication.name, style: AppTextStyles.titleSmall),
                          Text('${medication.doseAmount}${medication.doseUnit} — ${medication.doseTimes.first}', style: AppTextStyles.caption),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    AppIconBadge(icon: formIcon(medication.form)),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          const SizedBox(height: AppSpacing.xl),
          Align(
            alignment: Alignment.centerLeft,
            child: AppButton(
              label: 'مساعدة سريعة',
              icon: Icons.auto_awesome,
              expand: false,
              variant: AppButtonVariant.destructive,
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AssistanceHubPage())),
            ),
          ),
        ],
      ),
    );
  }
}
