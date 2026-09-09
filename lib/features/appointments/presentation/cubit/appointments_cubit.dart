import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../data/appointment.dart';

class AppointmentsState {
  const AppointmentsState({required this.appointments});

  final List<Appointment> appointments;

  List<Appointment> get upcoming =>
      appointments.where((a) => a.status == AppointmentStatus.upcoming).toList();

  static AppointmentsState seed() => AppointmentsState(appointments: Appointment.seed());

  AppointmentsState copyWith({List<Appointment>? appointments}) =>
      AppointmentsState(appointments: appointments ?? this.appointments);
}

class AppointmentsCubit extends Cubit<AppointmentsState> {
  AppointmentsCubit() : super(AppointmentsState.seed());

  static const _uuid = Uuid();

  Appointment add({
    required AppointmentType type,
    required String title,
    required String dateLabel,
    required String timeLabel,
    required String place,
    String notes = '',
    List<String> repeatsWeeklyOn = const [],
    bool requiresFasting = false,
    int? fastingHours,
  }) {
    final appointment = Appointment(
      id: _uuid.v4(),
      type: type,
      title: title,
      dateLabel: dateLabel,
      timeLabel: timeLabel,
      place: place,
      notes: notes,
      repeatsWeeklyOn: repeatsWeeklyOn,
      requiresFasting: requiresFasting,
      fastingHours: fastingHours,
    );
    emit(state.copyWith(appointments: [...state.appointments, appointment]));
    return appointment;
  }

  void update(Appointment updated) {
    emit(state.copyWith(appointments: [for (final a in state.appointments) a.id == updated.id ? updated : a]));
  }

  void cancel(String id) => _setStatus(id, AppointmentStatus.cancelled);

  void markCompleted(String id) => _setStatus(id, AppointmentStatus.completed);

  void markMissed(String id) => _setStatus(id, AppointmentStatus.missed);

  void _setStatus(String id, AppointmentStatus status) {
    emit(state.copyWith(
      appointments: [
        for (final a in state.appointments)
          if (a.id == id) a.copyWith(status: status) else a,
      ],
    ));
  }

  Appointment? byId(String id) {
    for (final a in state.appointments) {
      if (a.id == id) return a;
    }
    return null;
  }
}
