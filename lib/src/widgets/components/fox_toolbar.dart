import 'dart:ui';

import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fox_ui/src/platform/platform_override.dart';
import 'package:fox_ui/src/theme/fluent_theme_resolver.dart';
import 'package:fox_ui/src/theme/macos_theme_resolver.dart';
import 'package:macos_ui/macos_ui.dart' as macos;
import 'package:yaru/yaru.dart' as yaru;

const _defaultToolBarHeight = 52.0;
const _defaultToolBarTitleWidth = 150.0;
const _toolBarItemWidth = 32.0;

/// An item that can be displayed in a [FoxToolBar].
abstract class ToolBarItem {
  /// Creates a toolbar item.
  const ToolBarItem({this.key});

  /// The key used by the rendered platform toolbar item.
  final Key? key;

  /// Converts this item to a macOS toolbar item.
  macos.ToolbarItem toMacosToolBarItem();

  /// Converts this item to a Fluent command bar item.
  fluent.CommandBarItem toFluentCommandBarItem();

  /// Builds this item for Material-like platforms.
  Widget buildMaterial(BuildContext context);
}

/// A platform-adaptive toolbar.
class FoxToolBar extends StatelessWidget {
  /// Creates a platform-adaptive toolbar.
  const FoxToolBar({
    super.key,
    this.height = _defaultToolBarHeight,
    this.alignment = Alignment.center,
    this.title,
    this.titleWidth = _defaultToolBarTitleWidth,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.decoration,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.actions = const [],
    this.centerTitle = false,
    this.dividerColor,
    this.allowWallpaperTintingOverrides = true,
    this.enableBlur = false,
    this.glassStyle = false,
  });

  /// The toolbar height.
  final double height;

  /// Aligns toolbar content.
  final Alignment alignment;

  /// The toolbar title.
  final Widget? title;

  /// The width reserved for the toolbar title on macOS.
  final double titleWidth;

  /// Toolbar padding.
  final EdgeInsets padding;

  /// Decoration painted behind the toolbar.
  final BoxDecoration? decoration;

  /// Widget displayed before the title.
  final Widget? leading;

  /// Whether macOS should infer a leading back button when possible.
  final bool automaticallyImplyLeading;

  /// Toolbar actions.
  final List<ToolBarItem> actions;

  /// Whether the title should be centered.
  final bool centerTitle;

  /// Color of the toolbar divider.
  final Color? dividerColor;

  /// Whether macOS toolbar wallpaper tinting overrides are allowed.
  final bool allowWallpaperTintingOverrides;

  /// Whether the macOS toolbar should blur its background.
  final bool enableBlur;

  /// Whether to apply a glassmorphism effect across all platforms.
  final bool glassStyle;

  /// Converts this toolbar to macOS' native toolbar widget.
  macos.ToolBar toMacosToolBar() {
    return macos.ToolBar(
      key: key,
      height: height,
      alignment: alignment,
      title: title,
      titleWidth: titleWidth,
      padding: padding,
      decoration: decoration,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      actions: actions.map((item) => item.toMacosToolBarItem()).toList(),
      centerTitle: centerTitle,
      dividerColor: dividerColor,
      allowWallpaperTintingOverrides: allowWallpaperTintingOverrides,
      enableBlur: glassStyle || enableBlur,
    );
  }

