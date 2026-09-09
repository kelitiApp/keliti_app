import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/notifications/notifications_cubit.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/medication.dart';
import '../cubit/medications_cubit.dart';
import 'add_edit_medication_page.dart';
import 'medication_detail_page.dart';

IconData formIcon(MedicationForm form) => switch (form) {
      MedicationForm.tablets => Icons.medication_rounded,
      MedicationForm.syrup => Icons.local_drink_rounded,
      MedicationForm.injection => Icons.vaccines_rounded,
    };

class MedicationsPage extends StatelessWidget {
  const MedicationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      scrollable: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.md),
          BlocBuilder<NotificationsCubit, NotificationsState>(
            builder: (context, notifState) => AppTopBar(
              title: 'أدويتي',
              hasUnreadNotifications: notifState.unreadCount > 0,
              onNotificationsTap: () => Navigator.of(context).pushNamed(AppRoutes.notifications),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: BlocBuilder<MedicationsCubit, MedicationsState>(
              builder: (context, state) {
                if (state.medications.isEmpty) {
                  return SingleChildScrollView(
                    child: AppEmptyState(
                      icon: Icons.medication_outlined,
                      title: 'لا يوجد اي دواء مضاف بعد',
                      description: 'أضف أول دواء لخطة العلاج الان، وسوف نساعدك ب تتبع الجرعات والتذكيرات أول بأول',
                      actionLabel: 'إضافة أول دواء',
                      onAction: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AddEditMedicationPage()),
                      ),
                    ),
                  );
                }

                final active = state.active;
                final nextDose = _findNextDose(active, state);

                return ListView(
                  padding: const EdgeInsets.only(bottom: 90),
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(color: AppColors.primary, borderRadius: AppRadius.radiusLg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('إجمالي الادوية النشطة',
                              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70)),
                          const SizedBox(height: AppSpacing.xs),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${active.length}',
                                style: AppTextStyles.statValueLarge.copyWith(color: Colors.white),
                              ),
                              Text(
                                'أدوية. ${active.fold<int>(0, (sum, m) => sum + m.timesPerDay)} جرعات يوميا',
                                style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (nextDose != null) ...[
                      const SizedBox(height: AppSpacing.lg),
                      Text('الجرعة القادمة', style: AppTextStyles.titleMedium, textAlign: TextAlign.right),
                      const SizedBox(height: AppSpacing.sm),
                      _MedicationTile(medication: nextDose.$1, time: nextDose.$2, compact: true),
                    ],
                    const SizedBox(height: AppSpacing.lg),
                    Text('كل الأدوية', style: AppTextStyles.titleMedium, textAlign: TextAlign.right),
                    const SizedBox(height: AppSpacing.sm),
                    for (final medication in state.medications) ...[
                      _MedicationTile(medication: medication),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomBar: Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: 56,
          height: 56,
          child: FloatingActionButton(
            heroTag: 'add-medication',
            backgroundColor: AppColors.primary,
            onPressed: () =>
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddEditMedicationPage())),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),
    );
  }

  (Medication, String)? _findNextDose(List<Medication> active, MedicationsState state) {
    for (final m in active) {
      for (final t in m.doseTimes) {
        if (!state.isDoseTaken(m.id, t)) return (m, t);
      }
    }
    return null;
  }
}

class _MedicationTile extends StatelessWidget {
  const _MedicationTile({required this.medication, this.time, this.compact = false});

  final Medication medication;
  final String? time;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => MedicationDetailPage(medicationId: medication.id))),
      child: Row(
        children: [
          if (!compact && medication.active)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: AppColors.textTertiary),
              onSelected: (value) {
                if (value == 'edit') {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => AddEditMedicationPage(medication: medication)),
                  );
                } else if (value == 'stop') {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => MedicationDetailPage(medicationId: medication.id)));
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'edit', child: Text('تعديل الدواء')),
                PopupMenuItem(value: 'stop', child: Text('إيقاف الدواء', style: TextStyle(color: AppColors.error))),
              ],
            )
          else if (!medication.active)
            const StatusChip(label: 'متوقف', tone: StatusTone.neutral)
          else
            const Icon(Icons.chevron_left, color: AppColors.textTertiary),
          const Spacer(),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(medication.name, style: AppTextStyles.titleSmall),
                const SizedBox(height: 4),
                Text(
                  compact
                      ? 'قرص واحد . $time'
                      : (medication.active
                          ? '${medication.doseAmount} ${medication.doseUnit} . ${medication.timesPerDay} مرات / يوم'
                          : 'أوقف بتاريخ ${medication.stoppedOn}'),
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          AppIconBadge(
            icon: formIcon(medication.form),
            background: medication.active ? AppColors.primaryLight : AppColors.surfaceMuted,
            iconColor: medication.active ? AppColors.primary : AppColors.textTertiary,
          ),
        ],
      ),
    );
  }
}
