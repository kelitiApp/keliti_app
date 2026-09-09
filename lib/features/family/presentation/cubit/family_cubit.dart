import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/session/patient_profile.dart';

class FamilyState {
  const FamilyState({required this.contacts});

  final List<FamilyContact> contacts;

  static FamilyState seed() => const FamilyState(contacts: [
        FamilyContact(id: 'f1', name: 'سمر أحمد', relation: 'الأخت', phone: '059xxxxxxx'),
        FamilyContact(
          id: 'f2',
          name: 'محمود أحمد',
          relation: 'الابن',
          phone: '059xxxxxxx',
          fullAccess: false,
        ),
        FamilyContact(id: 'f3', name: 'رنا خليل', relation: 'الزوجة', phone: '059xxxxxxx', pending: true),
      ]);
}

/// Manages the patient's family contacts / invitations. Shared by the
/// onboarding "invite a family member" step and the Profile "family
/// contacts" screen.
class FamilyCubit extends Cubit<FamilyState> {
  FamilyCubit() : super(FamilyState.seed());

  Future<FamilyContact> invite({
    required String phone,
    required String relation,
    required bool fullAccess,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final contact = FamilyContact(
      id: 'f${state.contacts.length + 1}',
      name: 'دعوة جديدة',
      relation: relation,
      phone: phone,
      fullAccess: fullAccess,
      pending: true,
    );
    emit(FamilyState(contacts: [...state.contacts, contact]));
    return contact;
  }

  void updateAccess(String id, {required bool fullAccess}) {
    emit(FamilyState(
      contacts: [
        for (final c in state.contacts)
          if (c.id == id) c.copyWith(fullAccess: fullAccess) else c,
      ],
    ));
  }

  void remove(String id) {
    emit(FamilyState(contacts: state.contacts.where((c) => c.id != id).toList()));
  }
}
