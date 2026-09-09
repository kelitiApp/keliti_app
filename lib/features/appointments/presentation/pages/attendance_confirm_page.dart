import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/appointment.dart';
import '../cubit/appointments_cubit.dart';
import 'appointments_page.dart';

class AttendanceConfirmPage extends StatelessWidget {
  const AttendanceConfirmPage({super.key, required this.appointmentId});

  final String appointmentId;

  String _questionFor(Appointment appointment) => switch (appointment.type) {
        AppointmentType.dialysisSession => 'هل حضرت جلسة الغسيل اليوم؟',
        AppointmentType.doctorVisit => 'هل حضرت زيارة ${appointment.title.replaceFirst('زيارة ', '')}؟',
        AppointmentType.labTest => 'هل تم إجراء الفحص؟',
      };

  @override
  Widget build(BuildContext context) {
    final appointment = context.read<AppointmentsCubit>().byId(appointmentId);
    if (appointment == null) return const SizedBox.shrink();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
              child: Row(
                children: [
                  Text('تأكيد الحضور', style: AppTextStyles.headlineSmall),
                ],
              ),
            ),
            Expanded(
              child: AppResultView(
                tone: ResultTone.info,
                icon: appointmentIcon(appointment.type),
                title: _questionFor(appointment),
                description: '${appointment.place} . كان الموعد ${appointment.timeLabel}',
                primaryLabel: 'نعم، حضرت',
                onPrimary: () {
                  context.read<AppointmentsCubit>().markCompleted(appointmentId);
                  Navigator.of(context).pop();
                },
                secondaryLabel: 'لا ليس بعد',
                onSecondary: () {
                  context.read<AppointmentsCubit>().markMissed(appointmentId);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
