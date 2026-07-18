import 'package:flutter/material.dart';

import 'package:macos_ui/macos_ui.dart' as macos;

/// Resolves the macOS theme for the current [themeMode] and system brightness.
macos.MacosThemeData resolveMacosTheme(
  BuildContext context, {
  ThemeMode? themeMode,
  macos.MacosThemeData? theme,
  macos.MacosThemeData? darkTheme,
}) {
  final useDarkTheme = _useDarkTheme(context, themeMode);
  if (useDarkTheme) {
    return darkTheme ?? macos.MacosThemeData.dark();
  }

  return theme ?? macos.MacosThemeData.light();
}

/// Returns [child] under a macOS theme and text/icon defaults.
Widget ensureMacosTheme(
  BuildContext context,
  Widget child, {
  ThemeMode? themeMode,
  macos.MacosThemeData? theme,
  macos.MacosThemeData? darkTheme,
}) {
  final inheritedTheme = macos.MacosTheme.maybeOf(context);
  final shouldUseInheritedTheme =
      inheritedTheme != null && theme == null && darkTheme == null;
  final data = shouldUseInheritedTheme
      ? inheritedTheme
      : resolveMacosTheme(
          context,
          themeMode: themeMode,
          theme: theme,
          darkTheme: darkTheme,
        );

  final themedChild = _MacosThemeDefaults(data: data, child: child);
  if (shouldUseInheritedTheme) {
    return themedChild;
  }

  return macos.MacosTheme(data: data, child: themedChild);
}

bool _useDarkTheme(BuildContext context, ThemeMode? themeMode) {
  final mode = themeMode ?? ThemeMode.system;
  final brightness =
      MediaQuery.maybeOf(context)?.platformBrightness ??
      WidgetsBinding.instance.platformDispatcher.platformBrightness;

  return mode == ThemeMode.dark ||
      (mode == ThemeMode.system && brightness == Brightness.dark);
}

class _MacosThemeDefaults extends StatelessWidget {
  const _MacosThemeDefaults({required this.data, required this.child});

  final macos.MacosThemeData data;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: data.typography.body,
      child: IconTheme.merge(
        data: IconThemeData(color: data.typography.body.color),
        child: child,
      ),
    );
  }
}
