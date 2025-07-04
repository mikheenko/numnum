import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../core/colors/color_manager.dart';

class KeyboardButton extends StatefulWidget {
  final Widget? child;
  final VoidCallback? onTap;
  final bool enabled;

  const KeyboardButton({
    this.child,
    this.onTap,
    this.enabled = true,
    super.key,
  });

  @override
  State<KeyboardButton> createState() => _KeyboardButtonState();
}

class _KeyboardButtonState extends State<KeyboardButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppButtonDimensions.keyboardButton,
      child: ElevatedButton(
        onPressed: widget.enabled ? widget.onTap : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colors.cardBackground,
          foregroundColor: context.colors.textPrimary,
          elevation: 2,
          shadowColor: context.colors.dividerColor.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: AppBorderRadius.medium,
          ),
          side: BorderSide(
            color: context.colors.dividerColor,
            width: 1.0,
          ),
        ),
        child: DefaultTextStyle(
          style: AppTextStyles.keyboard.copyWith(
            color: context.colors.textPrimary,
          ),
          child: widget.child ?? const SizedBox.shrink(),
        ),
      ),
    );
  }
}
