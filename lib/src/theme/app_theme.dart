import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_spacing.dart';

/// Helper to parse theme configuration from JSON map
class ThemeDecoder {
  static Color? decodeColor(dynamic value) {
    if (value is String) {
      if (value.startsWith('#')) {
        final hex = value.replaceAll('#', '');
        if (hex.length == 6) {
          return Color(int.parse('FF$hex', radix: 16));
        } else if (hex.length == 8) {
          return Color(int.parse(hex, radix: 16));
        }
      }
    }
    return null;
  }

  static double? decodeDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  static ThemeData decodeTheme(
    Map<String, dynamic>? json, {
    bool isDark = false,
    ThemeData? baseTheme,
  }) {
    if (json == null || json.isEmpty) {
      return isDark ? AppTheme.dark : AppTheme.light;
    }

    final modeJson =
        (isDark ? json['dark'] : json['light']) as Map<String, dynamic>? ??
        json;

    final primaryColor = decodeColor(modeJson['primary']) ?? (isDark ? const Color(0xFF4F46E5) : const Color(0xFF4F46E5));
    
    final successColor = decodeColor(modeJson['success']) ?? (isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A));
    final onSuccessColor = decodeColor(modeJson['onSuccess']) ?? (isDark ? const Color(0xFF1C1B1F) : const Color(0xFFFFFFFF));
    
    final warningColor = decodeColor(modeJson['warning']) ?? (isDark ? const Color(0xFFFACC15) : const Color(0xFFCA8A04));
    final onWarningColor = decodeColor(modeJson['onWarning']) ?? (isDark ? const Color(0xFF1C1B1F) : const Color(0xFFFFFFFF));
    
    final infoColor = decodeColor(modeJson['info']) ?? (isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB));
    final onInfoColor = decodeColor(modeJson['onInfo']) ?? (isDark ? const Color(0xFF1C1B1F) : const Color(0xFFFFFFFF));

    final appColors = AppColors(
      success: successColor,
      onSuccess: onSuccessColor,
      warning: warningColor,
      onWarning: onWarningColor,
      info: infoColor,
      onInfo: onInfoColor,
    );

    final spacingMap = json['spacing'] as Map<String, dynamic>? ?? {};
    final appSpacing = AppSpacing(
      xxs: decodeDouble(spacingMap['xxs']) ?? 2,
      xs: decodeDouble(spacingMap['xs']) ?? 4,
      sm: decodeDouble(spacingMap['sm']) ?? 8,
      md: decodeDouble(spacingMap['md']) ?? 12,
      lg: decodeDouble(spacingMap['lg']) ?? 16,
      xlg: decodeDouble(spacingMap['xl']) ?? 24,
      xxlg: decodeDouble(spacingMap['xxl']) ?? 32,
    );

    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: isDark ? Brightness.dark : Brightness.light,
    );

    return ThemeData(
      colorScheme: colorScheme,
      extensions: [appColors, appSpacing],
    );
  }
}

class AppTheme {
  /// The light [ThemeData].
  static ThemeData get light {
    const appColors = AppColors(
      success: Color(0xFF16A34A),
      onSuccess: Color(0xFFFFFFFF),
      warning: Color(0xFFCA8A04),
      onWarning: Color(0xFFFFFFFF),
      info: Color(0xFF2563EB),
      onInfo: Color(0xFFFFFFFF),
    );

    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4F46E5)),
      extensions: const [appColors, AppSpacing()],
    );
  }

  /// The dark [ThemeData].
  static ThemeData get dark {
    const appColors = AppColors(
      success: Color(0xFF4ADE80),
      onSuccess: Color(0xFF1C1B1F),
      warning: Color(0xFFFACC15),
      onWarning: Color(0xFF1C1B1F),
      info: Color(0xFF60A5FA),
      onInfo: Color(0xFF1C1B1F),
    );

    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF4F46E5),
        brightness: Brightness.dark,
      ),
      extensions: const [appColors, AppSpacing()],
    );
  }
}
