import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class AdaptiveButtonRow extends StatelessWidget {
  final List<Widget> children;
  final double spacing;

  const AdaptiveButtonRow({
    required this.children,
    this.spacing = AppSpacing.md,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate available width for buttons
        final availableWidth = constraints.maxWidth;
        final spacingWidth = (children.length - 1) * spacing;
        final buttonWidth = (availableWidth - spacingWidth) / children.length;

        // If button width is too small, use column layout
        if (buttonWidth < 120) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children
                .expand((child) => [child, SizedBox(height: spacing)])
                .take(children.length * 2 - 1)
                .toList(),
          );
        }

        // Otherwise use row layout with equal distribution
        return Row(
          children: children
              .map((child) => Expanded(child: child))
              .expand((child) => [child, SizedBox(width: spacing)])
              .take(children.length * 2 - 1)
              .toList(),
        );
      },
    );
  }
} 