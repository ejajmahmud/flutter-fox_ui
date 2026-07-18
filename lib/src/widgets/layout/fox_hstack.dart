import 'package:flutter/material.dart';

import 'package:mix/mix.dart';

/// Layout variants for [FoxHStack].
enum FoxHStackVariant {
  /// Standard left-to-right layout.
  normal,

  /// Centered content.
  centered,

  /// Items spaced evenly.
  spaceBetween,
}

/// A stylized horizontal stack (Row) component.
class FoxHStack extends StatelessWidget {
  /// Creates a horizontal stack.
  const FoxHStack({
    required this.children,
    this.variant = FoxHStackVariant.normal,
    this.style,
    super.key,
  });

  /// The children widgets.
  final List<Widget> children;

  /// The layout variant.
  final FoxHStackVariant variant;

  /// Optional custom Mix style to apply.
  final FlexBoxStyler? style;

  @override
  Widget build(BuildContext context) {
    var baseStyle = FlexBoxStyler().direction(Axis.horizontal);

    baseStyle = switch (variant) {
      FoxHStackVariant.normal => baseStyle,
      FoxHStackVariant.centered =>
        baseStyle
            .mainAxisAlignment(MainAxisAlignment.center)
            .crossAxisAlignment(CrossAxisAlignment.center),
      FoxHStackVariant.spaceBetween => baseStyle.mainAxisAlignment(
        MainAxisAlignment.spaceBetween,
      ),
    };

    return FlexBox(
      style: baseStyle.merge(style),
      children: children,
    );
  }
}
