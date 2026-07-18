import 'package:mix/mix.dart';
import 'package:flutter/material.dart' as material;
import 'package:fox_ui/src/widgets/styles/styles.dart';

/// A themed card implemented with Mix.
class FoxCard extends material.StatelessWidget {
  /// Creates a themed card with optional header content.
  const FoxCard({super.key, this.title, this.subtitle, this.child});

  /// Creates a themed card without default inner padding.
  const FoxCard.raw({super.key, this.child}) : title = null, subtitle = null;

  /// Optional title displayed at the top of the card.
  final material.Widget? title;

  /// Optional subtitle displayed below [title].
  final material.Widget? subtitle;

  /// Optional body content.
  final material.Widget? child;

  @override
  material.Widget build(material.BuildContext context) {
    final theme = material.Theme.of(context);
    final hasHeader = title != null || subtitle != null;

    if (!hasHeader) {
      return Box(
        style: _cardStyle(theme),
        child: child ?? const material.SizedBox.shrink(),
      );
    }

    return Box(
      style: _cardStyle(theme),
      child: ColumnBox(
        style: FlexBoxStyler()
            .padding(EdgeInsetsGeometryMix.all(12))
            .crossAxisAlignment(material.CrossAxisAlignment.start),
        children: [
          ?title,
          if (subtitle != null) ...[
            const material.SizedBox(height: 4),
            material.DefaultTextStyle.merge(
              style: theme.textTheme.bodySmall,
              child: subtitle!,
            ),
          ],
          if (child != null) ...[const material.SizedBox(height: 8), child!],
        ],
      ),
    );
  }
}

/// A themed dialog.
