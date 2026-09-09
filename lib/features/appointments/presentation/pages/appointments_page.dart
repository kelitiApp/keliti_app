import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/notifications/notifications_cubit.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/appointment.dart';
import '../cubit/appointments_cubit.dart';
import 'add_edit_appointment_page.dart';
import 'appointment_detail_page.dart';

IconData appointmentIcon(AppointmentType type) => switch (type) {
      AppointmentType.doctorVisit => Icons.monitor_heart_outlined,
      AppointmentType.dialysisSession => Icons.water_drop_rounded,
      AppointmentType.labTest => Icons.science_outlined,
    };

(Color, Color) appointmentColors(AppointmentType type) => switch (type) {
      AppointmentType.doctorVisit => (AppColors.warningLight, AppColors.accentAmberDeep),
      AppointmentType.dialysisSession => (AppColors.primaryLight, AppColors.primary),
      AppointmentType.labTest => (AppColors.infoLight, AppColors.info),
    };

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  int _tab = 1; // 0 = calendar, 1 = list
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

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
              title: 'المواعيد',
              hasUnreadNotifications: notifState.unreadCount > 0,
              onNotificationsTap: () => Navigator.of(context).pushNamed(AppRoutes.notifications),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SegmentedTabs(labels: const ['تقويم', 'قائمة'], selectedIndex: _tab == 1 ? 1 : 0, onChanged: (i) => setState(() => _tab = i)),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: BlocBuilder<AppointmentsCubit, AppointmentsState>(
              builder: (context, state) {
                if (state.appointments.isEmpty) {
                  return SingleChildScrollView(
                    child: AppEmptyState(
                      icon: Icons.event_note_outlined,
                      title: 'لا يوجد أي موعد مسجل بعد',
                      description: 'أضيفي جلسات الغسيل ومواعيد المتابعة عشان تنظمي جدولك وما تفوّتيها.',
                      actionLabel: 'إضافة أول موعد',
                      onAction: () => Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => const AddEditAppointmentPage())),
                    ),
                  );
                }

                return _tab == 0 ? _buildCalendar(state) : _buildList(state);
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
            heroTag: 'add-appointment',
            backgroundColor: AppColors.primary,
            onPressed: () =>
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AddEditAppointmentPage())),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildList(AppointmentsState state) {
    final today = state.appointments.where((a) => a.dateLabel == 'اليوم').toList();
    final upcoming = state.appointments.where((a) => a.dateLabel != 'اليوم').toList();

    return ListView(
      padding: const EdgeInsets.only(bottom: 90),
      children: [
        if (today.isNotEmpty) ...[
          Text('اليوم', style: AppTextStyles.titleMedium, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.sm),
          for (final a in today) ...[_AppointmentTile(appointment: a), const SizedBox(height: AppSpacing.sm)],
          const SizedBox(height: AppSpacing.sm),
        ],
        if (upcoming.isNotEmpty) ...[
          Text('قادمة', style: AppTextStyles.titleMedium, textAlign: TextAlign.right),
          const SizedBox(height: AppSpacing.sm),
          for (final a in upcoming) ...[_AppointmentTile(appointment: a), const SizedBox(height: AppSpacing.sm)],
        ],
      ],
    );
  }

  Widget _buildCalendar(AppointmentsState state) {
    final dayAppointments = state.appointments.where((a) {
      final dt = a.dateTime;
      return dt != null && isSameDay(dt, _selectedDay);
    }).toList();

    return ListView(
      padding: const EdgeInsets.only(bottom: 90),
      children: [
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.xs),
          child: TableCalendar<Appointment>(
            locale: 'ar',
            firstDay: DateTime.now().subtract(const Duration(days: 365)),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onDaySelected: (selected, focused) => setState(() {
              _selectedDay = selected;
              _focusedDay = focused;
            }),
            eventLoader: (day) => state.appointments.where((a) => a.dateTime != null && isSameDay(a.dateTime!, day)).toList(),
            headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
            calendarStyle: const CalendarStyle(
              selectedDecoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              todayDecoration: BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
              todayTextStyle: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
              markerDecoration: BoxDecoration(color: AppColors.accentAmberDeep, shape: BoxShape.circle),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('مواعيد ${_selectedDay.day}/${_selectedDay.month}', style: AppTextStyles.titleMedium, textAlign: TextAlign.right),
        const SizedBox(height: AppSpacing.sm),
        if (dayAppointments.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
            child: Text('لا توجد مواعيد في هذا اليوم', textAlign: TextAlign.center, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
          )
        else
          for (final a in dayAppointments) ...[_AppointmentTile(appointment: a), const SizedBox(height: AppSpacing.sm)],
      ],
    );
  }
}

class _AppointmentTile extends StatelessWidget {
  const _AppointmentTile({required this.appointment});

  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = appointmentColors(appointment.type);
    return AppCard(
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => AppointmentDetailPage(appointmentId: appointment.id))),
      child: Row(
        children: [
          if (appointment.status == AppointmentStatus.cancelled)
            const StatusChip(label: 'ملغي', tone: StatusTone.error)
          else
            const Icon(Icons.chevron_left, color: AppColors.textTertiary),
          const Spacer(),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(appointment.title, style: AppTextStyles.titleSmall),
                const SizedBox(height: 4),
                Text('${appointment.place} . ${appointment.timeLabel}', style: AppTextStyles.caption),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          AppIconBadge(icon: appointmentIcon(appointment.type), background: bg, iconColor: fg),
        ],
      ),
    );
  }
}
