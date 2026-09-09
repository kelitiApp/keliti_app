import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/appointment.dart';
import '../cubit/appointments_cubit.dart';
import 'add_edit_appointment_page.dart';
import 'appointments_page.dart';
import 'attendance_confirm_page.dart';

class AppointmentDetailPage extends StatelessWidget {
  const AppointmentDetailPage({super.key, required this.appointmentId});

  final String appointmentId;

  Future<void> _cancel(BuildContext context, Appointment appointment) async {
    if (appointment.isRecurring) {
      final result = await showAppConfirmSheet(
        context,
        icon: Icons.event_busy_outlined,
        title: 'إلغاء جلسة الغسيل؟',
        description: 'هاي الجلسة متكررة. حددي هل بدك تلغي جلسة اليوم بس، أو توقفي كل الجلسات القادمة.',
        confirmLabel: 'إيقاف كل الجلسات القادمة',
        extraActions: const [('single', 'إلغاء هذه الجلسة فقط')],
      );
      if ((result == 'confirm' || result == 'single') && context.mounted) {
        context.read<AppointmentsCubit>().cancel(appointment.id);
        Navigator.of(context).pop();
      }
      return;
    }

    final result = await showAppConfirmSheet(
      context,
      icon: Icons.event_busy_outlined,
      title: 'إلغاء الموعد؟',
      description: 'بتقدري تأجيليه لموعد ثاني بدل الإلغاء الكامل، خصوصاً لو الموعد مرتبط بمتابعة علاج مستمرة.',
      confirmLabel: 'إلغاء الموعد نهائياً',
      extraActions: [
        ('reschedule', 'تأجيل لموعد آخر'),
      ],
    );
    if (!context.mounted) return;
    if (result == 'confirm') {
      context.read<AppointmentsCubit>().cancel(appointment.id);
      Navigator.of(context).pop();
    } else if (result == 'reschedule') {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => AddEditAppointmentPage(appointment: appointment)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentsCubit, AppointmentsState>(
      builder: (context, state) {
        final appointment = context.read<AppointmentsCubit>().byId(appointmentId);
        if (appointment == null) return const SizedBox.shrink();
        final (bg, fg) = appointmentColors(appointment.type);

        return AppScaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.md),
              const AppPageHeader(title: 'تفاصيل الموعد'),
              const SizedBox(height: AppSpacing.lg),
              AppCard(
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
                      child: Icon(appointmentIcon(appointment.type), color: fg, size: 28),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(appointment.title, style: AppTextStyles.titleLarge),
                    if (appointment.isRecurring) ...[
                      const SizedBox(height: 4),
                      Text('متكررة . ${appointment.repeatsWeeklyOn.join('، ')}', style: AppTextStyles.caption),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppCard(
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, color: AppColors.textSecondary, size: 18),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text('${appointment.dateLabel}، ${appointment.timeLabel}',
                          textAlign: TextAlign.right, style: AppTextStyles.bodyMedium),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppCard(
                child: Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: AppColors.textSecondary, size: 18),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(child: Text(appointment.place, textAlign: TextAlign.right, style: AppTextStyles.bodyMedium)),
                  ],
                ),
              ),
              if (appointment.requiresFasting) ...[
                const SizedBox(height: AppSpacing.sm),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(color: AppColors.warningLight, borderRadius: AppRadius.radiusMd),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: AppColors.accentAmberDeep, size: 18),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          'تعليمات التحضير: الصيام لمدة ${appointment.fastingHours} ساعات قبل الموعد (يُسمح بالماء فقط).',
                          textAlign: TextAlign.right,
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.accentAmberDeep),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (appointment.notes.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                Text('ملاحظات', style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
                const SizedBox(height: AppSpacing.xs),
                AppTextField(hint: '', controller: TextEditingController(text: appointment.notes), enabled: false, maxLines: 2, textAlign: TextAlign.right),
              ],
              const SizedBox(height: AppSpacing.xl),
              if (appointment.status == AppointmentStatus.upcoming) ...[
                AppButton(
                  label: 'تأكيد الحضور',
                  icon: Icons.check_circle_outline,
                  onPressed: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => AttendanceConfirmPage(appointmentId: appointment.id))),
                ),
                const SizedBox(height: AppSpacing.sm),
                AppButton(
                  label: 'تعديل الموعد',
                  variant: AppButtonVariant.outlined,
                  icon: Icons.edit_outlined,
                  onPressed: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => AddEditAppointmentPage(appointment: appointment))),
                ),
                const SizedBox(height: AppSpacing.sm),
                AppButton(
                  label: 'إلغاء الموعد',
                  variant: AppButtonVariant.text,
                  onPressed: () => _cancel(context, appointment),
                ),
              ] else
                StatusChip(
                  label: switch (appointment.status) {
                    AppointmentStatus.completed => 'تم الحضور',
                    AppointmentStatus.missed => 'لم يتم الحضور',
                    AppointmentStatus.cancelled => 'ملغي',
                    AppointmentStatus.upcoming => '',
                  },
                  tone: appointment.status == AppointmentStatus.completed ? StatusTone.primary : StatusTone.error,
                ),
            ],
          ),
        );
      },
    );
  }
}
