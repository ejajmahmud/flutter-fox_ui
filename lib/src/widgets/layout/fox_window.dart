import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fox_ui/src/platform/platform_override.dart';
import 'package:fox_ui/src/theme/fluent_theme_resolver.dart';
import 'package:fox_ui/src/theme/macos_theme_resolver.dart';
import 'package:fox_ui/src/widgets/components/fox_title_bar.dart';
import 'package:fox_ui/src/widgets/layout/fox_sidebar.dart';
import 'package:macos_ui/macos_ui.dart' as macos;
import 'package:yaru/yaru.dart' as yaru;

/// {@template window}
/// A platform-adaptive application window.
///
/// Place [FoxWindow] at the root of your widget tree. On macOS it wraps its
/// child with [macos.MacosWindow] to enable native window chrome, vibrancy
/// effects, and sidebar integration. On Windows it applies Fluent UI styling.
/// On Linux and other platforms it applies appropriate platform theming.
/// {@endtemplate}
class FoxWindow extends StatelessWidget {
  /// {@macro window}
  const FoxWindow({
    required this.child,
    this.titleBar,
    this.sidebar,
    this.endSidebar,
    this.backgroundColor,
    this.disableWallpaperTinting = false,
    this.sidebarState = macos.NSVisualEffectViewState.followsWindowActiveState,
    super.key,
  });

  /// The window content, typically a [Scaffold].
  final Widget child;

  /// Optional title bar shown at the top of the window.
  ///
  /// On macOS the [FoxTitleBar.title] is passed to [macos.TitleBar].
  final FoxTitleBar? titleBar;

  /// Optional leading sidebar.
  ///
  /// On macOS this is integrated with the native window chrome.
  /// On other platforms it's rendered as a side panel.
  final FoxSidebar? sidebar;

  /// Optional trailing sidebar (macOS primarily).
  final FoxSidebar? endSidebar;

  /// Background color override.
  final Color? backgroundColor;

  /// Disables wallpaper tinting on macOS.
  final bool disableWallpaperTinting;

  /// Controls the macOS sidebar vibrancy state.
  final macos.NSVisualEffectViewState sidebarState;

  @override
  Widget build(BuildContext context) {
    final platform = PlatformOverride.of(context);

    if (kIsWeb || platform == TargetPlatform.windows) {
      return ensureFluentTheme(context, _buildFluentWindow());
    }

    if (platform == TargetPlatform.macOS) {
      return ensureMacosTheme(context, _buildMacosWindow());
    }

    if (platform == TargetPlatform.linux) {
      return yaru.YaruTheme(child: _buildLinuxWindow());
    }

    return _buildMaterialWindow();
  }

  Widget _buildFluentWindow() {
    final titleBar = this.titleBar;
    final content = sidebar != null
        ? Row(
            children: [
              SizedBox(
                width: 240,
                child: sidebar,
              ),
              Expanded(child: child),
            ],
          )
        : child;

    return Column(
      children: [
        ?titleBar,
        Expanded(child: content),
      ],
    );
  }

  Widget _buildMacosWindow() {
    final titleBar = this.titleBar;
    final sidebar = this.sidebar;
    final endSidebar = this.endSidebar;

    return macos.MacosWindow(
      backgroundColor: backgroundColor,
      disableWallpaperTinting: disableWallpaperTinting,
      sidebarState: sidebarState,
      sidebar: sidebar?.toMacosSidebar(),
      endSidebar: endSidebar?.toMacosSidebar(),
      titleBar: titleBar != null
          ? macos.TitleBar(title: Text(titleBar.title ?? ''))
          : null,
      child: Column(
        children: [
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildLinuxWindow() {
    final titleBar = this.titleBar;
    final content = sidebar != null
        ? Row(
            children: [
              SizedBox(
                width: 240,
                child: sidebar,
              ),
              Expanded(child: child),
            ],
          )
        : child;

    return Column(
      children: [
        ?titleBar,
        Expanded(child: content),
      ],
    );
  }

  Widget _buildMaterialWindow() {
    final titleBar = this.titleBar;
    final content = sidebar != null
        ? Row(
            children: [
              SizedBox(
                width: 240,
                child: sidebar,
              ),
              Expanded(child: child),
            ],
          )
        : child;

    return Column(
      children: [
        ?titleBar,
        Expanded(child: content),
      ],
    );
  }
}

/// Platform-neutral access to window sidebar state and controls.
class WindowScope {
  const WindowScope._(this._macosScope);

  final macos.MacosWindowScope? _macosScope;

  /// Returns the closest window scope, or a no-op scope when none exists.
  // ignore: prefer_constructors_over_static_methods
  static WindowScope of(BuildContext context) {
    return WindowScope._(macos.MacosWindowScope.maybeOf(context));
  }

  /// Returns the closest window scope when one exists.
  static WindowScope? maybeOf(BuildContext context) {
    final scope = macos.MacosWindowScope.maybeOf(context);
    return scope == null ? null : WindowScope._(scope);
  }

  /// Whether the leading sidebar is currently shown.
  bool get isSidebarShown => _macosScope?.isSidebarShown ?? false;

  /// Whether the trailing sidebar is currently shown.
  bool get isEndSidebarShown => _macosScope?.isEndSidebarShown ?? false;

  /// Toggles the leading sidebar when the platform window supports it.
  void toggleSidebar() {
    _macosScope?.toggleSidebar();
  }

  /// Toggles the trailing sidebar when the platform window supports it.
  void toggleEndSidebar() {
    _macosScope?.toggleEndSidebar();
  }
}
