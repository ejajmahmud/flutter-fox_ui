import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as material;
import 'package:fox_ui/src/platform/platform_override.dart';
import 'package:fox_ui/src/theme/fluent_theme_resolver.dart';
import 'package:fox_ui/src/theme/macos_theme_resolver.dart';
import 'package:fox_ui/src/widgets/components/fox_toolbar.dart';
import 'package:fox_ui/src/widgets/layout/fox_sidebar.dart';
import 'package:macos_ui/macos_ui.dart' as macos;
import 'package:yaru/yaru.dart' as yaru;

/// Visual variants for [FoxScaffold].
enum FoxScaffoldVariant {
  /// The standard native appearance (macOS/Windows/etc)
  native,

  /// A basic, transparent scaffold.
  transparent,
}

/// {@template scaffold}
/// A platform-adaptive scaffold that provides the top-level page structure.
///
/// Accepts an optional [toolBar] rendered in the platform-native location and
/// an optional [sidebar] placed on the leading edge.
/// {@endtemplate}
class FoxScaffold extends material.StatelessWidget {
  /// {@macro scaffold}
  const FoxScaffold({
    required this.body,
    this.title,
    FoxToolBar? toolBar,
    FoxToolBar? toolbar,
    this.sidebar,
    this.backgroundColor,
    this.variant = FoxScaffoldVariant.native,
    super.key,
  }) : assert(
         toolBar == null || toolbar == null,
         'Use either toolBar or toolbar, not both.',
       ),
       toolBar = toolBar ?? toolbar;

  /// The primary content of the page.
  final material.Widget body;

  /// Optional title shown in the platform's header / title bar area.
  final material.Widget? title;

  /// Optional platform-adaptive toolbar.
  final FoxToolBar? toolBar;

  /// Optional sidebar widget placed on the leading edge.
  final FoxSidebar? sidebar;

  /// Background color override.
  final material.Color? backgroundColor;

  /// The visual variant of the scaffold.
  final FoxScaffoldVariant variant;

  @override
  material.Widget build(material.BuildContext context) {
    if (variant == FoxScaffoldVariant.transparent) {
      return material.Scaffold(
        appBar: toolBar != null
            ? material.PreferredSize(
                preferredSize: const material.Size.fromHeight(
                  material.kToolbarHeight,
                ),
                child: toolBar!,
              )
            : null,
        body: body,
        backgroundColor: material.Colors.transparent,
      );
    }

    final platform = PlatformOverride.of(context);

    if (kIsWeb || platform == material.TargetPlatform.windows) {
      return ensureFluentTheme(
        context,
        _buildMaterialSnackBarHost(_buildFluentScaffold()),
      );
    }

    if (platform == material.TargetPlatform.macOS) {
      return ensureMacosTheme(
        context,
        _buildMaterialSnackBarHost(_buildMacosScaffold()),
      );
    }

    if (platform == material.TargetPlatform.linux) {
      return yaru.YaruTheme(
        child: material.Builder(builder: _buildMaterialScaffold),
      );
    }

    return material.Builder(builder: _buildMaterialScaffold);
  }

  material.Widget _buildFluentScaffold() {
    final page = fluent.ScaffoldPage(
      header:
          toolBar ?? (title != null ? fluent.PageHeader(title: title) : null),
      content: body,
      padding: material.EdgeInsets.zero,
    );

    if (sidebar == null) {
      return page;
    }

    return material.Row(
      children: [
        material.SizedBox(width: 240, child: sidebar),
        material.Expanded(child: page),
      ],
    );
  }

  material.Widget _buildMacosScaffold() {
    return macos.MacosScaffold(
      backgroundColor: backgroundColor,
      toolBar: toolBar?.toMacosToolBar(),
      children: [
        if (sidebar != null)
          macos.ResizablePane(
            minSize: 180,
            startSize: 240,
            windowBreakpoint: 700,
            resizableSide: macos.ResizableSide.right,
            builder: (context, scrollController) => sidebar!,
          ),
        macos.ContentArea(builder: (context, scrollController) => body),
      ],
    );
  }

  material.Widget _buildMaterialScaffold(material.BuildContext context) {
    final content = sidebar == null
        ? body
        : material.Row(
            children: [
              material.SizedBox(width: 280, child: sidebar),
              material.Expanded(child: body),
            ],
          );

    return material.Scaffold(
      backgroundColor: backgroundColor,
      appBar: toolBar == null && title != null
          ? material.AppBar(title: title)
          : null,
      body: toolBar == null
          ? content
          : material.Column(
              children: [
                toolBar!,
                material.Expanded(child: content),
              ],
            ),
    );
  }

  material.Widget _buildMaterialSnackBarHost(material.Widget child) {
    return material.Scaffold(
      backgroundColor: material.Colors.transparent,
      body: child,
    );
  }
}
