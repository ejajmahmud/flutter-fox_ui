import 'package:fox_ui/fox_ui.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Basic [Dropdown] use case.
@widgetbook.UseCase(name: 'basic', type: Dropdown)
Widget basic(BuildContext context) => Center(
  child: Dropdown<String>(
    value: 'banana',
    onChanged: (_) {},
    items: const [
      DropdownItem(value: 'apple', child: Text('Apple')),
      DropdownItem(value: 'banana', child: Text('Banana')),
      DropdownItem(value: 'cherry', child: Text('Cherry')),
    ],
  ),
);

/// Empty [Dropdown] use case.
@widgetbook.UseCase(name: 'placeholder', type: Dropdown)
Widget placeholder(BuildContext context) => Center(
  child: Dropdown<String>(
    onChanged: (_) {},
    placeholder: const Text('Select an option'),
    items: const [
      DropdownItem(value: 'a', child: Text('Option A')),
      DropdownItem(value: 'b', child: Text('Option B')),
    ],
  ),
);
