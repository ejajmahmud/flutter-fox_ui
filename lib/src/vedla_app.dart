import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fox_ui/src/platform/platform_override.dart';
import 'package:fox_ui/src/theme/app_theme.dart';
import 'package:fox_ui/src/theme/fluent_theme_resolver.dart';
import 'package:fox_ui/src/theme/macos_theme_resolver.dart';
import 'package:macos_ui/macos_ui.dart' as macos;

/// A custom MaterialApp that adapts to the platform
/// and supports platform override.
///
/// [FoxUIApp] extends MaterialApp to provide:
/// - Automatic platform-native UI rendering
/// (fluent_ui on Windows, macos_ui on macOS, etc.)
/// - Optional platform override for testing cross-platform rendering
/// - Full MaterialApp compatibility (supports router, navigator, etc.)
/// - Theme support with Material, macOS, and Fluent light/dark variants
///
/// Example:
/// ```dart
/// void main() {
///   runApp(
///     const FoxUIApp(
///       home: MyHomePage(),
///     ),
///   );
/// }
/// ```
///
/// To force a specific platform (e.g., render Windows UI on macOS):
/// ```dart
/// FoxUIApp(
///   forcePlatform: TargetPlatform.windows,
///   home: MyHomePage(),
/// )
/// ```
///
/// With router support:
/// ```dart
/// FoxUIApp.router(
///   forcePlatform: TargetPlatform.macOS,
///   routerConfig: router,
/// )
/// ```
class FoxUIApp extends MaterialApp {
  /// Creates a [FoxUIApp].
  FoxUIApp({
    super.key,
    this.forcePlatform,
    this.themeJson,
    super.home,
    super.routes,
    super.initialRoute,
    super.onGenerateRoute,
    super.onGenerateInitialRoutes,
    super.onUnknownRoute,
    super.navigatorObservers,
    TransitionBuilder? builder,
    ThemeData? theme,
    ThemeData? darkTheme,
    super.themeMode,
    macos.MacosThemeData? macosTheme,
    macos.MacosThemeData? macosDarkTheme,
    fluent.FluentThemeData? fluentTheme,
    fluent.FluentThemeData? fluentDarkTheme,
    super.title = '',
    super.locale,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    super.supportedLocales,
    super.debugShowMaterialGrid,
    super.showPerformanceOverlay,
    super.checkerboardRasterCacheImages,
    super.checkerboardOffscreenLayers,
    super.showSemanticsDebugger,
    super.debugShowCheckedModeBanner,
    super.shortcuts,
    super.actions,
    super.restorationScopeId,
    super.scrollBehavior,
  }) : super(
         theme: theme ?? ThemeDecoder.decodeTheme(themeJson, isDark: false),
         darkTheme: darkTheme ?? ThemeDecoder.decodeTheme(themeJson, isDark: true),
         localizationsDelegates: _buildLocalizationsDelegates(
           localizationsDelegates,
         ),
         builder: (context, child) => _buildAppShell(
           context,
           child,
           forcePlatform: forcePlatform,
           userBuilder: builder,
           themeMode: themeMode,
           macosTheme: macosTheme,
           macosDarkTheme: macosDarkTheme,
           fluentTheme: fluentTheme,
           fluentDarkTheme: fluentDarkTheme,
         ),
       );

