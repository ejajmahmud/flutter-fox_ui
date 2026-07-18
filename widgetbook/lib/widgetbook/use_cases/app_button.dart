import 'package:fox_ui/fox_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// On [Switch] use case.
@widgetbook.UseCase(name: 'on', type: Switch)
Widget on_(BuildContext context) => const Center(
  child: Switch(value: true, onChanged: null),
);

/// Off [Switch] use case.
@widgetbook.UseCase(name: 'off', type: Switch)
Widget off(BuildContext context) => const Center(
  child: Switch(value: false, onChanged: null),
);

/// Labeled [Switch] use case.
@widgetbook.UseCase(name: 'labeled', type: Switch)
Widget labeled(BuildContext context) => const Center(
  child: Switch(
    value: true,
    onChanged: null,
    label: Text('Enable notifications'),
  ),
);
