import 'package:equatable/equatable.dart';

enum RequestStatus { sent, contacted, resolved }

class AssistanceRequest extends Equatable {
  const AssistanceRequest({
    required this.id,
    required this.dateLabel,
    required this.timeLabel,
    required this.symptoms,
    required this.severity,
    required this.status,
    this.centerNote,
    this.contactMethod = 'اتصال هاتفي',
    this.targetName = 'مركز الأمل لغسيل الكلى',
    this.targetSubtitle = 'المركز الرئيسي',
  });

  final String id;
  final String dateLabel;
  final String timeLabel;
  final List<String> symptoms;
  final int severity;
  final RequestStatus status;
  final String? centerNote;
  final String contactMethod;
  final String targetName;
  final String targetSubtitle;

  @override
  List<Object?> get props =>
      [id, dateLabel, timeLabel, symptoms, severity, status, centerNote, contactMethod, targetName, targetSubtitle];
}
