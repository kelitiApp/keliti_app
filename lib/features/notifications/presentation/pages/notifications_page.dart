import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/notifications/notification_item.dart';
import '../../../../core/notifications/notifications_cubit.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NotificationsCubit>().state;
    final byGroup = <String, List<NotificationItem>>{};
    for (final n in state.items) {
      byGroup.putIfAbsent(n.dayGroup, () => []).add(n);
    }

    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppPageHeader(
            title: 'الإشعارات',
            trailing: state.unreadCount == 0
                ? null
                : TextButton(
                    onPressed: () => context.read<NotificationsCubit>().markAllRead(),
                    child: const Text('تعليم الكل كمقروء'),
                  ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (state.items.isEmpty)
            const AppEmptyState(
              icon: Icons.notifications_none_rounded,
              title: 'لا يوجد إشعارات',
              description: 'كل التذكيرات، تنبيهات الجرعات الفائتة، والرسائل المهمة راح تظهر هون أول بأول.',
            )
          else
            for (final group in byGroup.entries) ...[
              Text(group.key, style: AppTextStyles.titleMedium, textAlign: TextAlign.right),
              const SizedBox(height: AppSpacing.sm),
              for (final n in group.value) ...[
                AppCard(
                  onTap: () => context.read<NotificationsCubit>().markRead(n.id),
                  borderColor: !n.read && n.kind == NotificationKind.doseMissed ? AppColors.warning : AppColors.border,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!n.read)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(top: 6),
                          decoration: BoxDecoration(
                            color: n.kind == NotificationKind.doseMissed ? AppColors.warning : AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      const Spacer(),
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(n.title, style: AppTextStyles.titleSmall, textAlign: TextAlign.right),
                            const SizedBox(height: 2),
                            Text(n.subtitle, textAlign: TextAlign.right, style: AppTextStyles.bodySmall),
                            const SizedBox(height: 2),
                            Text(n.timeLabel, style: AppTextStyles.overline),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      AppIconBadge(
                        icon: n.icon,
                        background: n.kind == NotificationKind.doseMissed ? AppColors.warningLight : AppColors.primaryLight,
                        iconColor: n.kind == NotificationKind.doseMissed ? AppColors.accentAmberDeep : AppColors.primary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              const SizedBox(height: AppSpacing.sm),
            ],
        ],
      ),
    );
  }
}
