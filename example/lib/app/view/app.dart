import 'package:example/app/view/demo_home.dart';
import 'package:fox_ui/fox_ui.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return FoxUIApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: const DemoHome(),
    );
  }
}
