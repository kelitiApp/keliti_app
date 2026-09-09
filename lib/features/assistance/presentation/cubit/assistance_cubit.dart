import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/assistance_request.dart';

class AssistanceState {
  const AssistanceState({required this.requests});

  final List<AssistanceRequest> requests;

  static AssistanceState seed() => const AssistanceState(requests: [
        AssistanceRequest(
          id: 'req1',
          dateLabel: 'الخميس، 20 أغسطس',
          timeLabel: '09:45 م',
          symptoms: ['ضيق في التنفس', 'دوخة أو دوار'],
          severity: 3,
          status: RequestStatus.contacted,
          centerNote: 'تم تنبيه المريض بمراقبة ضغط الدم، وطلب موعد مبكر للمراجعة لو تكررت الدوخة.',
        ),
        AssistanceRequest(
          id: 'req2',
          dateLabel: 'الأحد، 16 أغسطس',
          timeLabel: '03:10 م',
          symptoms: ['ألم في الصدر'],
          severity: 5,
          status: RequestStatus.contacted,
        ),
        AssistanceRequest(
          id: 'req3',
          dateLabel: 'الثلاثاء، 11 أغسطس',
          timeLabel: '11:20 ص',
          symptoms: ['صداع في الرأس'],
          severity: 2,
          status: RequestStatus.contacted,
        ),
      ]);
}

class AssistanceCubit extends Cubit<AssistanceState> {
  AssistanceCubit() : super(AssistanceState.seed());

  Future<AssistanceRequest> sendRequest({
    required List<String> symptoms,
    required int severity,
    String targetName = 'مركز الأمل لغسيل الكلى',
  }) async {
    await Future.delayed(const Duration(milliseconds: 1400));
    final request = AssistanceRequest(
      id: 'req${state.requests.length + 1}',
      dateLabel: 'اليوم',
      timeLabel: 'الآن',
      symptoms: symptoms,
      severity: severity,
      status: RequestStatus.sent,
      targetName: targetName,
    );
    emit(AssistanceState(requests: [request, ...state.requests]));
    return request;
  }

  AssistanceRequest? byId(String id) {
    for (final r in state.requests) {
      if (r.id == id) return r;
    }
    return null;
  }
}
