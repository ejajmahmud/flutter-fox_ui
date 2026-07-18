import 'package:fox_ui/fox_ui.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:window_manager/window_manager.dart';

/// Initializes the application window with specified options.
///
/// This method uses the `window_manager` package to configure and display the
/// native desktop window before the Flutter app renders.
///
/// Example:
/// ```dart
/// await initFoxUIWindow(
///   title: 'Fox UI App',
///   size: const Size(1280, 720),
/// );
/// ```
Future<void> initFoxUIWindow({
  required String title,
  required Size size,
  TitleBarStyle titleBarStyle = TitleBarStyle.normal,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  if (isMacOS) {
    await _configureMacosWindowUtils();
  }

  final windowOptions = WindowOptions(
    size: size,
    center: false,
    title: title,
    skipTaskbar: false,
    titleBarStyle: titleBarStyle,
    minimumSize: const Size(1000, 800),
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}

Future<void> _configureMacosWindowUtils() async {
  const config = MacosWindowUtilsConfig();
  await config.apply();
}
