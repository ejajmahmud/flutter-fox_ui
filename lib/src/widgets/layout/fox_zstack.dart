import 'package:flutter/material.dart';

import 'package:mix/mix.dart';

/// Layout variants for [FoxZStack].
enum FoxZStackVariant {
  /// Standard stack layout.
  normal,

  /// Centered stack.
  centered,

  /// Expanded stack.
  expand,
}

/// A stylized Z-stack (Stack) component.
class FoxZStack extends StatelessWidget {
  /// Creates a Z-stack.
  const FoxZStack({
    required this.children,
    this.variant = FoxZStackVariant.normal,
    this.style,
    super.key,
  });

  /// The children widgets.
  final List<Widget> children;

  /// The layout variant.
  final FoxZStackVariant variant;

  /// Optional custom Mix style to apply.
  final StackBoxStyler? style;

  @override
  Widget build(BuildContext context) {
    var baseStyle = StackBoxStyler();

    baseStyle = switch (variant) {
      FoxZStackVariant.normal => baseStyle,
      FoxZStackVariant.centered => baseStyle.alignment(Alignment.center),
      FoxZStackVariant.expand => baseStyle.fit(StackFit.expand),
    };

    return StackBox(
      style: baseStyle.merge(style),
      children: children,
    );
  }
}
