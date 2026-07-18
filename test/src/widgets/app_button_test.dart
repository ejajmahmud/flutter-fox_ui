// Not required for test files.
// ignore_for_file: prefer_const_constructors

import 'package:adaptive_platform_ui/adaptive_platform_ui.dart' as adaptive;
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fox_ui/fox_ui.dart';
import 'package:macos_ui/macos_ui.dart' as macos;
import 'package:yaru/yaru.dart' as yaru;

import '../../helpers/helpers.dart';

void main() {
  group('Button', () {
    testWidgets('renders child', (tester) async {
      await tester.pumpApp(
        FoxButton(onPressed: () {}, child: Text('Tap me')),
      );

      expect(find.text('Tap me'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      var tapped = false;
      await tester.pumpApp(
        FoxButton(onPressed: () => tapped = true, child: Text('Tap me')),
      );

      await tester.tap(find.byType(FoxButton));
      expect(tapped, isTrue);
    });

    testWidgets('does not call onPressed when disabled', (tester) async {
      await tester.pumpApp(
        FoxButton(onPressed: null, child: Text('Disabled')),
      );

      await tester.tap(find.byType(FoxButton));
    });

    testWidgets('renders Fluent FilledButton on Windows', (tester) async {
      final previousPlatform = debugDefaultTargetPlatformOverride;
      debugDefaultTargetPlatformOverride = TargetPlatform.windows;

      try {
        await tester.pumpApp(
          FoxButton(onPressed: () {}, child: Text('Primary')),
        );

        expect(find.byType(fluent.FilledButton), findsOneWidget);
      } finally {
        debugDefaultTargetPlatformOverride = previousPlatform;
      }
    });

    testWidgets('renders custom outlined variant styling', (tester) async {
      await tester.pumpApp(
        FoxButton(
          onPressed: () {},
          variant: FoxButtonVariant.outline,
          child: Text('Outline'),
        ),
      );

      expect(find.byType(PressableBox), findsOneWidget);
      expect(find.byType(fluent.OutlinedButton), findsNothing);

      final box = tester.widget<Box>(find.byType(Box));
      final context = tester.element(find.byType(Box));
      final decoration =
          box.style.resolve(context).spec.decoration as BoxDecoration?;

      expect(decoration, isNotNull);
      expect(decoration!.border, isNotNull);
    });

    testWidgets('applies primary foreground styling to child content', (
      tester,
    ) async {
      await tester.pumpApp(
        FoxButton(
          onPressed: () {},
          variant: FoxButtonVariant.primary,
          child: Text('Primary'),
        ),
      );

      final textContext = tester.element(find.text('Primary'));
      expect(
        DefaultTextStyle.of(textContext).style.color,
        Theme.of(textContext).colorScheme.onPrimary,
      );
    });

    testWidgets('merges custom style with variant styling', (tester) async {
      await tester.pumpApp(
        FoxButton(
          onPressed: () {},
          variant: FoxButtonVariant.primary,
          style: BoxStyler().width(120),
          child: Text('Primary'),
        ),
      );

      final box = tester.widget<Box>(find.byType(Box));
      final context = tester.element(find.byType(Box));
      final spec = box.style.resolve(context).spec;
      final decoration = spec.decoration as BoxDecoration?;

      expect(decoration, isNotNull);
      expect(decoration!.color, Theme.of(context).colorScheme.primary);
      expect(spec.constraints?.minWidth, 120);
      expect(spec.constraints?.maxWidth, 120);
    });

    testWidgets('renders PushButton on macOS', (tester) async {
      final previousPlatform = debugDefaultTargetPlatformOverride;
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;

      try {
        await tester.pumpApp(
          FoxButton(onPressed: () {}, child: Text('Mac')),
        );
        await tester.pump(const Duration(milliseconds: 1));

        expect(find.byType(macos.PushButton), findsOneWidget);
      } finally {
        debugDefaultTargetPlatformOverride = previousPlatform;
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();
      }
    });

    testWidgets('renders AdaptiveButton on iOS', (tester) async {
      final previousPlatform = debugDefaultTargetPlatformOverride;
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      try {
        await tester.pumpApp(
          FoxButton(onPressed: () {}, child: Text('iOS')),
        );

        expect(find.byType(adaptive.AdaptiveButton), findsOneWidget);
      } finally {
        debugDefaultTargetPlatformOverride = previousPlatform;
      }
    });

    testWidgets('wraps Linux buttons in YaruTheme', (tester) async {
      final previousPlatform = debugDefaultTargetPlatformOverride;
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;

      try {
        await tester.pumpApp(
          FoxButton(onPressed: () {}, child: Text('Linux')),
        );

        expect(find.byType(yaru.YaruTheme), findsWidgets);
        expect(find.byType(FilledButton), findsOneWidget);
      } finally {
        debugDefaultTargetPlatformOverride = previousPlatform;
      }
    });
  });
}
