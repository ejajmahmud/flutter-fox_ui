import 'package:flutter/material.dart';
import 'package:fox_ui/fox_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Primary [Button] use case.
@widgetbook.UseCase(name: 'primary', type: Button)
Widget primary(BuildContext context) => Center(
  child: Button(onPressed: () {}, child: const Text('Primary')),
);

/// Secondary [Button] use case.
@widgetbook.UseCase(name: 'secondary', type: Button)
Widget secondary(BuildContext context) => Center(
  child: Button(
    onPressed: () {},
    variant: ButtonVariant.secondary,
    child: const Text('Secondary'),
  ),
);

/// Outline [Button] use case.
@widgetbook.UseCase(name: 'outline', type: Button)
Widget outline(BuildContext context) => Center(
  child: Button(
    onPressed: () {},
    variant: ButtonVariant.outline,
    child: const Text('Outline'),
  ),
);

/// Disabled [Button] use case.
@widgetbook.UseCase(name: 'disabled', type: Button)
Widget disabled(BuildContext context) => const Center(
  child: Button(onPressed: null, child: Text('Disabled')),
);

/// All sizes [Button] use case.
@widgetbook.UseCase(name: 'all sizes', type: Button)
Widget allSizes(BuildContext context) => Center(
  child: Column(
    mainAxisSize: MainAxisSize.min,
    spacing: 8,
    children: [
      for (final size in ButtonSize.values)
        Button(onPressed: () {}, size: size, child: Text(size.name)),
    ],
  ),
);
