import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

/// Resolves the Fluent theme for the current [themeMode] and system brightness.
fluent.FluentThemeData resolveFluentTheme(
  BuildContext context, {
  ThemeMode? themeMode,
  fluent.FluentThemeData? theme,
  fluent.FluentThemeData? darkTheme,
}) {
  final useDarkTheme = _useDarkTheme(context, themeMode);
  if (useDarkTheme) {
    return darkTheme ?? fluent.FluentThemeData.dark();
  }

  return theme ?? fluent.FluentThemeData();
}

/// Returns [child] under a Fluent theme.
Widget ensureFluentTheme(
  BuildContext context,
  Widget child, {
  ThemeMode? themeMode,
  fluent.FluentThemeData? theme,
  fluent.FluentThemeData? darkTheme,
}) {
  final inheritedTheme = fluent.FluentTheme.maybeOf(context);
  final shouldUseInheritedTheme =
      inheritedTheme != null && theme == null && darkTheme == null;
  if (shouldUseInheritedTheme) {
    return child;
  }

  final data = resolveFluentTheme(
    context,
    themeMode: themeMode,
    theme: theme,
    darkTheme: darkTheme,
  );
  return fluent.FluentTheme(data: data, child: child);
}

bool _useDarkTheme(BuildContext context, ThemeMode? themeMode) {
  final mode = themeMode ?? ThemeMode.system;
  final brightness =
      MediaQuery.maybeOf(context)?.platformBrightness ??
      WidgetsBinding.instance.platformDispatcher.platformBrightness;

  return mode == ThemeMode.dark ||
      (mode == ThemeMode.system && brightness == Brightness.dark);
}
