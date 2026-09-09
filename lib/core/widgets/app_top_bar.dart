import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'app_circle_icon_button.dart';

/// Top bar used on root tab pages (Home, Medications, Appointments,
/// Reports, Profile) — a title with an optional bell/notification action.
class AppTopBar extends StatelessWidget {
  const AppTopBar({
    super.key,
    required this.title,
    this.onNotificationsTap,
    this.hasUnreadNotifications = false,
    this.trailing,
  });

  final String title;
  final VoidCallback? onNotificationsTap;
  final bool hasUnreadNotifications;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (trailing != null)
          trailing!
        else if (onNotificationsTap != null)
          Stack(
            clipBehavior: Clip.none,
            children: [
              AppCircleIconButton(
                icon: Icons.notifications_none_rounded,
                filled: false,
                onPressed: onNotificationsTap,
              ),
              if (hasUnreadNotifications)
                Positioned(
                  top: 2,
                  right: 2,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                  ),
                ),
            ],
          )
        else
          const SizedBox(width: AppDimensions.circleButtonSize),
        const Spacer(),
        Text(title, style: AppTextStyles.headlineSmall),
      ],
    );
  }
}
