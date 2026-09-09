import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Small circular icon button used for header back/forward actions,
/// notification bells, edit icons, etc. Appears throughout the designs as a
/// filled teal circle (active) or a muted gray circle (disabled/inactive).
class AppCircleIconButton extends StatelessWidget {
  const AppCircleIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.filled = true,
    this.size = AppDimensions.circleButtonSize,
    this.backgroundColor,
    this.iconColor,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final bool filled;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final bool active = onPressed != null;
    final Color bg = backgroundColor ??
        (filled ? (active ? AppColors.primary : AppColors.surfaceMuted) : Colors.transparent);
    final Color fg = iconColor ??
        (filled ? (active ? AppColors.textOnPrimary : AppColors.textTertiary) : AppColors.textPrimary);

    return Material(
      color: bg,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(icon, color: fg, size: size * 0.45),
        ),
      ),
    );
  }
}
