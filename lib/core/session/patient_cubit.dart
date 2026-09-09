import 'package:flutter_bloc/flutter_bloc.dart';

import 'patient_profile.dart';

/// Holds the signed-in patient's profile. Shared across Home, Profile,
/// Medical/Emergency card, Medications and Appointments (doctor/center
/// names) — hence promoted to `core/session` rather than a single feature.
class PatientCubit extends Cubit<PatientProfile> {
  PatientCubit() : super(PatientProfile.seed());

  void updatePersonalInfo({
    String? fullName,
    String? birthDate,
    String? gender,
    String? bloodType,
    String? phone,
    String? address,
  }) {
    emit(state.copyWith(
      fullName: fullName,
      birthDate: birthDate,
      gender: gender,
      bloodType: bloodType,
      phone: phone,
      address: address,
    ));
  }

  void updateMedicalCard({
    String? bloodType,
    String? allergies,
    String? additionalConditions,
    bool? showDialysisScheduleOnCard,
    bool? showEmergencyContactOnCard,
    bool? showMedicationsOnCard,
  }) {
    emit(state.copyWith(
      bloodType: bloodType,
      allergies: allergies,
      additionalConditions: additionalConditions,
      showDialysisScheduleOnCard: showDialysisScheduleOnCard,
      showEmergencyContactOnCard: showEmergencyContactOnCard,
      showMedicationsOnCard: showMedicationsOnCard,
    ));
  }

  void updateDoctor(DoctorInfo doctor) => emit(state.copyWith(doctor: doctor));

  void updateCenter(DialysisCenterInfo center) => emit(state.copyWith(center: center));
}
