import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Provides platform override capability for  cross-platform UI rendering.
///
/// This widget sits between the app and Material app to allow forcing a
/// specific platform's UI rendering, useful for testing macOS UI while running
/// on Windows, etc.
class PlatformOverride extends InheritedWidget {
  /// Creates a [PlatformOverride] widget.
  ///
  /// The [child] parameter is required.
  /// If [forcePlatform] is null, the platform
  /// defaults to [defaultTargetPlatform].
  const PlatformOverride({
    required super.child,
    this.forcePlatform,
    super.key,
  });

  /// The forced platform, or null to use [defaultTargetPlatform].
  final TargetPlatform? forcePlatform;

  /// The effective platform: [forcePlatform] if set,
  /// otherwise [defaultTargetPlatform].
  TargetPlatform get effectivePlatform =>
      forcePlatform ?? defaultTargetPlatform;

  /// Retrieves the effective platform from
  /// the nearest [PlatformOverride] ancestor.
  ///
  /// If no [PlatformOverride] exists, returns [defaultTargetPlatform].
  static TargetPlatform of(BuildContext context) {
    final override = context
        .dependOnInheritedWidgetOfExactType<PlatformOverride>();
    return override?.effectivePlatform ?? defaultTargetPlatform;
  }

  /// Retrieves the effective platform without listening to updates.
  ///
  /// Useful for one-time lookups where widget rebuilds aren't needed.
  static TargetPlatform? maybeOf(BuildContext context) {
    final override = context
        .dependOnInheritedWidgetOfExactType<PlatformOverride>();
    return override?.effectivePlatform;
  }

  @override
  bool updateShouldNotify(PlatformOverride oldWidget) =>
      oldWidget.effectivePlatform != effectivePlatform;
}
