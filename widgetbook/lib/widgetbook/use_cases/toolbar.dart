import 'package:fox_ui/fox_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

const _actions = [
  ToolbarAction(
    icon: Icon(Icons.save_outlined),
    label: 'Save',
    tooltip: 'Save',
  ),
  ToolbarAction(
    icon: Icon(Icons.share_outlined),
    label: 'Share',
    tooltip: 'Share',
  ),
  ToolbarAction(
    icon: Icon(Icons.delete_outline),
    label: 'Delete',
    tooltip: 'Delete',
  ),
];

/// [Toolbar] with title use case.
@widgetbook.UseCase(name: 'with title', type: Toolbar)
Widget withTitle(BuildContext context) => const Toolbar(
  title: Text('Document'),
  actions: _actions,
);

/// [Toolbar] actions only use case.
@widgetbook.UseCase(name: 'actions only', type: Toolbar)
Widget actionsOnly(BuildContext context) => const Toolbar(actions: _actions);
