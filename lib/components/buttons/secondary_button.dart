import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../core/colors/color_manager.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool enabled;
  final double? width;
  final double height;
  final IconData? icon;

  const SecondaryButton({
    required this.text,
    this.onPressed,
    this.enabled = true,
    this.width,
    this.height = AppButtonDimensions.heightMedium,
    this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: OutlinedButton(
        onPressed: enabled ? onPressed : null,
        style: OutlinedButton.styleFrom(
          backgroundColor: context.colors.cardBackground,
          foregroundColor: context.colors.textPrimary,
          side: BorderSide(
            color: context.colors.dividerColor,
            width: 1.0,
          ),
          elevation: 1,
          shadowColor: context.colors.dividerColor.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: AppBorderRadius.medium,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: height > 48 ? AppSpacing.md : AppSpacing.sm,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 18,
                color: context.colors.textPrimary,
              ),
              const SizedBox(width: AppSpacing.xs),
            ],
            Flexible(
              child: Text(
                text,
                style: AppTextStyles.button.copyWith(
                  color: context.colors.textPrimary,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 