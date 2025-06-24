import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../core/theme/theme_extensions.dart';

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? iconColor;
  final Color? valueColor;

  const StatsCard({
    required this.title,
    required this.value,
    required this.icon,
    this.iconColor,
    this.valueColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: AppBorderRadius.large,
        border: Border.all(
          color: context.colors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: (iconColor ?? context.colors.primary).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 18,
              color: iconColor ?? context.colors.primary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTextStyles.body1.copyWith(
              color: valueColor ?? context.colors.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            title,
            style: AppTextStyles.body2.copyWith(
              color: context.colors.onSurfaceVariant,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
} 