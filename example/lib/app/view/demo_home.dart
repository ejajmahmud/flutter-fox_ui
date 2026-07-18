import 'package:fox_ui/fox_ui.dart';

class DemoHome extends StatefulWidget {
  const DemoHome({super.key});

  @override
  State<DemoHome> createState() => _DemoHomeState();
}

class _DemoHomeState extends State<DemoHome> {
  int _selectedIndex = 0;
  TargetPlatform? _forcedPlatform;

  static const List<({String title, IconData icon})> _pages = [
    (title: 'Button', icon: Icons.smart_button_outlined),
    (title: 'Switch', icon: Icons.toggle_on_outlined),
    (title: 'Dropdown', icon: Icons.arrow_drop_down_circle_outlined),
    (title: 'Tab View', icon: Icons.tab_outlined),
    (title: 'Toolbar', icon: Icons.view_agenda_outlined),
    (title: 'Title Bar', icon: Icons.web_asset_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return FoxWindow(
      sidebar: FoxSidebar(
        top: const _BrandHeader(),
        builder: (context, scrollController) {
          return FoxSidebarItems(
            currentIndex: selectedIndex,
            onChanged: (i) => context.go(_globalItems[i].path),
            scrollController: scrollController,
            itemSize: FoxSidebarItemSize.large,
            items: _globalItems
                .map(
                  (item) => FoxSidebarItem(
                    leading: Icon(item.icon),
                    label: Text(item.label),
                  ),
                )
                .toList(),
          );
        },
        minWidth: 200,
        bottom: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [],
        ),
      ),
      child: child,
    );
  }
}

class _PlatformBar extends StatelessWidget {
  const _PlatformBar({required this.value, required this.onChanged});

  final TargetPlatform? value;
  final ValueChanged<TargetPlatform?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      color: Theme.of(context).colorScheme.surfaceContainer,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            'Preview as:',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(width: 8),
          DropdownButton<TargetPlatform?>(
            value: value,
            underline: const SizedBox.shrink(),
            isDense: true,
            hint: const Text('Default'),
            items: [
              const DropdownMenuItem<TargetPlatform?>(
                child: Text('Default'),
              ),
              for (final p in TargetPlatform.values)
                DropdownMenuItem(value: p, child: Text(p.name)),
            ],
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

// ── Button demo ──────────────────────────────────────────────────────────────

class _ButtonDemo extends StatelessWidget {
  const _ButtonDemo();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('Variants', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            Button(onPressed: () {}, child: const Text('Primary')),
            Button(
              onPressed: () {},
              variant: ButtonVariant.secondary,
              child: const Text('Secondary'),
            ),
            Button(
              onPressed: () {},
              variant: ButtonVariant.outline,
              child: const Text('Outline'),
            ),
            const Button(onPressed: null, child: Text('Disabled')),
          ],
        ),
        const SizedBox(height: 32),
        Text('Sizes', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final size in ButtonSize.values)
              Button(
                onPressed: () {},
                size: size,
                child: Text(size.name),
              ),
          ],
        ),
      ],
    );
  }
}

// ── Switch demo ──────────────────────────────────────────────────────────────

class _SwitchDemo extends StatefulWidget {
  const _SwitchDemo();

  @override
  State<_SwitchDemo> createState() => _SwitchDemoState();
}

class _SwitchDemoState extends State<_SwitchDemo> {
  bool _plain = false;
  bool _labeled = true;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('Toggle Switch', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        Switch(value: _plain, onChanged: (v) => setState(() => _plain = v)),
        const SizedBox(height: 16),
        Switch(
          value: _labeled,
          onChanged: (v) => setState(() => _labeled = v),
          label: const Text('With label'),
        ),
        const SizedBox(height: 16),
        const Switch(value: true, onChanged: null),
      ],
    );
  }
}

// ── Dropdown demo ────────────────────────────────────────────────────────────

class _DropdownDemo extends StatefulWidget {
  const _DropdownDemo();

  @override
  State<_DropdownDemo> createState() => _DropdownDemoState();
}

class _DropdownDemoState extends State<_DropdownDemo> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('Dropdown', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        Dropdown<String>(
          value: _selected,
          placeholder: const Text('Select a fruit'),
          onChanged: (v) => setState(() => _selected = v),
          items: const [
            DropdownItem(value: 'apple', child: Text('Apple')),
            DropdownItem(value: 'banana', child: Text('Banana')),
            DropdownItem(value: 'cherry', child: Text('Cherry')),
            DropdownItem(value: 'mango', child: Text('Mango')),
          ],
        ),
        if (_selected != null) ...[
          const SizedBox(height: 16),
          Text('Selected: $_selected'),
        ],
      ],
    );
  }
}

// ── TabView demo ─────────────────────────────────────────────────────────────

class _TabViewDemo extends StatelessWidget {
  const _TabViewDemo();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: TabView(
        tabs: [
          VedlaTab(
            label: Text('Overview'),
            body: Center(child: Text('Overview content')),
          ),
          VedlaTab(
            label: Text('Details'),
            body: Center(child: Text('Details content')),
          ),
          VedlaTab(
            label: Text('Settings'),
            body: Center(child: Text('Settings content')),
          ),
        ],
      ),
    );
  }
}

// ── Toolbar demo ─────────────────────────────────────────────────────────────

class _ToolbarDemo extends StatelessWidget {
  const _ToolbarDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Toolbar(
          title: const Text('My Document'),
          actions: [
            ToolbarAction(
              icon: const Icon(Icons.save_outlined),
              label: 'Save',
              tooltip: 'Save',
              onPressed: () {},
            ),
            ToolbarAction(
              icon: const Icon(Icons.share_outlined),
              label: 'Share',
              tooltip: 'Share',
              onPressed: () {},
            ),
            ToolbarAction(
              icon: const Icon(Icons.delete_outline),
              label: 'Delete',
              tooltip: 'Delete',
              onPressed: () {},
            ),
          ],
        ),
        const Expanded(
          child: Center(child: Text('Toolbar demonstrated above')),
        ),
      ],
    );
  }
}

// ── TitleBar demo ────────────────────────────────────────────────────────────

class _TitleBarDemo extends StatelessWidget {
  const _TitleBarDemo();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('Title only', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        const TitleBar(title: 'My Document'),
        const SizedBox(height: 32),
        Text('With actions', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        TitleBar(
          title: 'My Document',
          actions: [
            TitleBarAction(
              icon: const Icon(Icons.save_outlined),
              label: 'Save',
              onPressed: () {},
            ),
            TitleBarAction(
              icon: const Icon(Icons.share_outlined),
              label: 'Share',
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 32),
        Text('No title', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        TitleBar(
          actions: [
            TitleBarAction(
              icon: const Icon(Icons.close),
              label: 'Close',
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