  @override
  Widget build(BuildContext context) {
    final platform = PlatformOverride.of(context);
    Widget toolbarWidget;

    if (kIsWeb || platform == TargetPlatform.windows) {
      toolbarWidget = ensureFluentTheme(context, Builder(builder: _buildFluentToolBar));
    } else if (platform == TargetPlatform.macOS) {
      toolbarWidget = ensureMacosTheme(context, toMacosToolBar());
    } else if (platform == TargetPlatform.linux) {
      toolbarWidget = yaru.YaruTheme(child: Builder(builder: _buildMaterialToolBar));
    } else {
      toolbarWidget = Builder(builder: _buildMaterialToolBar);
    }

    if (glassStyle && platform != TargetPlatform.macOS) {
      return ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: ColoredBox(
            color: decoration?.color?.withAlpha(50) ?? Theme.of(context).colorScheme.surface.withAlpha(50),
            child: toolbarWidget,
          ),
        ),
      );
    }

    return toolbarWidget;
  }

  Widget _buildFluentToolBar(BuildContext context) {
    final theme = fluent.FluentTheme.of(context);
    final title = this.title;

    return Container(
      height: height,
      alignment: alignment,
      padding: padding,
      decoration: BoxDecoration(
        color: glassStyle ? Colors.transparent : (decoration?.color ?? theme.scaffoldBackgroundColor),
        border: Border(
          bottom: BorderSide(color: dividerColor ?? theme.inactiveColor),
        ),
      ),
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 8),
          ],
          if (title != null)
            SizedBox(
              width: titleWidth,
              child: DefaultTextStyle.merge(
                style: theme.typography.bodyStrong,
                child: title,
              ),
            ),
          if (centerTitle) const Spacer(),
          Expanded(
            child: actions.isEmpty
                ? const SizedBox.shrink()
                : fluent.CommandBar(
                    primaryItems: actions
                        .map((item) => item.toFluentCommandBarItem())
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialToolBar(BuildContext context) {
    final theme = Theme.of(context);
    final title = this.title;

    return Container(
      height: height,
      alignment: alignment,
      padding: padding,
      decoration:
          decoration?.copyWith(color: glassStyle ? Colors.transparent : decoration?.color) ??
          BoxDecoration(
            color: glassStyle ? Colors.transparent : theme.colorScheme.surface,
            border: Border(
              bottom: BorderSide(color: dividerColor ?? theme.dividerColor),
            ),
          ),
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 8),
          ],
          if (title != null)
            SizedBox(
              width: titleWidth,
              child: DefaultTextStyle.merge(
                style: theme.textTheme.titleMedium,
                child: title,
              ),
            ),
          if (centerTitle) const Spacer(),
          const Spacer(),
          ...actions.map((item) => item.buildMaterial(context)),
        ],
      ),
    );
  }
}

/// Backwards-compatible spelling for [FoxToolBar].
class Toolbar extends FoxToolBar {
  /// Creates a platform-adaptive toolbar.
  const Toolbar({
    super.key,
    super.height,
    super.alignment,
    super.title,
    super.titleWidth,
    super.padding,
    super.decoration,
    super.leading,
    super.automaticallyImplyLeading,
    super.actions,
    super.centerTitle,
    super.dividerColor,
    super.allowWallpaperTintingOverrides,
    super.enableBlur,
    super.glassStyle,
  });
}

/// Backwards-compatible icon action for [Toolbar].
class ToolbarAction extends FoxToolBarIconButton {
  /// Creates an icon action.
  const ToolbarAction({
    required super.icon,
    required super.label,
    super.onPressed,
    String? tooltip,
    super.key,
  }) : super(showLabel: false, tooltipMessage: tooltip);
}

/// A button suitable for use in a [FoxToolBar].
class FoxToolBarButton extends ToolBarItem {
  /// Creates a toolbar button.
  const FoxToolBarButton({
    required this.child,
    this.onPressed,
    this.label,
    this.tooltipMessage,
    this.padding,
    super.key,
  });

  /// The button content.
  final Widget child;

  /// Called when the button is pressed.
  final VoidCallback? onPressed;

  /// The button label used for toolbar overflow menus and semantics.
  final String? label;

  /// Optional tooltip text.
  final String? tooltipMessage;

  /// The button padding.
  final EdgeInsetsGeometry? padding;

  String? get _overflowLabel => label ?? tooltipMessage;

  @override
  macos.ToolbarItem toMacosToolBarItem() {
    final overflowLabel = _overflowLabel;
    return macos.CustomToolbarItem(
      key: key,
      inToolbarBuilder: (context) {
        return macos.PushButton(
          key: key,
          controlSize: macos.ControlSize.small,
          padding: padding,
          onPressed: onPressed,
          semanticLabel: label ?? tooltipMessage,
          child: child,
        );
      },
      inOverflowedBuilder: overflowLabel == null
          ? null
          : (context) {
              return macos.ToolbarOverflowMenuItem(
                label: overflowLabel,
                onPressed: onPressed,
              );
            },
      tooltipMessage: tooltipMessage,
    );
  }

