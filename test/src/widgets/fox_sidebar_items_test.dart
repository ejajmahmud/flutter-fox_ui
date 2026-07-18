import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fox_ui/fox_ui.dart';
import 'package:macos_ui/macos_ui.dart' as macos;

void main() {
  group('FoxSidebarItems', () {
    testWidgets('renders Fluent items on Windows', (tester) async {
      await tester.pumpWidget(
        _buildApp(
          platform: TargetPlatform.windows,
          child: _buildItems(),
        ),
      );

      expect(find.byType(fluent.ListTile), findsNWidgets(2));
      expect(find.byType(macos.SidebarItems), findsNothing);
    });

    testWidgets('renders Material items on Linux', (tester) async {
      await tester.pumpWidget(
        _buildApp(
          platform: TargetPlatform.linux,
          child: _buildItems(),
        ),
      );

      expect(find.byType(ListTile), findsNWidgets(2));
      expect(find.byType(macos.SidebarItems), findsNothing);
    });

    testWidgets('renders macOS items on macOS', (tester) async {
      await tester.pumpWidget(
        _buildApp(
          platform: TargetPlatform.macOS,
          child: _buildItems(),
        ),
      );

      expect(find.byType(macos.SidebarItems), findsOneWidget);
    });
  });
}

Widget _buildApp({
  required TargetPlatform platform,
  required Widget child,
}) {
  return FoxUIApp(
    forcePlatform: platform,
    home: Scaffold(
      body: SizedBox(
        height: 160,
        child: child,
      ),
    ),
  );
}

Widget _buildItems() {
  return FoxSidebarItems(
    currentIndex: 0,
    onChanged: (_) {},
    items: const [
      FoxSidebarItem(
        leading: Icon(Icons.folder_copy_outlined),
        label: Text('Projects'),
      ),
      FoxSidebarItem(
        leading: Icon(Icons.help_outline),
        label: Text('Tutorials'),
      ),
    ],
  );
}
