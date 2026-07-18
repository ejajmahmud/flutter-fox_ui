import 'dart:ui';

import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fox_ui/src/platform/platform_override.dart';
import 'package:fox_ui/src/theme/fluent_theme_resolver.dart';
import 'package:fox_ui/src/theme/macos_theme_resolver.dart';
import 'package:macos_ui/macos_ui.dart' as macos;
import 'package:yaru/yaru.dart' as yaru;

/// A single selectable item for [FoxDropdown].
class FoxDropdownItem<T> {
  /// Creates a [FoxDropdownItem].
  const FoxDropdownItem({required this.value, required this.child});

  /// The value this item represents.
  final T value;

  /// The widget displayed for this item.
  final Widget child;
}

/// {@template dropdown}
/// A platform-adaptive dropdown selector.
/// {@endtemplate}
class FoxDropdown<T> extends StatelessWidget {
  /// {@macro dropdown}
  const FoxDropdown({
    required this.items,
    required this.onChanged,
    this.value,
    this.placeholder,
    this.glassStyle = false,
    super.key,
  });

  /// The currently selected value, or null if nothing is selected.
  final T? value;

  /// The list of selectable items.
  final List<FoxDropdownItem<T>> items;

  /// Called when the user selects a value.
  final ValueChanged<T?>? onChanged;

  /// Widget shown when [value] is null.
  final Widget? placeholder;

  /// Whether to apply a glassmorphism effect.
  final bool glassStyle;

  @override
  Widget build(BuildContext context) {
    final platform = PlatformOverride.of(context);
    Widget dropdownWidget;

    if (kIsWeb || platform == TargetPlatform.windows) {
      dropdownWidget = ensureFluentTheme(context, _buildFluentFoxDropdown());
    } else if (platform == TargetPlatform.macOS) {
      dropdownWidget = ensureMacosTheme(context, _buildMacosFoxDropdown());
    } else if (platform == TargetPlatform.linux) {
      dropdownWidget = yaru.YaruTheme(child: _buildMaterialFoxDropdown());
    } else {
      dropdownWidget = _buildMaterialFoxDropdown();
    }

    if (glassStyle) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: ColoredBox(
            color: Theme.of(context).colorScheme.surface.withAlpha(25),
            child: dropdownWidget,
          ),
        ),
      );
    }

    return dropdownWidget;
  }

  Widget _buildFluentFoxDropdown() {
    return fluent.ComboBox<T>(
      value: value,
      items: items
          .map((e) => fluent.ComboBoxItem<T>(value: e.value, child: e.child))
          .toList(),
      onChanged: onChanged,
      placeholder: placeholder,
    );
  }

  Widget _buildMacosFoxDropdown() {
    return macos.MacosPopupButton<T>(
      value: value,
      items: items
          .map(
            (e) => macos.MacosPopupMenuItem<T>(value: e.value, child: e.child),
          )
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildMaterialFoxDropdown() {
    return DropdownButton<T>(
      value: value,
      items: items
          .map((e) => DropdownMenuItem<T>(value: e.value, child: e.child))
          .toList(),
      onChanged: onChanged,
      hint: placeholder,
    );
  }
}