  @override
  fluent.CommandBarItem toFluentCommandBarItem() {
    final overflowLabel = _overflowLabel;
    return fluent.CommandBarBuilderItem(
      key: key,
      wrappedItem: fluent.CommandBarButton(
        onPressed: onPressed,
        label: overflowLabel == null ? null : Text(overflowLabel),
        tooltip: tooltipMessage,
      ),
      builder: (context, displayMode, builtChild) {
        if (displayMode == fluent.CommandBarItemDisplayMode.inSecondary) {
          return overflowLabel == null ? const SizedBox.shrink() : builtChild;
        }

        Widget button = fluent.Button(
          key: key,
          onPressed: onPressed,
          child: child,
        );
        final tooltip = tooltipMessage;
        if (tooltip != null) {
          button = Tooltip(message: tooltip, child: button);
        }
        return fluent.CommandBarItemInPrimary(child: button);
      },
    );
  }

  @override
  Widget buildMaterial(BuildContext context) {
    final button = TextButton(
      key: key,
      onPressed: onPressed,
      style: padding == null
          ? null
          : ButtonStyle(padding: WidgetStatePropertyAll(padding)),
      child: child,
    );

    final tooltip = tooltipMessage;
    if (tooltip == null) {
      return button;
    }
    return Tooltip(message: tooltip, child: button);
  }
}

/// An icon button suitable for use in a [FoxToolBar].
class FoxToolBarIconButton extends ToolBarItem {
  /// Creates a toolbar icon button.
  const FoxToolBarIconButton({
    required this.label,
    required this.icon,
    this.onPressed,
    this.showLabel = false,
    this.tooltipMessage,
    super.key,
  });

  /// The button label.
  final String label;

  /// The button icon.
  final Widget icon;

  /// Called when the button is pressed.
  final VoidCallback? onPressed;

  /// Whether to show the label under/next to the icon when supported.
  final bool showLabel;

  /// Optional tooltip text.
  final String? tooltipMessage;

  @override
  macos.ToolbarItem toMacosToolBarItem() {
    return macos.ToolBarIconButton(
      key: key,
      label: label,
      icon: icon,
      onPressed: onPressed,
      showLabel: showLabel,
      tooltipMessage: tooltipMessage,
    );
  }

  @override
  fluent.CommandBarItem toFluentCommandBarItem() {
    return fluent.CommandBarButton(
      key: key,
      onPressed: onPressed,
      icon: icon,
      label: showLabel ? Text(label) : null,
      tooltip: tooltipMessage ?? label,
    );
  }

