import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../data/medication.dart';

class MedicationsState {
  const MedicationsState({required this.medications, required this.takenDoseKeys});

  final List<Medication> medications;

  /// Keys of "medicationId|time" that have been marked taken today.
  final Set<String> takenDoseKeys;

  List<Medication> get active => medications.where((m) => m.active).toList();
  List<Medication> get inactive => medications.where((m) => !m.active).toList();

  bool isDoseTaken(String medicationId, String time) => takenDoseKeys.contains('$medicationId|$time');

  static MedicationsState seed() =>
      MedicationsState(medications: Medication.seed(), takenDoseKeys: {'m1|08:00 ص', 'm2|08:00 م'});

  MedicationsState copyWith({List<Medication>? medications, Set<String>? takenDoseKeys}) => MedicationsState(
        medications: medications ?? this.medications,
        takenDoseKeys: takenDoseKeys ?? this.takenDoseKeys,
      );
}

class MedicationsCubit extends Cubit<MedicationsState> {
  MedicationsCubit() : super(MedicationsState.seed());

  static const _uuid = Uuid();

  Medication addMedication({
    required String name,
    required MedicationForm form,
    required String doseAmount,
    required String doseUnit,
    required int timesPerDay,
    required List<String> doseTimes,
    String notes = '',
  }) {
    final medication = Medication(
      id: _uuid.v4(),
      name: name,
      form: form,
      doseAmount: doseAmount,
      doseUnit: doseUnit,
      timesPerDay: timesPerDay,
      doseTimes: doseTimes,
      notes: notes,
    );
    emit(state.copyWith(medications: [...state.medications, medication]));
    return medication;
  }

  void updateMedication(Medication updated) {
    emit(state.copyWith(medications: [for (final m in state.medications) m.id == updated.id ? updated : m]));
  }

  void stopMedication(String id) {
    emit(state.copyWith(
      medications: [
        for (final m in state.medications)
          if (m.id == id) m.copyWith(active: false, stoppedOn: 'اليوم') else m,
      ],
    ));
  }

  void markDoseTaken(String medicationId, String time) {
    emit(state.copyWith(takenDoseKeys: {...state.takenDoseKeys, '$medicationId|$time'}));
  }

  void unmarkDoseTaken(String medicationId, String time) {
    final updated = {...state.takenDoseKeys}..remove('$medicationId|$time');
    emit(state.copyWith(takenDoseKeys: updated));
  }

  Medication? byId(String id) {
    for (final m in state.medications) {
      if (m.id == id) return m;
    }
    return null;
  }
}
