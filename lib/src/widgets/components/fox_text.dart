import 'package:flutter/material.dart';

import 'package:mix/mix.dart';

/// Visual variants for [FoxText].
enum FoxTextVariant {
  /// Default body text.
  body,

  /// Large heading text.
  heading,

  /// Small, slightly emphasized label text.
  label,

  /// Muted hint or secondary text.
  hint,

  /// Monospaced text.
  monospace,
}

/// A stylized text component with pre-configured visual variants.
class FoxText extends StatelessWidget {
  /// Creates a stylized text component.
  const FoxText(
    this.text, {
    this.variant = FoxTextVariant.body,
    this.style,
    super.key,
  });

  /// The text to display.
  final String text;

  /// The visual variant.
  final FoxTextVariant variant;

  /// Optional custom Mix style to apply.
  final Style<TextSpec>? style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final baseTextStyle = switch (variant) {
      FoxTextVariant.body => theme.textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurface,
      ),
      FoxTextVariant.heading => theme.textTheme.titleLarge?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.bold,
      ),
      FoxTextVariant.label => theme.textTheme.labelMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w500,
      ),
      FoxTextVariant.hint => theme.textTheme.bodySmall?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      FoxTextVariant.monospace => theme.textTheme.bodyMedium?.copyWith(
        fontFamily: 'monospace',
        color: colorScheme.onSurface,
      ),
    };

    final s = style;
    return DefaultTextStyle.merge(
      style: baseTextStyle,
      child: s == null ? SText(text) : SText(text, style: s),
    );
  }
}

/// Fox UI alias for Mix's [StyledText].
class SText extends StyledText {
  /// Creates stylized text.
  const SText(
    super.text, {
    super.key,
    super.style,
    super.styleSpec,
  });
}
