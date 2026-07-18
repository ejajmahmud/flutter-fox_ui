import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fox_ui/src/platform/platform_override.dart';
import 'package:fox_ui/src/theme/fluent_theme_resolver.dart';
import 'package:macos_ui/macos_ui.dart' as macos;

/// Size variants for [FoxSidebarItem]s.
enum FoxSidebarItemSize {
  /// A compact sidebar item.
  small(40, 16),

  /// A regular sidebar item.
  medium(44, 18),

  /// A roomy sidebar item.
  large(48, 20)
  ;

  const FoxSidebarItemSize(this.height, this.iconSize);

  /// The minimum height of the rendered item on non-macOS platforms.
  final double height;

  /// The icon size used on non-macOS platforms.
  final double iconSize;
}

/// A platform-neutral navigation item used by [FoxSidebarItems].
class FoxSidebarItem {
  /// Creates a sidebar navigation item.
  const FoxSidebarItem({
    required this.label,
    this.leading,
    this.trailing,
    this.focusNode,
    this.semanticLabel,
  });

  /// The widget displayed before [label].
  final Widget? leading;

  /// The item's primary label.
  final Widget label;

  /// The widget displayed after [label].
  final Widget? trailing;

  /// Optional focus node for the item.
  final FocusNode? focusNode;

  /// Optional semantic label for assistive technologies.
  final String? semanticLabel;
}

/// A platform-adaptive vertical list of sidebar navigation items.
class FoxSidebarItems extends StatelessWidget {
  /// Creates a platform-adaptive sidebar navigation list.
  const FoxSidebarItems({
    required this.items,
    required this.currentIndex,
    required this.onChanged,
    super.key,
    this.itemSize = FoxSidebarItemSize.medium,
    this.scrollController,
  }) : assert(currentIndex >= 0, 'currentIndex must not be negative.');

  /// The items rendered in the sidebar.
  final List<FoxSidebarItem> items;

  /// The currently selected item index.
  final int currentIndex;

  /// Called when the current item should change.
  final ValueChanged<int> onChanged;

  /// Shared size configuration for all rendered items.
  final FoxSidebarItemSize itemSize;

  /// The controller used by the native macOS sidebar list.
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    assert(
      currentIndex < items.length,
      'currentIndex must reference one of the sidebar items.',
    );
    final platform = PlatformOverride.of(context);

    if (platform == TargetPlatform.macOS) {
      return _buildMacosItems();
    }

    if (kIsWeb || platform == TargetPlatform.windows) {
      return ensureFluentTheme(context, _buildFluentItems());
    }

    return _buildMaterialItems(context);
  }

  Widget _buildMacosItems() {
    return macos.SidebarItems(
      currentIndex: currentIndex,
      onChanged: onChanged,
      scrollController: scrollController,
      itemSize: switch (itemSize) {
        FoxSidebarItemSize.small => macos.SidebarItemSize.small,
        FoxSidebarItemSize.medium => macos.SidebarItemSize.medium,
        FoxSidebarItemSize.large => macos.SidebarItemSize.large,
      },
      items: items
          .map(
            (item) => macos.SidebarItem(
              leading: item.leading,
              label: item.label,
              trailing: item.trailing,
              focusNode: item.focusNode,
              semanticLabel: item.semanticLabel,
            ),
          )
          .toList(),
    );
  }

  Widget _buildFluentItems() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          items.length,
          (index) {
            final item = items[index];

            return SizedBox(
              height: itemSize.height,
              child: fluent.ListTile.selectable(
                selected: index == currentIndex,
                onPressed: () => onChanged(index),
                leading: _buildLeading(item.leading),
                title: item.label,
                trailing: item.trailing,
                focusNode: item.focusNode,
                semanticLabel: item.semanticLabel,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMaterialItems(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          items.length,
          (index) {
            final item = items[index];
            final selected = index == currentIndex;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Material(
                color: selected
                    ? colorScheme.secondaryContainer
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                child: ListTile(
                  dense: itemSize == FoxSidebarItemSize.small,
                  selected: selected,
                  minTileHeight: itemSize.height,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  leading: _buildLeading(item.leading),
                  title: item.label,
                  trailing: item.trailing,
                  focusNode: item.focusNode,
                  onTap: () => onChanged(index),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget? _buildLeading(Widget? leading) {
    if (leading == null) {
      return null;
    }

    return IconTheme.merge(
      data: IconThemeData(size: itemSize.iconSize),
      child: leading,
    );
  }
}
