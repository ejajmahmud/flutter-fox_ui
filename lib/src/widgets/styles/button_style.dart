import 'package:flutter/material.dart';
import 'package:fox_ui/src/extensions/build_context_extensions.dart';
import 'package:macos_ui/macos_ui.dart' as macos;
import 'package:mix/mix.dart';

/// Visual variants for [FoxButton].
enum FoxButtonVariant {
  /// The standard native appearance (macOS/Windows/etc)
  native,
  /// A filled button with the primary color.
  primary,
  /// A toned or secondary button.
  secondary,
  tertiary,
  icon,
  warning,
  error,
  info,
  success,
  /// An outlined button.
  outline,
  /// Text-only button without background or border
  ghost,
  /// Destructive action button.
  destructive,
}

/// Size variants for [FoxButton].
enum FoxButtonSize {
  /// A small button.
  small,
  /// A medium button.
  medium,
  /// A large button.
  large,
}

class FoxButtonStyle {
  static BoxStyler get base => BoxStyler()
      .borderRadius(BorderRadiusMix.circular(8))
      .scale(1)
      .onPressed(BoxStyler().scale(0.97))
      .animate(AnimationConfig.ease(150.ms));

  static BoxStyler styleForVariant(
    BuildContext context,
    FoxButtonVariant variant,
    EdgeInsetsMix padding, {
    bool isGlass = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    final bgColor = isGlass ? Colors.transparent : colorScheme.primary;
    final secondaryBgColor = isGlass ? Colors.transparent : colorScheme.secondaryContainer;

    return switch (variant) {
      FoxButtonVariant.primary =>
        base
            .padding(padding)
            .color(bgColor)
            .onHovered(BoxStyler().color(colorScheme.primary.withAlpha(isGlass ? 50 : 204))),
      FoxButtonVariant.secondary =>
        base
            .padding(padding)
            .color(secondaryBgColor)
            .onHovered(
              BoxStyler().color(colorScheme.secondaryContainer.withAlpha(isGlass ? 50 : 204)),
            ),
      FoxButtonVariant.outline =>
        base
            .color(Colors.transparent)
            .border(BoxBorderMix.all(BorderSideMix(color: colorScheme.outline)))
            .onHovered(BoxStyler().color(colorScheme.primary.withAlpha(13))),
      FoxButtonVariant.ghost =>
        base
            .color(Colors.transparent)
            .onHovered(BoxStyler().color(colorScheme.primary.withAlpha(13))),
      FoxButtonVariant.destructive =>
        base
            .color(isGlass ? Colors.transparent : colorScheme.error)
            .onHovered(BoxStyler().color(colorScheme.error.withAlpha(isGlass ? 50 : 204))),
      _ => base,
    };
  }

  static EdgeInsets paddingForSize(BuildContext context, FoxButtonSize size) {
    final spacing = context.appSpacing;
    return switch (size) {
      FoxButtonSize.small => EdgeInsets.symmetric(
        horizontal: spacing.sm,
        vertical: spacing.xxs,
      ),
      FoxButtonSize.medium => EdgeInsets.symmetric(
        horizontal: spacing.md,
        vertical: spacing.xs,
      ),
      FoxButtonSize.large => EdgeInsets.symmetric(
        horizontal: spacing.lg,
        vertical: spacing.sm,
      ),
    };
  }

  static EdgeInsetsMix mixPaddingForSize(BuildContext context, FoxButtonSize size) {
    final spacing = context.appSpacing;
    return switch (size) {
      FoxButtonSize.small => EdgeInsetsMix.symmetric(
        horizontal: spacing.sm,
        vertical: spacing.xxs,
      ),
      FoxButtonSize.medium => EdgeInsetsMix.symmetric(
        horizontal: spacing.md,
        vertical: spacing.xs,
      ),
      FoxButtonSize.large => EdgeInsetsMix.symmetric(
        horizontal: spacing.lg,
        vertical: spacing.sm,
      ),
    };
  }

  static macos.ControlSize controlSizeForSize(FoxButtonSize size) {
    return switch (size) {
      FoxButtonSize.small => macos.ControlSize.small,
      FoxButtonSize.medium => macos.ControlSize.regular,
      FoxButtonSize.large => macos.ControlSize.large,
    };
  }
}
