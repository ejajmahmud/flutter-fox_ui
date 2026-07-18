import 'package:flutter/material.dart';

import 'package:mix/mix.dart';

/// Layout variants for [FoxGrid].
enum FoxGridVariant {
  /// Standard grid.
  normal,

  /// Centered grid.
  centered,
}

/// A stylized grid component that wraps its children.
/// Uses a Wrap internally for dynamic layout.
class FoxGrid extends StatelessWidget {
  /// Creates a grid component.
  const FoxGrid({
    required this.children,
    this.variant = FoxGridVariant.normal,
    this.style,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
    super.key,
  });

  /// The children widgets.
  final List<Widget> children;

  /// The layout variant.
  final FoxGridVariant variant;

  /// Optional custom Mix box style to apply to the container.
  final BoxStyler? style;

  /// Spacing between items in the cross axis.
  final double spacing;

  /// Spacing between runs in the main axis.
  final double runSpacing;

  @override
  Widget build(BuildContext context) {
    var baseStyle = BoxStyler();

    baseStyle = switch (variant) {
      FoxGridVariant.normal => baseStyle,
      FoxGridVariant.centered => baseStyle.alignment(Alignment.center),
    };

    return Box(
      style: baseStyle.merge(style),
      child: Wrap(
        spacing: spacing,
        runSpacing: runSpacing,
        alignment: variant == FoxGridVariant.centered
            ? WrapAlignment.center
            : WrapAlignment.start,
        children: children,
      ),
    );
  }
}
