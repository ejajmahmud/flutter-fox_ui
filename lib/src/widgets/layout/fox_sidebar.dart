import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fox_ui/src/platform/platform_override.dart';
import 'package:macos_ui/macos_ui.dart' as macos;

/// Builds scrollable sidebar content with the controller owned by the sidebar.
typedef ScrollableWidgetBuilder =
    Widget Function(
      BuildContext context,
      ScrollController scrollController,
    );

/// {@template sidebar}
/// A platform-adaptive sidebar widget for multiplatform applications.
///
/// On macOS, renders as a native [macos.Sidebar] with full styling and
/// resizable support. On Windows, renders with Fluent UI styling. On Linux
/// and other platforms, renders as a vertical panel with Material styling.
/// {@endtemplate}
class FoxSidebar extends StatefulWidget {
  /// {@macro sidebar}
  const FoxSidebar({
    required this.builder,
    required this.minWidth,
    super.key,
    this.decoration,
    this.isResizable = true,
    this.dragClosed = true,
    double? dragClosedBuffer,
    this.snapToStartBuffer,
    this.maxWidth = 400.0,
    this.startWidth,
    this.padding = EdgeInsets.zero,
    this.windowBreakpoint = 556.0,
    this.top,
    this.bottom,
    this.topOffset = 51.0,
    this.shownByDefault = true,
  }) : dragClosedBuffer = dragClosedBuffer ?? minWidth / 2;

  /// The builder that creates sidebar content with a scrollbar.
  ///
  /// Pass the provided [ScrollController] to a scrollable widget to enable
  /// the internal scrollbar to work properly across all platforms.
  final ScrollableWidgetBuilder builder;

  /// The [BoxDecoration] to paint behind the child.
  final BoxDecoration? decoration;

  /// Whether the sidebar can be resized by dragging.
  final bool? isResizable;

  /// If true, sidebar will close when dragged below [minWidth].
  final bool dragClosed;

  /// How far below [minWidth] to drag before closing.
  final double dragClosedBuffer;

  /// Snap back to [startWidth] when dragged within this many pixels.
  final double? snapToStartBuffer;

  /// The maximum width the sidebar can be resized to.
  final double? maxWidth;

  /// The minimum width the sidebar can be resized to.
  final double minWidth;

  /// The default width when the sidebar first appears.
  final double? startWidth;

  /// Padding inside the sidebar container.
  final EdgeInsets padding;

  /// Window width at which the sidebar should be hidden.
  final double windowBreakpoint;

  /// Optional widget displayed at the top of the sidebar.
  final Widget? top;

  /// Optional widget displayed at the bottom of the sidebar.
  final Widget? bottom;

  /// Top offset for the sidebar content.
  final double topOffset;

  /// Whether the sidebar is shown by default.
  final bool shownByDefault;

  @override
  State<FoxSidebar> createState() => _FoxSidebarState();
}

class _FoxSidebarState extends State<FoxSidebar> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final platform = PlatformOverride.of(context);

    // Build the sidebar content
    final content = widget.builder(context, _scrollController);

    if (kIsWeb || platform == TargetPlatform.windows) {
      return _buildFluentSidebar(content);
    }

    if (platform == TargetPlatform.macOS) {
      return _buildMacosSidebar(content);
    }

    if (platform == TargetPlatform.linux) {
      return _buildLinuxSidebar(content);
    }

    return _buildMaterialSidebar(content);
  }

  Widget _buildMacosSidebar(Widget content) {
    // Return a fallback widget in case FoxSidebar is built directly in the tree
    return _buildMaterialSidebar(content);
  }

  Widget _buildFluentSidebar(Widget content) {
    return Container(
      width: widget.startWidth ?? widget.minWidth,
      decoration:
          widget.decoration ??
          BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
          ),
      child: Column(
        children: [
          if (widget.top != null) widget.top!,
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: widget.padding,
                child: content,
              ),
            ),
          ),
          if (widget.bottom != null) widget.bottom!,
        ],
      ),
    );
  }

  Widget _buildLinuxSidebar(Widget content) {
    return Container(
      width: widget.startWidth ?? widget.minWidth,
      decoration:
          widget.decoration ??
          BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
          ),
      child: Column(
        children: [
          if (widget.top != null) widget.top!,
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: widget.padding,
                child: content,
              ),
            ),
          ),
          if (widget.bottom != null) widget.bottom!,
        ],
      ),
    );
  }

  Widget _buildMaterialSidebar(Widget content) {
    return Material(
      child: Container(
        width: widget.startWidth ?? widget.minWidth,
        decoration:
            widget.decoration ??
            BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
            ),
        child: Column(
          children: [
            if (widget.top != null) widget.top!,
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Padding(
                  padding: widget.padding,
                  child: content,
                ),
              ),
            ),
            if (widget.bottom != null) widget.bottom!,
          ],
        ),
      ),
    );
  }
}

/// macOS conversion helpers for [FoxSidebar].
extension MacosSidebarExtension on FoxSidebar {
  /// Converts the adaptive sidebar configuration into a macOS sidebar.
  macos.Sidebar toMacosSidebar() {
    return macos.Sidebar(
      minWidth: minWidth,
      maxWidth: maxWidth,
      startWidth: startWidth,
      topOffset: topOffset,
      shownByDefault: shownByDefault,
      top: top,
      bottom: bottom,
      isResizable: isResizable ?? true,
      dragClosed: dragClosed,
      dragClosedBuffer: dragClosedBuffer,
      snapToStartBuffer: snapToStartBuffer,
      decoration: decoration,
      padding: padding,
      builder: builder,
    );
  }
}
