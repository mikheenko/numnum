import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../core/theme/theme_extensions.dart';

class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isEnabled = true,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = AppButtonDimensions.heightLarge,
    this.icon,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: AppBorderRadius.medium,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: widget.isEnabled && !widget.isLoading ? widget.onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.backgroundColor ?? context.colors.primary,
          foregroundColor: widget.textColor ?? context.colors.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: AppBorderRadius.medium,
          ),
          elevation: 0,
        ),
        child: widget.isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    widget.textColor ?? context.colors.onPrimary,
                  ),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, size: 20),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Text(
                    widget.text,
                    style: AppTextStyles.button.copyWith(
                      color: widget.textColor ?? context.colors.onPrimary,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
} 