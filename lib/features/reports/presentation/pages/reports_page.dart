import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/notifications/notifications_cubit.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../cubit/reports_cubit.dart';
import 'adherence_report_page.dart';
import 'dialysis_log_list_page.dart';
import 'lab_results_list_page.dart';
import 'add_measurement_page.dart';
import 'share_report_sheet.dart';
import 'vitals_hub_page.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: BlocBuilder<ReportsCubit, ReportsState>(
        builder: (context, state) {
          final isEmpty = state.labResults.isEmpty && state.dialysisLogs.isEmpty && state.measurements.isEmpty;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BlocBuilder<NotificationsCubit, NotificationsState>(
                builder: (context, notifState) => AppTopBar(
                  title: 'التقارير',
                  hasUnreadNotifications: notifState.unreadCount > 0,
                  onNotificationsTap: () => Navigator.of(context).pushNamed(AppRoutes.notifications),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              if (isEmpty)
                AppEmptyState(
                  icon: Icons.description_outlined,
                  title: 'لا توجد تقارير بعد',
                  description: 'بعد أول جلسة غسيل أو فحص، بتظهر بياناتك هون تلقائياً.',
                  actionLabel: 'إضافة قياس يدوي',
                  onAction: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddMeasurementPage())),
                )
              else ...[
                _ReportTile(
                  icon: Icons.science_outlined,
                  color: AppColors.primary,
                  title: 'نتائج الفحوصات',
                  subtitle: state.labResults.isEmpty ? 'لا نتائج بعد' : 'آخر نتيجة: ${state.labResults.first.dateLabel}',
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LabResultsListPage())),
                ),
                const SizedBox(height: AppSpacing.sm),
                _ReportTile(
                  icon: Icons.water_drop_outlined,
                  color: AppColors.primary,
                  title: 'سجل جلسات الغسيل',
                  subtitle: '${state.dialysisLogs.length} جلسة هذا الشهر',
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DialysisLogListPage())),
                ),
                const SizedBox(height: AppSpacing.sm),
                _ReportTile(
                  icon: Icons.monitor_heart_outlined,
                  color: AppColors.accentAmberDeep,
                  title: 'المؤشرات الحيوية',
                  subtitle: 'الوزن وضغط الدم',
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const VitalsHubPage())),
                ),
                const SizedBox(height: AppSpacing.sm),
                _ReportTile(
                  icon: Icons.fact_check_outlined,
                  color: AppColors.accentPurple,
                  title: 'تقرير الالتزام بالعلاج',
                  subtitle: '${state.medicationAdherence}% هذا الشهر',
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AdherenceReportPage())),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  label: 'مشاركة تقرير شامل مع الطبيب',
                  variant: AppButtonVariant.outlined,
                  icon: Icons.ios_share_rounded,
                  onPressed: () => showShareReportSheet(context),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _ReportTile extends StatelessWidget {
  const _ReportTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          const Icon(Icons.chevron_left, color: AppColors.textTertiary),
          const Spacer(),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(title, style: AppTextStyles.titleSmall),
                const SizedBox(height: 4),
                Text(subtitle, style: AppTextStyles.caption),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          AppIconBadge(icon: icon, background: color.withValues(alpha: 0.12), iconColor: color),
        ],
      ),
    );
  }
}
