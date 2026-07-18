import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fox_ui/fox_ui.dart';

void main() {
  group('FoxToolBar', () {
    testWidgets('renders on Windows without actions', (tester) async {
      await tester.pumpWidget(
        FoxUIApp(
          forcePlatform: TargetPlatform.windows,
          home: const Scaffold(
            body: FoxToolBar(title: Text('Settings')),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('renders on Windows with a standard action', (tester) async {
      await tester.pumpWidget(
        FoxUIApp(
          forcePlatform: TargetPlatform.windows,
          home: Scaffold(
            body: FoxToolBar(
              title: const Text('Projects'),
              actions: [
                FoxToolBarIconButton(
                  label: 'Add',
                  icon: const Icon(Icons.add),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Projects'), findsOneWidget);
    });

    testWidgets('renders on Windows with a custom action', (tester) async {
      await tester.pumpWidget(
        FoxUIApp(
          forcePlatform: TargetPlatform.windows,
          home: Scaffold(
            body: FoxToolBar(
              title: const Text('Projects'),
              actions: [
                CustomToolBarItem(
                  inToolbarBuilder: (context) {
                    return const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('New Project'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('New Project'), findsOneWidget);
    });
  });
}
