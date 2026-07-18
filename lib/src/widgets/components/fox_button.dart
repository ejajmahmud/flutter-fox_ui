import 'dart:ui';

import 'package:adaptive_platform_ui/adaptive_platform_ui.dart' as adaptive;
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fox_ui/src/platform/platform_override.dart';
import 'package:fox_ui/src/theme/fluent_theme_resolver.dart';
import 'package:fox_ui/src/theme/macos_theme_resolver.dart';
import 'package:fox_ui/src/widgets/styles/button_style.dart';
import 'package:macos_ui/macos_ui.dart' as macos;
import 'package:mix/mix.dart';
import 'package:yaru/yaru.dart' as yaru;

/// {@template button}
/// A universal button that renders with the platform's native look or custom styles.
/// {@endtemplate}
class FoxButton extends StatelessWidget {
  /// {@macro button}
  const FoxButton({
    required this.onPressed,
    this.child,
    this.variant = FoxButtonVariant.native,
    this.size = FoxButtonSize.medium,
    this.style,
    this.glassStyle = false,
    super.key,
  });

  /// Called when the button is tapped.
  final VoidCallback? onPressed;

  /// The button's content, typically a [Text] widget.
  final Widget? child;

  /// The visual variant of the button.
  final FoxButtonVariant variant;

  /// The size of the button.
  final FoxButtonSize size;

  /// Optional style override for non-native variants using Mix.
  final BoxStyler? style;

  /// Whether to apply a glassmorphism effect.
  final bool? glassStyle;

  @override
  Widget build(BuildContext context) {
    if (variant != FoxButtonVariant.native) {
      final stylizedButton = _buildStylizedButton(context);
      if (glassStyle == true) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: ColoredBox(
              color: Theme.of(context).colorScheme.primary.withAlpha(25),
              child: stylizedButton,
            ),
          ),
        );
      }
      return stylizedButton;
    }

    final platform = PlatformOverride.of(context);
    Widget buttonWidget;

    if (kIsWeb || platform == TargetPlatform.windows) {
      buttonWidget = ensureFluentTheme(context, _buildFluentButton(context));
    } else if (platform == TargetPlatform.macOS) {
      buttonWidget = ensureMacosTheme(context, _buildMacosButton(context));
    } else if (platform == TargetPlatform.iOS) {
      buttonWidget = _buildAdaptiveButton();
    } else if (platform == TargetPlatform.linux) {
      buttonWidget = yaru.YaruTheme(
        child: _buildMaterialButton(context),
      );
    } else {
      buttonWidget = _buildMaterialButton(context);
    }

    if (glassStyle == true) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: ColoredBox(
            color: Theme.of(context).colorScheme.surface.withAlpha(25),
            child: buttonWidget,
          ),
        ),
      );
    }
    
    return buttonWidget;
  }

  Widget _buildStylizedButton(BuildContext context) {
    final baseStyle = _getBaseStyleForVariant(context);
    final foregroundColor = _getForegroundColorForVariant(context);

    return PressableBox(
      enabled: onPressed != null,
      onPress: onPressed,
      style: baseStyle.merge(style),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: foregroundColor),
        child: IconTheme.merge(
          data: IconThemeData(color: foregroundColor),
          child: child ?? const SizedBox.shrink(),
        ),
      ),
    );
  }

  BoxStyler _getBaseStyleForVariant(BuildContext context) {
    final padding = FoxButtonStyle.mixPaddingForSize(context, size);
    return FoxButtonStyle.styleForVariant(context, variant, padding, isGlass: glassStyle ?? false);
  }

  Color _getForegroundColorForVariant(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return switch (variant) {
      FoxButtonVariant.primary => colorScheme.onPrimary,
      FoxButtonVariant.secondary => colorScheme.onSecondaryContainer,
      FoxButtonVariant.outline => colorScheme.onSurface,
      FoxButtonVariant.ghost => colorScheme.onSurface,
      FoxButtonVariant.destructive => colorScheme.onError,
      FoxButtonVariant.native => colorScheme.onSurface,
      _ => colorScheme.onSurface,
    };
  }

  Widget _buildFluentButton(BuildContext context) {
    final style = fluent.ButtonStyle(
      padding: WidgetStatePropertyAll(FoxButtonStyle.paddingForSize(context, size)),
    );

    return fluent.FilledButton(
      onPressed: onPressed,
      style: style,
      child: child ?? const SizedBox.shrink(),
    );
  }

  Widget _buildMacosButton(BuildContext context) {
    return macos.PushButton(
      controlSize: FoxButtonStyle.controlSizeForSize(size),
      secondary: false,
      padding: FoxButtonStyle.paddingForSize(context, size),
      onPressed: onPressed,
      child: child ?? const SizedBox.shrink(),
    );
  }

  Widget _buildAdaptiveButton() {
    return adaptive.AdaptiveButton.child(
      onPressed: onPressed,
      style: adaptive.AdaptiveButtonStyle.filled,
      size: switch (size) {
        FoxButtonSize.small => adaptive.AdaptiveButtonSize.small,
        FoxButtonSize.medium => adaptive.AdaptiveButtonSize.medium,
        FoxButtonSize.large => adaptive.AdaptiveButtonSize.large,
      },
      child: child ?? const SizedBox.shrink(),
    );
  }

  Widget _buildMaterialButton(BuildContext context) {
    final style = ButtonStyle(
      padding: WidgetStatePropertyAll(FoxButtonStyle.paddingForSize(context, size)),
    );

    return FilledButton(
      onPressed: onPressed,
      style: style,
      child: child ?? const SizedBox.shrink(),
    );
  }
}
