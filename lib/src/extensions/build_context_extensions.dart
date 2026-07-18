import 'package:fox_ui/fox_ui.dart';

/// Extension on [BuildContext] for easy access to custom theme tokens.
extension AppThemeBuildContext on BuildContext {
  /// Returns the [AppColors] from the current theme.
  AppColors get appColors {
    final theme = Theme.of(this);
    return theme.extension<AppColors>() ??
        (theme.brightness == Brightness.dark
            ? AppTheme.dark.extension<AppColors>()!
            : AppTheme.light.extension<AppColors>()!);
  }

  /// Returns the [AppSpacing] from the current theme.
  AppSpacing get appSpacing =>
      Theme.of(this).extension<AppSpacing>() ?? const AppSpacing();
}
