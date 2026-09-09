import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/session/patient_profile.dart';

class OnboardingState {
  const OnboardingState({
    this.birthDate,
    this.gender,
    this.bloodType,
    this.dialysisType,
    this.sessionsPerWeek,
    this.treatmentStartDate,
    this.center,
    this.doctor,
  });

  final String? birthDate;
  final String? gender;
  final String? bloodType;
  final String? dialysisType;
  final int? sessionsPerWeek;
  final String? treatmentStartDate;
  final DialysisCenterInfo? center;
  final DoctorInfo? doctor;

  OnboardingState copyWith({
    String? birthDate,
    String? gender,
    String? bloodType,
    String? dialysisType,
    int? sessionsPerWeek,
    String? treatmentStartDate,
    DialysisCenterInfo? center,
    DoctorInfo? doctor,
  }) {
    return OnboardingState(
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      bloodType: bloodType ?? this.bloodType,
      dialysisType: dialysisType ?? this.dialysisType,
      sessionsPerWeek: sessionsPerWeek ?? this.sessionsPerWeek,
      treatmentStartDate: treatmentStartDate ?? this.treatmentStartDate,
      center: center ?? this.center,
      doctor: doctor ?? this.doctor,
    );
  }
}

const List<DialysisCenterInfo> mockDialysisCenters = [
  DialysisCenterInfo(id: 'c1', name: 'مركز الأمل لغسيل الكلى', subtitle: 'المركز الرئيسي'),
  DialysisCenterInfo(id: 'c2', name: 'مستشفى الوفاء الصحي', subtitle: ''),
  DialysisCenterInfo(id: 'c3', name: 'مركز الرحمة الطبي', subtitle: ''),
];

const List<DoctorInfo> mockDoctors = [
  DoctorInfo(id: 'd1', name: 'د. عبير الريس', specialty: 'استشاري أمراض الكلى'),
  DoctorInfo(id: 'd2', name: 'د. أحمد عبدالله', specialty: 'استشاري أمراض الكلى'),
  DoctorInfo(id: 'd3', name: 'د. سميرة العاطي', specialty: 'استشاري أمراض الكلى'),
];

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState());

  void setBasicInfo({required String birthDate, required String gender, required String bloodType}) {
    emit(state.copyWith(birthDate: birthDate, gender: gender, bloodType: bloodType));
  }

  void setMedicalInfo({
    required String dialysisType,
    required int sessionsPerWeek,
    required String treatmentStartDate,
  }) {
    emit(state.copyWith(
      dialysisType: dialysisType,
      sessionsPerWeek: sessionsPerWeek,
      treatmentStartDate: treatmentStartDate,
    ));
  }

  void selectCenter(DialysisCenterInfo center) => emit(state.copyWith(center: center));

  void selectDoctor(DoctorInfo doctor) => emit(state.copyWith(doctor: doctor));
}
