import 'package:flutter/material.dart';

import '../theme/theme.dart';

enum AppButtonVariant { primary, secondary, outlined, destructive, text }

/// Single reusable button used across the whole app (login, save, confirm,
/// destructive actions ...). Configure via [variant] instead of creating a
/// new button widget per screen.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.expand = true,
    this.small = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final IconData? icon;
  final bool expand;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final bool disabled = onPressed == null || isLoading;
    final height = small ? AppDimensions.buttonHeightSmall : AppDimensions.buttonHeight;

    final Widget child = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              color: _foreground(disabled),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: AppDimensions.iconSm, color: _foreground(disabled)),
                const SizedBox(width: AppSpacing.xs),
              ],
              Text(
                label,
                style: (small ? AppTextStyles.buttonSmall : AppTextStyles.button)
                    .copyWith(color: _foreground(disabled)),
              ),
            ],
          );

    final button = _buildByVariant(context, disabled, child, height);

    return expand ? SizedBox(width: double.infinity, height: height, child: button) : button;
  }

  Color _foreground(bool disabled) {
    switch (variant) {
      case AppButtonVariant.primary:
      case AppButtonVariant.destructive:
        return disabled ? AppColors.textDisabled : AppColors.textOnPrimary;
      case AppButtonVariant.secondary:
        return disabled ? AppColors.textDisabled : AppColors.primary;
      case AppButtonVariant.outlined:
        return disabled ? AppColors.textDisabled : AppColors.textPrimary;
      case AppButtonVariant.text:
        return disabled ? AppColors.textDisabled : AppColors.primary;
    }
  }

  Widget _buildByVariant(BuildContext context, bool disabled, Widget child, double height) {
    final shape = RoundedRectangleBorder(borderRadius: AppRadius.radiusMd);

    switch (variant) {
      case AppButtonVariant.primary:
        return ElevatedButton(
          onPressed: disabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            disabledBackgroundColor: AppColors.surfaceMuted,
            minimumSize: Size(0, height),
            shape: shape,
            elevation: 0,
          ),
          child: child,
        );
      case AppButtonVariant.destructive:
        return ElevatedButton(
          onPressed: disabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            disabledBackgroundColor: AppColors.surfaceMuted,
            minimumSize: Size(0, height),
            shape: shape,
            elevation: 0,
          ),
          child: child,
        );
      case AppButtonVariant.secondary:
        return ElevatedButton(
          onPressed: disabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryLight,
            disabledBackgroundColor: AppColors.surfaceMuted,
            minimumSize: Size(0, height),
            shape: shape,
            elevation: 0,
          ),
          child: child,
        );
      case AppButtonVariant.outlined:
        return OutlinedButton(
          onPressed: disabled ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: disabled ? AppColors.border : AppColors.border),
            minimumSize: Size(0, height),
            shape: shape,
          ),
          child: child,
        );
      case AppButtonVariant.text:
        return TextButton(
          onPressed: disabled ? null : onPressed,
          style: TextButton.styleFrom(minimumSize: Size(0, height), shape: shape),
          child: child,
        );
    }
  }
}
