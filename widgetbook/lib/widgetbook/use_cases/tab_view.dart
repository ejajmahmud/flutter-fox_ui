import 'package:fox_ui/fox_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

const _tabs = [
  VedlaTab(label: Text('Overview'), body: Center(child: Text('Overview'))),
  VedlaTab(label: Text('Details'), body: Center(child: Text('Details'))),
  VedlaTab(label: Text('Settings'), body: Center(child: Text('Settings'))),
];

/// Basic [TabView] use case.
@widgetbook.UseCase(name: 'basic', type: TabView)
Widget basic(BuildContext context) => const TabView(tabs: _tabs);

/// Pre-selected [TabView] use case.
@widgetbook.UseCase(name: 'pre-selected', type: TabView)
Widget preSelected(BuildContext context) => const TabView(
  tabs: _tabs,
  initialIndex: 1,
);
