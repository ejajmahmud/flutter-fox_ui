import 'package:example/app/app.dart';
import 'package:example/bootstrap.dart';

import 'package:fox_ui/fox_ui.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  var titleBar = TitleBarStyle.normal;

  if (isMacOS) {
    titleBar = TitleBarStyle.hidden;
  } else {
    await Window.initialize();
  }

  await initFoxUIWindow(
    title: 'Fox UI Example',
    size: const Size(1400, 800),
    titleBarStyle: titleBar,
  );

  await bootstrap(() => const App());
}
