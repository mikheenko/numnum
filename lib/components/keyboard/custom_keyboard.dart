import 'package:flutter/material.dart';
import '../buttons/keyboard_button.dart';
import '../../utils/constants.dart';
import '../../core/colors/color_manager.dart';

class CustomKeyboard extends StatelessWidget {
  final Function(String) onTap;
  final bool enabled;
  final VoidCallback? onHintTap;

  const CustomKeyboard({
    super.key,
    required this.onTap,
    this.enabled = true,
    this.onHintTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: context.colors.dividerColor,
            width: 1.0,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ряд 1: 1 2 3
            Row(
              children: [
                Expanded(child: _buildKey('1')),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: _buildKey('2')),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: _buildKey('3')),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            // Ряд 2: 4 5 6
            Row(
              children: [
                Expanded(child: _buildKey('4')),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: _buildKey('5')),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: _buildKey('6')),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            // Ряд 3: 7 8 9
            Row(
              children: [
                Expanded(child: _buildKey('7')),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: _buildKey('8')),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: _buildKey('9')),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            // Ряд 4: hint 0 backspace or empty 0 backspace
            Row(
              children: [
                onHintTap != null 
                    ? Expanded(child: _buildHintButton())
                    : const Expanded(child: SizedBox()),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: _buildKey('0')),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: _buildBackspaceKey()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKey(String value) {
    return KeyboardButton(
      onTap: enabled ? () => onTap(value) : null,
      enabled: enabled,
      child: Text(
        value,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildHintButton() {
    return KeyboardButton(
      onTap: onHintTap,
      enabled: onHintTap != null,
      child: const Icon(
        Icons.lightbulb_outline,
        size: 20,
      ),
    );
  }

  Widget _buildBackspaceKey() {
    return KeyboardButton(
      onTap: enabled ? () => onTap('<') : null,
      enabled: enabled,
      child: const Icon(
        Icons.backspace_outlined,
        size: 20,
      ),
    );
  }
} 