import 'package:equatable/equatable.dart';

class DoctorInfo extends Equatable {
  const DoctorInfo({required this.id, required this.name, required this.specialty});

  final String id;
  final String name;
  final String specialty;

  @override
  List<Object?> get props => [id, name, specialty];
}

class DialysisCenterInfo extends Equatable {
  const DialysisCenterInfo({required this.id, required this.name, required this.subtitle});

  final String id;
  final String name;
  final String subtitle;

  @override
  List<Object?> get props => [id, name, subtitle];
}

class FamilyContact extends Equatable {
  const FamilyContact({
    required this.id,
    required this.name,
    required this.relation,
    required this.phone,
    this.fullAccess = true,
    this.pending = false,
  });

  final String id;
  final String name;
  final String relation;
  final String phone;
  final bool fullAccess;
  final bool pending;

  FamilyContact copyWith({bool? fullAccess, bool? pending}) => FamilyContact(
        id: id,
        name: name,
        relation: relation,
        phone: phone,
        fullAccess: fullAccess ?? this.fullAccess,
        pending: pending ?? this.pending,
      );

  @override
  List<Object?> get props => [id, name, relation, phone, fullAccess, pending];
}

class PatientProfile extends Equatable {
  const PatientProfile({
    required this.fullName,
    required this.birthDate,
    required this.gender,
    required this.bloodType,
    required this.phone,
    required this.address,
    required this.dialysisType,
    required this.sessionsPerWeek,
    required this.treatmentStartDate,
    required this.allergies,
    required this.additionalConditions,
    required this.doctor,
    required this.center,
    required this.emergencyContactName,
    required this.showDialysisScheduleOnCard,
    required this.showEmergencyContactOnCard,
    required this.showMedicationsOnCard,
  });

  final String fullName;
  final String birthDate;
  final String gender;
  final String bloodType;
  final String phone;
  final String address;
  final String dialysisType;
  final int sessionsPerWeek;
  final String treatmentStartDate;
  final String allergies;
  final String additionalConditions;
  final DoctorInfo doctor;
  final DialysisCenterInfo center;
  final String emergencyContactName;
  final bool showDialysisScheduleOnCard;
  final bool showEmergencyContactOnCard;
  final bool showMedicationsOnCard;

  String get firstName => fullName.split(' ').first;

  PatientProfile copyWith({
    String? fullName,
    String? birthDate,
    String? gender,
    String? bloodType,
    String? phone,
    String? address,
    String? allergies,
    String? additionalConditions,
    DoctorInfo? doctor,
    DialysisCenterInfo? center,
    bool? showDialysisScheduleOnCard,
    bool? showEmergencyContactOnCard,
    bool? showMedicationsOnCard,
  }) {
    return PatientProfile(
      fullName: fullName ?? this.fullName,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      bloodType: bloodType ?? this.bloodType,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      dialysisType: dialysisType,
      sessionsPerWeek: sessionsPerWeek,
      treatmentStartDate: treatmentStartDate,
      allergies: allergies ?? this.allergies,
      additionalConditions: additionalConditions ?? this.additionalConditions,
      doctor: doctor ?? this.doctor,
      center: center ?? this.center,
      emergencyContactName: emergencyContactName,
      showDialysisScheduleOnCard: showDialysisScheduleOnCard ?? this.showDialysisScheduleOnCard,
      showEmergencyContactOnCard: showEmergencyContactOnCard ?? this.showEmergencyContactOnCard,
      showMedicationsOnCard: showMedicationsOnCard ?? this.showMedicationsOnCard,
    );
  }

  static PatientProfile seed() => const PatientProfile(
        fullName: 'أحمد خليل الشريف',
        birthDate: '14/03/1978',
        gender: 'ذكر',
        bloodType: 'O+',
        phone: '059xxxxxxx',
        address: 'غزة',
        dialysisType: 'غسيل دموي',
        sessionsPerWeek: 3,
        treatmentStartDate: '10/1/2024',
        allergies: 'البنسلين',
        additionalConditions: '',
        doctor: DoctorInfo(id: 'd1', name: 'د. أحمد خليل', specialty: 'استشاري أمراض الكلى'),
        center: DialysisCenterInfo(
          id: 'c1',
          name: 'مركز الأمل لغسيل الكلى',
          subtitle: 'المركز الرئيسي',
        ),
        emergencyContactName: 'سمر أحمد (الأخت)',
        showDialysisScheduleOnCard: true,
        showEmergencyContactOnCard: true,
        showMedicationsOnCard: false,
      );

  @override
  List<Object?> get props => [
        fullName,
        birthDate,
        gender,
        bloodType,
        phone,
        address,
        dialysisType,
        sessionsPerWeek,
        treatmentStartDate,
        allergies,
        additionalConditions,
        doctor,
        center,
        emergencyContactName,
        showDialysisScheduleOnCard,
        showEmergencyContactOnCard,
        showMedicationsOnCard,
      ];
}
