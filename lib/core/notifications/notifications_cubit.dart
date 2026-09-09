import 'package:flutter_bloc/flutter_bloc.dart';

import 'notification_item.dart';

class NotificationsState {
  const NotificationsState({required this.items});

  final List<NotificationItem> items;

  int get unreadCount => items.where((n) => !n.read).length;

  static NotificationsState seed() => NotificationsState(items: [
        const NotificationItem(
          id: 'n1',
          kind: NotificationKind.doseMissed,
          title: 'فاتتك جرعة كربونات الكالسيوم',
          subtitle: 'كان موعدها الساعة 02:00 م — اضغط للتأكيد',
          timeLabel: 'قبل 15 دقيقة',
          dayGroup: 'اليوم',
        ),
        const NotificationItem(
          id: 'n2',
          kind: NotificationKind.doseDue,
          title: 'حان وقت جرعتك',
          subtitle: 'إريثروبويتين — حقنة 1 الساعة 08:00 ص',
          timeLabel: 'قبل ساعتين',
          dayGroup: 'اليوم',
        ),
        const NotificationItem(
          id: 'n3',
          kind: NotificationKind.sessionReminder,
          title: 'تذكير بموعد جلسة الغسيل',
          subtitle: 'غداً الساعة 07:00 ص — مركز الأمل',
          timeLabel: 'قبل 3 ساعات',
          dayGroup: 'اليوم',
        ),
        const NotificationItem(
          id: 'n4',
          kind: NotificationKind.doseTaken,
          title: 'تم تسجيل جرعة سيفيلامير',
          subtitle: 'أخذتها الساعة 08:05 م',
          timeLabel: 'أمس، 08:05 م',
          dayGroup: 'أمس',
          read: true,
        ),
        const NotificationItem(
          id: 'n5',
          kind: NotificationKind.doctorMessage,
          title: 'رسالة من د. أحمد خليل',
          subtitle: 'راجع نتيجة فحص الدم الأخيرة معك',
          timeLabel: 'أمس، 05:20 م',
          dayGroup: 'أمس',
          read: true,
        ),
      ]);
}

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsState.seed());

  void markAllRead() {
    emit(NotificationsState(items: [for (final n in state.items) n.copyWith(read: true)]));
  }

  void markRead(String id) {
    emit(NotificationsState(
      items: [for (final n in state.items) n.id == id ? n.copyWith(read: true) : n],
    ));
  }
}
