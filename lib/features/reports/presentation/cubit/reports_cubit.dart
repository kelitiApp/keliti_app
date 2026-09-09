import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/report_models.dart';

class ReportsState {
  const ReportsState({
    required this.labResults,
    required this.dialysisLogs,
    required this.measurements,
    required this.completedSessionsThisMonth,
    required this.totalSessionsThisMonth,
    required this.appointmentAdherence,
    required this.dialysisAdherence,
    required this.medicationAdherence,
  });

  final List<LabResult> labResults;
  final List<DialysisSessionLog> dialysisLogs;
  final List<Measurement> measurements;
  final int completedSessionsThisMonth;
  final int totalSessionsThisMonth;
  final int appointmentAdherence;
  final int dialysisAdherence;
  final int medicationAdherence;

  List<Measurement> get weightMeasurements => measurements.where((m) => m.type == MeasurementType.weight).toList();
  List<Measurement> get bpMeasurements => measurements.where((m) => m.type == MeasurementType.bloodPressure).toList();

  static ReportsState seed() => ReportsState(
        completedSessionsThisMonth: 12,
        totalSessionsThisMonth: 12,
        appointmentAdherence: 80,
        dialysisAdherence: 100,
        medicationAdherence: 92,
        labResults: const [
          LabResult(
            id: 'r1',
            name: 'تحليل الدم الشامل',
            monthLabel: 'أغسطس 2026',
            dateLabel: '25 أغسطس',
            labName: 'مختبر النور',
            status: ResultStatus.high,
            values: [
              LabValue(label: 'البوتاسيوم (K)', value: '5.8', range: 'الطبيعي: 3.5-5.0', abnormal: true),
              LabValue(label: 'اليوريا', value: '38', range: 'الطبيعي: 15-45'),
              LabValue(label: 'الهيموغلوبين', value: '11.4', range: 'الطبيعي: 11-14'),
            ],
            doctorNote: 'ارتفاع طفيف بالبوتاسيوم، يُنصح بتقليل الموز والبطاطا وسعيد الفحص بالجلسة الجاية.',
          ),
          LabResult(
            id: 'r2',
            name: 'وظائف الكلى',
            monthLabel: 'أغسطس 2026',
            dateLabel: '18 أغسطس',
            labName: 'مختبر النور',
            status: ResultStatus.normal,
            values: [
              LabValue(label: 'الكرياتينين', value: '4.1', range: 'الطبيعي: 0.6-4.5'),
              LabValue(label: 'الصوديوم', value: '138', range: 'الطبيعي: 135-145'),
            ],
          ),
          LabResult(
            id: 'r3',
            name: 'صورة دم',
            monthLabel: 'يوليو 2026',
            dateLabel: '30 يوليو',
            labName: 'مختبر النور',
            status: ResultStatus.normal,
            values: [
              LabValue(label: 'كريات الدم البيضاء', value: '6.8', range: 'الطبيعي: 4-11'),
            ],
          ),
        ],
        dialysisLogs: const [
          DialysisSessionLog(
            id: 'd1',
            dateLabel: 'الخميس 25 أغسطس',
            timeRange: '07:00 – 11:00 ص',
            place: 'مركز الأمل',
            weightBefore: 72.5,
            weightAfter: 70.1,
            bpBefore: '140/90',
            bpAfter: '120/80',
            fluidsRemovedL: 2.4,
            nurseNotes: 'جلسة سلسة بدون أي مضاعفات، استقرار جيد بضغط الدم.',
          ),
          DialysisSessionLog(
            id: 'd2',
            dateLabel: 'الثلاثاء 23 أغسطس',
            timeRange: '07:00 – 11:00 ص',
            place: 'مركز الأمل',
            weightBefore: 73.0,
            weightAfter: 70.6,
            bpBefore: '138/88',
            bpAfter: '118/78',
            fluidsRemovedL: 2.4,
          ),
          DialysisSessionLog(
            id: 'd3',
            dateLabel: 'الأحد 21 أغسطس',
            timeRange: '07:00 – 11:00 ص',
            place: 'مركز الأمل',
            weightBefore: 72.8,
            weightAfter: 70.3,
            bpBefore: '135/85',
            bpAfter: '119/79',
            fluidsRemovedL: 2.5,
          ),
        ],
        measurements: const [
          Measurement(id: 'v1', type: MeasurementType.weight, dateLabel: 'اليوم', timeLabel: '07:15 ص', weightKg: 71.0),
          Measurement(id: 'v2', type: MeasurementType.weight, dateLabel: 'أمس', timeLabel: '07:20 ص', weightKg: 71.4),
          Measurement(id: 'v3', type: MeasurementType.bloodPressure, dateLabel: 'اليوم', timeLabel: '08:00 ص', systolic: 128, diastolic: 84),
        ],
      );

  ReportsState copyWith({List<Measurement>? measurements}) => ReportsState(
        labResults: labResults,
        dialysisLogs: dialysisLogs,
        measurements: measurements ?? this.measurements,
        completedSessionsThisMonth: completedSessionsThisMonth,
        totalSessionsThisMonth: totalSessionsThisMonth,
        appointmentAdherence: appointmentAdherence,
        dialysisAdherence: dialysisAdherence,
        medicationAdherence: medicationAdherence,
      );
}

class ReportsCubit extends Cubit<ReportsState> {
  ReportsCubit() : super(ReportsState.seed());

  void addWeightMeasurement(double kg) {
    final m = Measurement(
      id: 'v${state.measurements.length + 1}',
      type: MeasurementType.weight,
      dateLabel: 'اليوم',
      timeLabel: 'الآن',
      weightKg: kg,
    );
    emit(state.copyWith(measurements: [...state.measurements, m]));
  }

  void addBloodPressureMeasurement(int systolic, int diastolic) {
    final m = Measurement(
      id: 'v${state.measurements.length + 1}',
      type: MeasurementType.bloodPressure,
      dateLabel: 'اليوم',
      timeLabel: 'الآن',
      systolic: systolic,
      diastolic: diastolic,
    );
    emit(state.copyWith(measurements: [...state.measurements, m]));
  }

  LabResult? labResultById(String id) {
    for (final r in state.labResults) {
      if (r.id == id) return r;
    }
    return null;
  }

  DialysisSessionLog? dialysisLogById(String id) {
    for (final d in state.dialysisLogs) {
      if (d.id == id) return d;
    }
    return null;
  }
}
