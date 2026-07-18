/// Widgets that automagically adapt to the platform for a true native look
library;

export 'package:fluent_ui/fluent_ui.dart' show FluentThemeData;
export 'package:flutter/material.dart' hide Scaffold, Switch;
export 'package:flutter_acrylic/flutter_acrylic.dart' show Window, WindowEffect;
export 'package:macos_ui/macos_ui.dart'
    show
        AccentColor,
        MacosPulldownMenuDivider,
        MacosPulldownMenuEntry,
        MacosPulldownMenuItem,
        MacosThemeData,
        MacosTypography;
export 'package:window_manager/window_manager.dart' show TitleBarStyle;

export 'src/extensions/build_context_extensions.dart';
export 'src/platform/platform_override.dart';
export 'src/stylized/stylized.dart';
export 'src/theme/app_colors.dart';
export 'src/theme/app_spacing.dart';
export 'src/theme/app_theme.dart';
export 'src/utils/platform_selector.dart';
export 'src/utils/window_utils.dart';
export 'src/vedla_app.dart';
export 'src/widgets/components/fox_button.dart';
export 'src/widgets/components/fox_dropdown.dart';
export 'src/widgets/components/fox_icon.dart';
export 'src/widgets/components/fox_switch.dart';
export 'src/widgets/components/fox_tab_view.dart';
export 'src/widgets/components/fox_text.dart';
export 'src/widgets/components/fox_title_bar.dart';
export 'src/widgets/components/fox_toolbar.dart';
export 'src/widgets/layout/fox_grid.dart';
export 'src/widgets/layout/fox_hstack.dart';
export 'src/widgets/layout/fox_scaffold.dart';
export 'src/widgets/layout/fox_sidebar.dart' hide ScrollableWidgetBuilder;
export 'src/widgets/layout/fox_sidebar_items.dart';
export 'src/widgets/layout/fox_vstack.dart';
export 'src/widgets/layout/fox_window.dart';
export 'src/widgets/layout/fox_zstack.dart';
export 'src/widgets/styles/button_style.dart';
