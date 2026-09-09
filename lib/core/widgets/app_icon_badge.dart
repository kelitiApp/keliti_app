import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Rounded-square colored icon container used as a leading visual for list
/// items (medication type, appointment type, report type ...).
class AppIconBadge extends StatelessWidget {
  const AppIconBadge({
    super.key,
    required this.icon,
    this.background = AppColors.primaryLight,
    this.iconColor = AppColors.primary,
    this.size = AppDimensions.iconBadgeSize,
  });

  final IconData icon;
  final Color background;
  final Color iconColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: background, borderRadius: AppRadius.radiusSm),
      child: Icon(icon, color: iconColor, size: size * 0.5),
    );
  }
}
