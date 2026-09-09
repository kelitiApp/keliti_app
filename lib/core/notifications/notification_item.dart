import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum NotificationKind { doseMissed, doseDue, sessionReminder, doseTaken, doctorMessage, fastingReminder }

class NotificationItem extends Equatable {
  const NotificationItem({
    required this.id,
    required this.kind,
    required this.title,
    required this.subtitle,
    required this.timeLabel,
    required this.dayGroup,
    this.read = false,
  });

  final String id;
  final NotificationKind kind;
  final String title;
  final String subtitle;
  final String timeLabel;
  final String dayGroup;
  final bool read;

  IconData get icon => switch (kind) {
        NotificationKind.doseMissed => Icons.warning_amber_rounded,
        NotificationKind.doseDue => Icons.medication_liquid_rounded,
        NotificationKind.sessionReminder => Icons.calendar_today_rounded,
        NotificationKind.doseTaken => Icons.check_circle_rounded,
        NotificationKind.doctorMessage => Icons.chat_bubble_rounded,
        NotificationKind.fastingReminder => Icons.science_rounded,
      };

  NotificationItem copyWith({bool? read}) => NotificationItem(
        id: id,
        kind: kind,
        title: title,
        subtitle: subtitle,
        timeLabel: timeLabel,
        dayGroup: dayGroup,
        read: read ?? this.read,
      );

  @override
  List<Object?> get props => [id, kind, title, subtitle, timeLabel, dayGroup, read];
}
