import 'package:flutter/material.dart';

import 'package:mix/mix.dart';

/// Layout variants for [FoxVStack].
enum FoxVStackVariant {
  /// Standard top-to-bottom layout.
  normal,

  /// Centered content.
  centered,

  /// Items spaced evenly.
  spaceBetween,
}

/// A stylized vertical stack (Column) component.
class FoxVStack extends StatelessWidget {
  /// Creates a vertical stack.
  const FoxVStack({
    required this.children,
    this.variant = FoxVStackVariant.normal,
    this.style,
    super.key,
  });

  /// The children widgets.
  final List<Widget> children;

  /// The layout variant.
  final FoxVStackVariant variant;

  /// Optional custom Mix style to apply.
  final FlexBoxStyler? style;

  @override
  Widget build(BuildContext context) {
    var baseStyle = FlexBoxStyler().direction(Axis.vertical);

    baseStyle = switch (variant) {
      FoxVStackVariant.normal => baseStyle,
      FoxVStackVariant.centered =>
        baseStyle
            .mainAxisAlignment(MainAxisAlignment.center)
            .crossAxisAlignment(CrossAxisAlignment.center),
      FoxVStackVariant.spaceBetween => baseStyle.mainAxisAlignment(
        MainAxisAlignment.spaceBetween,
      ),
    };

    return FlexBox(
      style: baseStyle.merge(style),
      children: children,
    );
  }
}
