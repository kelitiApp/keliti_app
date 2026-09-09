import 'package:equatable/equatable.dart';

enum ResultStatus { normal, high, low }

class LabValue extends Equatable {
  const LabValue({required this.label, required this.value, required this.range, this.abnormal = false});

  final String label;
  final String value;
  final String range;
  final bool abnormal;

  @override
  List<Object?> get props => [label, value, range, abnormal];
}

class LabResult extends Equatable {
  const LabResult({
    required this.id,
    required this.name,
    required this.monthLabel,
    required this.dateLabel,
    required this.labName,
    required this.status,
    required this.values,
    this.doctorNote,
  });

  final String id;
  final String name;
  final String monthLabel;
  final String dateLabel;
  final String labName;
  final ResultStatus status;
  final List<LabValue> values;
  final String? doctorNote;

  @override
  List<Object?> get props => [id, name, monthLabel, dateLabel, labName, status, values, doctorNote];
}

class DialysisSessionLog extends Equatable {
  const DialysisSessionLog({
    required this.id,
    required this.dateLabel,
    required this.timeRange,
    required this.place,
    required this.weightBefore,
    required this.weightAfter,
    required this.bpBefore,
    required this.bpAfter,
    required this.fluidsRemovedL,
    this.nurseNotes,
  });

  final String id;
  final String dateLabel;
  final String timeRange;
  final String place;
  final double weightBefore;
  final double weightAfter;
  final String bpBefore;
  final String bpAfter;
  final double fluidsRemovedL;
  final String? nurseNotes;

  @override
  List<Object?> get props =>
      [id, dateLabel, timeRange, place, weightBefore, weightAfter, bpBefore, bpAfter, fluidsRemovedL, nurseNotes];
}

enum MeasurementType { weight, bloodPressure }

class Measurement extends Equatable {
  const Measurement({
    required this.id,
    required this.type,
    required this.dateLabel,
    required this.timeLabel,
    this.weightKg,
    this.systolic,
    this.diastolic,
  });

  final String id;
  final MeasurementType type;
  final String dateLabel;
  final String timeLabel;
  final double? weightKg;
  final int? systolic;
  final int? diastolic;

  @override
  List<Object?> get props => [id, type, dateLabel, timeLabel, weightKg, systolic, diastolic];
}
