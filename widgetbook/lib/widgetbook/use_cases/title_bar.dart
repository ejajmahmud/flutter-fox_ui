import 'package:fox_ui/fox_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// [TitleBar] with title only use case.
@widgetbook.UseCase(name: 'title only', type: TitleBar)
Widget titleOnly(BuildContext context) =>
    const TitleBar(title: 'My Document');

/// [TitleBar] with actions use case.
@widgetbook.UseCase(name: 'with actions', type: TitleBar)
Widget withActions(BuildContext context) => TitleBar(
  title: 'My Document',
  actions: [
    TitleBarAction(
      icon: const Icon(Icons.save_outlined),
      label: 'Save',
      onPressed: () {},
    ),
    TitleBarAction(
      icon: const Icon(Icons.share_outlined),
      label: 'Share',
      onPressed: () {},
    ),
  ],
);

/// [TitleBar] without title use case.
@widgetbook.UseCase(name: 'actions only', type: TitleBar)
Widget actionsOnly(BuildContext context) => TitleBar(
  actions: [
    TitleBarAction(
      icon: const Icon(Icons.close),
      label: 'Close',
      onPressed: () {},
    ),
  ],
);
