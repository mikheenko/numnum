import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../core/theme/theme_extensions.dart';

class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const ResponsiveWrapper({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.background,
        borderRadius: AppBorderRadius.large,
      ),
      child: child,
    );
  }
} 