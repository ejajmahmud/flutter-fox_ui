import 'dart:ui';

import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fox_ui/src/platform/platform_override.dart';
import 'package:fox_ui/src/theme/fluent_theme_resolver.dart';
import 'package:fox_ui/src/theme/macos_theme_resolver.dart';
import 'package:macos_ui/macos_ui.dart' as macos;
import 'package:yaru/yaru.dart' as yaru;

/// A single action button for use in [FoxTitleBar].
class FoxTitleBarAction {
  /// Creates a [FoxTitleBarAction].
  const FoxTitleBarAction({
    required this.icon,
    required this.label,
    this.onPressed,
  });

  /// The icon displayed for this action.
  final Widget icon;

  /// Tooltip / accessible label for this action.
  final String label;

  /// Called when the action is triggered.
  final VoidCallback? onPressed;
}

/// {@template title_bar}
/// A platform-adaptive title bar / header bar.
///
/// On macOS this renders as a [macos.TitleBar]. On Windows it renders as a
/// Fluent-styled header. On Linux and other platforms it renders as a
/// Material [AppBar].
/// {@endtemplate}
class FoxTitleBar extends StatelessWidget {
  /// {@macro title_bar}
  const FoxTitleBar({
    super.key,
    this.title,
    this.actions = const [],
    this.backgroundColor,
    this.glassStyle = false,
  });

  /// Text shown in the center / leading edge of the bar.
  final String? title;

  /// Action icon buttons displayed at the trailing edge.
  final List<FoxTitleBarAction> actions;

  /// Override background color. Defaults to the platform theme's surface.
  final Color? backgroundColor;

  /// Whether to apply a glassmorphism effect.
  final bool glassStyle;

  @override
  Widget build(BuildContext context) {
    final platform = PlatformOverride.of(context);
    Widget titleBarWidget;

    if (kIsWeb || platform == TargetPlatform.windows) {
      titleBarWidget = ensureFluentTheme(context, Builder(builder: _buildFluentTitleBar));
    } else if (platform == TargetPlatform.macOS) {
      titleBarWidget = ensureMacosTheme(
        context,
        Builder(builder: _buildMacosTitleBar),
      );
    } else if (platform == TargetPlatform.linux) {
      titleBarWidget = yaru.YaruTheme(child: Builder(builder: _buildMaterialTitleBar));
    } else {
      titleBarWidget = Builder(builder: _buildMaterialTitleBar);
    }

    if (glassStyle) {
      return ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: ColoredBox(
            color: backgroundColor?.withAlpha(50) ?? Theme.of(context).colorScheme.surface.withAlpha(50),
            child: titleBarWidget,
          ),
        ),
      );
    }

    return titleBarWidget;
  }

  Widget _buildFluentTitleBar(BuildContext context) {
      final theme = fluent.FluentTheme.of(context);
      return Container(
        height: 40,
        color: glassStyle ? Colors.transparent : (backgroundColor ?? theme.scaffoldBackgroundColor),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            if (title != null)
              Text(
                title!,
                style: theme.typography.bodyStrong ?? const TextStyle(),
              ),
            const Spacer(),
            ...actions.map(
              (a) => fluent.Tooltip(
                message: a.label,
                child: fluent.IconButton(
                  icon: a.icon,
                  onPressed: a.onPressed,
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildMacosTitleBar(BuildContext context) {
      if (actions.isEmpty) {
        return macos.TitleBar(
          title: title != null ? Text(title!) : null,
          decoration: (backgroundColor != null || glassStyle)
              ? BoxDecoration(color: glassStyle ? Colors.transparent : backgroundColor)
              : null,
        );
      }
      return Container(
        height: macos.kTitleBarHeight,
        decoration: BoxDecoration(
          color: glassStyle ? Colors.transparent : (backgroundColor ?? macos.MacosTheme.of(context).canvasColor),
          border: const Border(
            bottom: BorderSide(color: Color(0x33000000), width: 0.5),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            if (title != null)
              Text(
                title!,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            const Spacer(),
            ...actions.map(
              (a) => macos.MacosTooltip(
                message: a.label,
                child: macos.MacosIconButton(
                  icon: a.icon,
                  onPressed: a.onPressed,
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget _buildMaterialTitleBar(BuildContext context) {
      return AppBar(
        title: title != null ? Text(title!) : null,
        backgroundColor: glassStyle ? Colors.transparent : backgroundColor,
        elevation: glassStyle ? 0 : null,
        actions: actions
            .map(
              (a) => IconButton(
                icon: a.icon,
                onPressed: a.onPressed,
                tooltip: a.label,
              ),
            )
            .toList(),
      );
    }
}
