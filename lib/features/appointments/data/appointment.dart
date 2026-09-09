import 'package:equatable/equatable.dart';

enum AppointmentType { doctorVisit, dialysisSession, labTest }

extension AppointmentTypeX on AppointmentType {
  String get label => switch (this) {
        AppointmentType.doctorVisit => 'زيارة طبيب',
        AppointmentType.dialysisSession => 'جلسة غسيل',
        AppointmentType.labTest => 'فحص مخبري',
      };
}

enum AppointmentStatus { upcoming, completed, missed, cancelled }

class Appointment extends Equatable {
  const Appointment({
    required this.id,
    required this.type,
    required this.title,
    required this.dateLabel,
    required this.timeLabel,
    required this.place,
    this.notes = '',
    this.status = AppointmentStatus.upcoming,
    this.repeatsWeeklyOn = const [],
    this.requiresFasting = false,
    this.fastingHours,
    this.dateTime,
  });

  final String id;
  final AppointmentType type;
  final String title;
  final String dateLabel;
  final String timeLabel;
  final String place;
  final String notes;
  final AppointmentStatus status;

  /// Weekday labels this recurs on (dialysis sessions), empty if one-off.
  final List<String> repeatsWeeklyOn;
  final bool requiresFasting;
  final int? fastingHours;
  final DateTime? dateTime;

  bool get isRecurring => repeatsWeeklyOn.isNotEmpty;

  Appointment copyWith({
    String? title,
    String? dateLabel,
    String? timeLabel,
    String? place,
    String? notes,
    AppointmentStatus? status,
    List<String>? repeatsWeeklyOn,
    bool? requiresFasting,
    int? fastingHours,
  }) {
    return Appointment(
      id: id,
      type: type,
      title: title ?? this.title,
      dateLabel: dateLabel ?? this.dateLabel,
      timeLabel: timeLabel ?? this.timeLabel,
      place: place ?? this.place,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      repeatsWeeklyOn: repeatsWeeklyOn ?? this.repeatsWeeklyOn,
      requiresFasting: requiresFasting ?? this.requiresFasting,
      fastingHours: fastingHours ?? this.fastingHours,
      dateTime: dateTime,
    );
  }

  static List<Appointment> seed() => [
        Appointment(
          id: 'a1',
          type: AppointmentType.dialysisSession,
          title: 'جلسة غسيل الكلى',
          dateLabel: 'اليوم',
          timeLabel: '07:00 ص',
          place: 'مركز الأمل لغسيل الكلى',
          repeatsWeeklyOn: const ['أحد', 'ثلاثاء', 'خميس'],
          dateTime: DateTime.now(),
        ),
        Appointment(
          id: 'a2',
          type: AppointmentType.doctorVisit,
          title: 'زيارة د. أحمد خليل',
          dateLabel: 'غداً',
          timeLabel: '11:00 ص',
          place: 'العيادة الخارجية - مجمع الشفاء',
          notes: 'إحضار نتيجة فحص الدم الأخير ودفتر ضغط الدم.',
          dateTime: DateTime.now().add(const Duration(days: 1)),
        ),
        Appointment(
          id: 'a3',
          type: AppointmentType.labTest,
          title: 'فحص دم دوري',
          dateLabel: 'الخميس',
          timeLabel: '09:00 ص',
          place: 'مختبر النور',
          requiresFasting: true,
          fastingHours: 8,
          dateTime: DateTime.now().add(const Duration(days: 3)),
        ),
        Appointment(
          id: 'a4',
          type: AppointmentType.dialysisSession,
          title: 'جلسة غسيل الكلى',
          dateLabel: 'السبت',
          timeLabel: '07:00 ص',
          place: 'مركز الأمل لغسيل الكلى',
          status: AppointmentStatus.cancelled,
          dateTime: DateTime.now().add(const Duration(days: 2)),
        ),
      ];

  @override
  List<Object?> get props => [
        id,
        type,
        title,
        dateLabel,
        timeLabel,
        place,
        notes,
        status,
        repeatsWeeklyOn,
        requiresFasting,
        fastingHours,
      ];
}
