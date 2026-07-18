import 'package:flutter_test/flutter_test.dart';
import 'package:fox_ui/fox_ui.dart';

void main() {
  group('FoxScaffold', () {
    testWidgets('supports snackbars on Windows from the page context', (
      tester,
    ) async {
      await _pumpSnackBarApp(tester, TargetPlatform.windows);

      await tester.tap(find.text('Show'));
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(find.text('Snack'), findsOneWidget);
    });
  });
}

Future<void> _pumpSnackBarApp(
  WidgetTester tester,
  TargetPlatform platform,
) {
  return tester.pumpWidget(
    FoxUIApp(
      forcePlatform: platform,
      home: Builder(
        builder: (context) {
          return FoxScaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Snack')),
                  );
                },
                child: const Text('Show'),
              ),
            ),
          );
        },
      ),
    ),
  );
}
