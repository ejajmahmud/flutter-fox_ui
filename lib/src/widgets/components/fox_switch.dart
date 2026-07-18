import 'dart:ui';

import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as material;
import 'package:fox_ui/src/platform/platform_override.dart';
import 'package:fox_ui/src/theme/fluent_theme_resolver.dart';
import 'package:fox_ui/src/theme/macos_theme_resolver.dart';
import 'package:macos_ui/macos_ui.dart' as macos;
import 'package:yaru/yaru.dart' as yaru;

/// {@template switch}
/// A platform-adaptive toggle switch.
/// {@endtemplate}
class FoxSwitch extends material.StatelessWidget {
  /// {@macro switch}
  const FoxSwitch({
    required this.value,
    required this.onChanged,
    this.label,
    this.glassStyle = false,
    super.key,
  });

  /// Whether the switch is on.
  final bool value;

  /// Called when the user toggles the switch.
  final material.ValueChanged<bool>? onChanged;

  /// Optional label displayed beside the switch.
  final material.Widget? label;

  /// Whether to apply a glassmorphism effect.
  final bool glassStyle;

  @override
  material.Widget build(material.BuildContext context) {
    final platform = PlatformOverride.of(context);
    material.Widget switchWidget;

    if (kIsWeb || platform == material.TargetPlatform.windows) {
      switchWidget = ensureFluentTheme(context, _buildFluentSwitch());
    } else if (platform == material.TargetPlatform.macOS) {
      switchWidget = ensureMacosTheme(context, _buildMacosSwitch());
    } else if (platform == material.TargetPlatform.linux) {
      switchWidget = yaru.YaruTheme(child: _buildMaterialSwitch());
    } else {
      switchWidget = _buildMaterialSwitch();
    }

    if (glassStyle) {
      return material.ClipRRect(
        borderRadius: material.BorderRadius.circular(8),
        child: material.BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: material.ColoredBox(
            color: material.Theme.of(context).colorScheme.surface.withAlpha(25),
            child: switchWidget,
          ),
        ),
      );
    }

    return switchWidget;
  }

  material.Widget _buildFluentSwitch() {
    return fluent.ToggleSwitch(
      checked: value,
      onChanged: onChanged,
      content: label,
    );
  }

  material.Widget _buildMacosSwitch() {
    return macos.MacosSwitch(
      value: value,
      onChanged: onChanged,
    );
  }

  material.Widget _buildMaterialSwitch() {
    if (label == null) {
      return material.Switch(value: value, onChanged: onChanged);
    }
    return material.Row(
      mainAxisSize: material.MainAxisSize.min,
      children: [
        material.Switch(value: value, onChanged: onChanged),
        const material.SizedBox(width: 8),
        label!,
      ],
    );
  }
}