  @override
  Widget buildMaterial(BuildContext context) {
    final button = IconButton(
      key: key,
      icon: icon,
      onPressed: onPressed,
      tooltip: tooltipMessage ?? label,
    );
    if (!showLabel) {
      return button;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          button,
          Text(label, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}

/// A pull-down button suitable for use in a [FoxToolBar].
class FoxToolBarPullDownButton extends ToolBarItem {
  /// Creates a toolbar pull-down button.
  const FoxToolBarPullDownButton({
    required this.label,
    required this.icon,
    required this.items,
    this.tooltipMessage,
    super.key,
  });

  /// The button label.
  final String label;

  /// The button icon.
  final IconData icon;

  /// macOS pull-down menu entries.
  final List<macos.MacosPulldownMenuEntry>? items;

  /// Optional tooltip text.
  final String? tooltipMessage;

  @override
  macos.ToolbarItem toMacosToolBarItem() {
    return macos.ToolBarPullDownButton(
      key: key,
      label: label,
      icon: icon,
      items: items,
      tooltipMessage: tooltipMessage,
    );
  }

  @override
  fluent.CommandBarItem toFluentCommandBarItem() {
    return fluent.CommandBarButton(
      key: key,
      onPressed: null,
      icon: Icon(icon),
      label: Text(label),
      tooltip: tooltipMessage ?? label,
    );
  }

  @override
  Widget buildMaterial(BuildContext context) {
    return IconButton(
      key: key,
      icon: Icon(icon),
      onPressed: null,
      tooltip: tooltipMessage ?? label,
    );
  }
}

/// Blank space between toolbar items.
class ToolBarSpacer extends ToolBarItem {
  /// Creates a toolbar spacer.
  const ToolBarSpacer({this.spacerUnits = 1, super.key});

  /// Spacer width in toolbar item units.
  final double spacerUnits;

  @override
  macos.ToolbarItem toMacosToolBarItem() {
    return macos.ToolBarSpacer(key: key, spacerUnits: spacerUnits);
  }

  @override
  fluent.CommandBarItem toFluentCommandBarItem() {
    return fluent.CommandBarBuilderItem(
      key: key,
      wrappedItem: const fluent.CommandBarSeparator(color: Colors.transparent),
      builder: (context, displayMode, child) {
        if (displayMode == fluent.CommandBarItemDisplayMode.inSecondary) {
          return const SizedBox.shrink();
        }
        return SizedBox(width: spacerUnits * _toolBarItemWidth);
      },
    );
  }

  @override
  Widget buildMaterial(BuildContext context) {
    return SizedBox(width: spacerUnits * _toolBarItemWidth);
  }
}

/// A divider between toolbar items.
class ToolBarDivider extends ToolBarItem {
  /// Creates a toolbar divider.
  const ToolBarDivider({this.padding = const EdgeInsets.all(6), super.key});

  /// Padding around the divider.
  final EdgeInsets? padding;

  @override
  macos.ToolbarItem toMacosToolBarItem() {
    return macos.ToolBarDivider(key: key, padding: padding);
  }

  @override
  fluent.CommandBarItem toFluentCommandBarItem() {
    return fluent.CommandBarSeparator(key: key);
  }

  @override
  Widget buildMaterial(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: const VerticalDivider(width: 1),
    );
  }
}

/// A custom widget in a [FoxToolBar].
class CustomToolBarItem extends ToolBarItem {
  /// Creates a custom toolbar item.
  const CustomToolBarItem({
    required this.inToolbarBuilder,
    this.inOverflowedBuilder,
    this.tooltipMessage,
    super.key,
  });

  /// Builds the widget displayed in the toolbar.
  final WidgetBuilder inToolbarBuilder;

  /// Builds the widget displayed in overflow menus.
  final WidgetBuilder? inOverflowedBuilder;

  /// Optional tooltip text.
  final String? tooltipMessage;

  @override
  macos.ToolbarItem toMacosToolBarItem() {
    return macos.CustomToolbarItem(
      key: key,
      inToolbarBuilder: inToolbarBuilder,
      inOverflowedBuilder: inOverflowedBuilder,
      tooltipMessage: tooltipMessage,
    );
  }

  @override
  fluent.CommandBarItem toFluentCommandBarItem() {
    return fluent.CommandBarBuilderItem(
      key: key,
      wrappedItem: const fluent.CommandBarSeparator(color: Colors.transparent),
      builder: (context, displayMode, child) {
        if (displayMode == fluent.CommandBarItemDisplayMode.inSecondary) {
          return inOverflowedBuilder?.call(context) ?? const SizedBox.shrink();
        }
        final widget = inToolbarBuilder(context);
        final tooltip = tooltipMessage;
        if (tooltip == null) {
          return widget;
        }
        return Tooltip(message: tooltip, child: widget);
      },
    );
  }

  @override
  Widget buildMaterial(BuildContext context) {
    final widget = inToolbarBuilder(context);
    final tooltip = tooltipMessage;
    if (tooltip == null) {
      return widget;
    }
    return Tooltip(message: tooltip, child: widget);
  }
}

/// Backwards-compatible spelling for [CustomToolBarItem].
class CustomToolbarItem extends CustomToolBarItem {
  /// Creates a custom toolbar item.
  const CustomToolbarItem({
    required super.inToolbarBuilder,
    super.inOverflowedBuilder,
    super.tooltipMessage,
    super.key,
  });
}