  /// Creates a [FoxUIApp] that uses the [Router] instead of a [Navigator].
  FoxUIApp.router({
    super.key,
    this.forcePlatform,
    this.themeJson,
    super.routeInformationProvider,
    super.routeInformationParser,
    super.routerDelegate,
    super.routerConfig,
    super.backButtonDispatcher,
    TransitionBuilder? builder,
    ThemeData? theme,
    super.title = '',
    ThemeData? darkTheme,
    super.themeMode,
    macos.MacosThemeData? macosTheme,
    macos.MacosThemeData? macosDarkTheme,
    fluent.FluentThemeData? fluentTheme,
    fluent.FluentThemeData? fluentDarkTheme,
    super.locale,
    Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
    super.supportedLocales,
    super.debugShowMaterialGrid,
    super.showPerformanceOverlay,
    super.checkerboardRasterCacheImages,
    super.checkerboardOffscreenLayers,
    super.showSemanticsDebugger,
    super.debugShowCheckedModeBanner,
    super.shortcuts,
    super.actions,
    super.restorationScopeId,
    super.scrollBehavior,
  }) : super.router(
         theme: theme ?? ThemeDecoder.decodeTheme(themeJson, isDark: false),
         darkTheme: darkTheme ?? ThemeDecoder.decodeTheme(themeJson, isDark: true),
         localizationsDelegates: _buildLocalizationsDelegates(
           localizationsDelegates,
         ),
         builder: (context, child) => _buildAppShell(
           context,
           child,
           forcePlatform: forcePlatform,
           userBuilder: builder,
           themeMode: themeMode,
           macosTheme: macosTheme,
           macosDarkTheme: macosDarkTheme,
           fluentTheme: fluentTheme,
           fluentDarkTheme: fluentDarkTheme,
         ),
       );

  /// Forces the app to render as a specific platform's UI.
  ///
  /// If null (default), uses the actual platform detected by Flutter.
  /// Set this to test cross-platform rendering, e.g.:
  /// - Set to [TargetPlatform.windows] to render Windows (Fluent) UI on any platform
  /// - Set to [TargetPlatform.macOS] to render macOS native UI on any platform
  /// - Set to [TargetPlatform.iOS] to render iOS Cupertino/Adaptive UI on any platform
  final TargetPlatform? forcePlatform;

  /// Optional JSON configuration for styling the app
  final Map<String, dynamic>? themeJson;
}

Iterable<LocalizationsDelegate<dynamic>> _buildLocalizationsDelegates(
  Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
) sync* {
  if (localizationsDelegates != null) {
    yield* localizationsDelegates;
  }

  yield fluent.FluentLocalizations.delegate;
}

Widget _buildAppShell(
  BuildContext context,
  Widget? child, {
  required TargetPlatform? forcePlatform,
  required TransitionBuilder? userBuilder,
  required ThemeMode? themeMode,
  required macos.MacosThemeData? macosTheme,
  required macos.MacosThemeData? macosDarkTheme,
  required fluent.FluentThemeData? fluentTheme,
  required fluent.FluentThemeData? fluentDarkTheme,
}) {
  return PlatformOverride(
    forcePlatform: forcePlatform,
    child: Builder(
      builder: (context) {
        final platform = PlatformOverride.of(context);
        final routeChild = child ?? const SizedBox.shrink();
        final builtChild = Builder(
          builder: (context) =>
              userBuilder?.call(context, routeChild) ?? routeChild,
        );

        if (platform == TargetPlatform.macOS) {
          return ensureMacosTheme(
            context,
            builtChild,
            themeMode: themeMode,
            theme: macosTheme,
            darkTheme: macosDarkTheme,
          );
        }

        if (kIsWeb || platform == TargetPlatform.windows) {
          return ensureFluentTheme(
            context,
            builtChild,
            themeMode: themeMode,
            theme: fluentTheme,
            darkTheme: fluentDarkTheme,
          );
        }

        return _MaterialThemeDefaults(child: builtChild);
      },
    ),
  );
}

class _MaterialThemeDefaults extends StatelessWidget {
  const _MaterialThemeDefaults({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle =
        theme.textTheme.bodyMedium ??
        TextStyle(color: theme.colorScheme.onSurface);

    return DefaultTextStyle(
      style: textStyle,
      child: IconTheme.merge(
        data: IconThemeData(
          color: textStyle.color ?? theme.colorScheme.onSurface,
        ),
        child: child,
      ),
    );
  }
}
