import 'package:flutter/material.dart';
import 'package:fox_ui/src/stylized/stylized_widgets.dart';
import 'package:mix/mix.dart';
import 'package:flutter/widgets.dart' as widgets;

/// Visual variants for [FoxIcon].
enum FoxIconVariant {
  /// Inherits the default icon color.
  normal,

  /// Uses the primary theme color.
  primary,

  /// Uses the secondary theme color.
  secondary,

  /// Uses the destructive/error theme color.
  destructive,

  /// Uses the hint/muted theme color.
  hint,
}

/// A stylized icon component with pre-configured visual variants.
class FoxIcon extends StatelessWidget {
  /// Creates a stylized icon component.
  const FoxIcon(
    this.icon, {
    this.variant = FoxIconVariant.normal,
    this.size,
    this.style,
    super.key,
  });

  /// The icon data to display.
  final IconData icon;

  /// The visual variant.
  final FoxIconVariant variant;

  /// Optional fixed size for the icon.
  final double? size;

  /// Optional custom Mix style to apply.
  final IconStyler? style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final color = switch (variant) {
      FoxIconVariant.normal => null,
      FoxIconVariant.primary => colorScheme.primary,
      FoxIconVariant.secondary => colorScheme.secondary,
      FoxIconVariant.destructive => colorScheme.error,
      FoxIconVariant.hint => colorScheme.onSurfaceVariant,
    };

    var baseStyle = IconStyler();
    if (color != null) baseStyle = baseStyle.color(color);
    if (size != null) baseStyle = baseStyle.size(size!);

    return SIcon(
      icon,
      style: baseStyle.merge(style),
    );
  }
}

// /// Fox UI alias for Mix's [StyledIcon].
class SIcon extends StyledIcon {
  /// Creates a stylized icon.
  const SIcon(
    widgets.IconData? icon, {
    super.key,
    super.style,
    super.styleSpec,
    super.semanticLabel,
  }) : super(icon: icon);
}
