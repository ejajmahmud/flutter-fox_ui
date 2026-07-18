import 'dart:ui';

import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fox_ui/src/platform/platform_override.dart';
import 'package:fox_ui/src/theme/fluent_theme_resolver.dart';
import 'package:fox_ui/src/theme/macos_theme_resolver.dart';
import 'package:yaru/yaru.dart' as yaru;

/// A single tab entry for [FoxTabView].
class FoxTab {
  /// Creates a [FoxTab].
  const FoxTab({required this.label, required this.body, this.icon});

  /// The tab label, typically a [Text].
  final Widget label;

  /// The content shown when this tab is active.
  final Widget body;

  /// Optional icon shown alongside [label].
  final Widget? icon;
}

/// {@template tab_view}
/// A platform-adaptive tab view.
/// {@endtemplate}
class FoxTabView extends StatefulWidget {
  /// {@macro tab_view}
  const FoxTabView({
    required this.tabs,
    this.initialIndex = 0,
    this.onTabChanged,
    this.glassStyle = false,
    super.key,
  });

  /// The list of tabs to display.
  final List<FoxTab> tabs;

  /// The tab selected on first render.
  final int initialIndex;

  /// Called when the user selects a different tab.
  final ValueChanged<int>? onTabChanged;

  /// Whether to apply a glassmorphism effect.
  final bool glassStyle;

  @override
  State<FoxTabView> createState() => _FoxTabViewState();
}

class _FoxTabViewState extends State<FoxTabView>
    with SingleTickerProviderStateMixin {
  late int _currentIndex;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _tabController = TabController(
      initialIndex: _currentIndex,
      length: widget.tabs.length,
      vsync: this,
    );
    _tabController.addListener(_onTabChange);
  }

  void _onTabChange() {
    if (!_tabController.indexIsChanging) {
      setState(() => _currentIndex = _tabController.index);
      widget.onTabChanged?.call(_tabController.index);
    }
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_onTabChange)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final platform = PlatformOverride.of(context);
    Widget tabWidget;

    if (kIsWeb || platform == TargetPlatform.windows) {
      tabWidget = ensureFluentTheme(context, _buildFluentTabView());
    } else if (platform == TargetPlatform.macOS) {
      tabWidget = ensureMacosTheme(context, _buildMaterialTabView());
    } else if (platform == TargetPlatform.linux) {
      tabWidget = yaru.YaruTheme(child: _buildMaterialTabView());
    } else {
      tabWidget = _buildMaterialTabView();
    }

    if (widget.glassStyle) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: ColoredBox(
            color: Theme.of(context).colorScheme.surface.withAlpha(25),
            child: tabWidget,
          ),
        ),
      );
    }

    return tabWidget;
  }

  Widget _buildFluentTabView() {
    return fluent.TabView(
      currentIndex: _currentIndex,
      onChanged: (index) {
        setState(() => _currentIndex = index);
        widget.onTabChanged?.call(index);
      },
      tabs: widget.tabs
          .map(
            (t) => fluent.Tab(
              icon: t.icon,
              text: t.label,
              body: t.body,
            ),
          )
          .toList(),
    );
  }

  Widget _buildMaterialTabView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TabBar(
          controller: _tabController,
          tabs: widget.tabs
              .map(
                (t) => Tab(
                  child: t.icon != null
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            t.icon!,
                            const SizedBox(width: 6),
                            t.label,
                          ],
                        )
                      : t.label,
                ),
              )
              .toList(),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.tabs.map((t) => t.body).toList(),
          ),
        ),
      ],
    );
  }
}
