import 'package:flutter/material.dart' as material;
import 'package:fox_ui/src/stylized/stylized_widgets.dart';
import 'package:mix/mix.dart';

/// Visual variants supported by [FBadge].
enum FBadgeVariant {
  /// Primary badge.
  primary,
}

/// A themed badge implemented with Mix.
class FoxBadge extends material.StatelessWidget {
  /// Creates a themed badge.
  const FoxBadge({
    required this.child,
    super.key,
    this.variant = FBadgeVariant.primary,
  });

  /// The visual badge variant.
  final FBadgeVariant variant;

  /// The badge content.
  final material.Widget child;

  @override
  material.Widget build(material.BuildContext context) {
    final theme = material.Theme.of(context);
    final colors = theme.colorScheme;
    final background = switch (variant) {
      FBadgeVariant.primary => colors.primaryContainer,
    };
    final foreground = switch (variant) {
      FBadgeVariant.primary => colors.onPrimaryContainer,
    };

    return Box(
      style: BoxStyler()
          .color(background)
          .padding(EdgeInsetsGeometryMix.symmetric(horizontal: 8, vertical: 2))
          .borderRadius(BorderRadiusGeometryMix.circular(999)),
      child: material.DefaultTextStyle.merge(
        style: theme.textTheme.labelSmall?.copyWith(color: foreground),
        child: material.IconTheme(
          data: material.IconThemeData(color: foreground, size: 12),
          child: child,
        ),
      ),
    );
  }
}

class FoxDialog extends material.StatelessWidget {
  /// Creates a themed dialog.
  const FoxDialog({
    super.key,
    this.direction = material.Axis.vertical,
    this.title,
    this.body,
    this.actions = const <material.Widget>[],
  });

  /// The content direction.
  final material.Axis direction;

  /// Optional dialog title.
  final material.Widget? title;

  /// Optional dialog body.
  final material.Widget? body;

  /// Dialog actions.
  final List<material.Widget> actions;

  @override
  material.Widget build(material.BuildContext context) {
    final content = switch (direction) {
      material.Axis.vertical => body,
      material.Axis.horizontal => body,
    };

    return material.AlertDialog(
      title: title,
      content: content,
      actions: actions,
    );
  }
}

/// Controller configuration for [FTextField].
class FoxTextFieldControl {
  /// Creates a managed text field control.
  const FoxTextFieldControl.managed({required this.controller, this.onChange});

  /// The text editing controller.
  final material.TextEditingController controller;

  /// Called when the controller value changes.
  final material.ValueChanged<material.TextEditingValue>? onChange;
}

/// A themed text field.
class FoxTextField extends material.StatelessWidget {
  /// Creates a themed text field.
  const FoxTextField({super.key, this.label, this.hint, this.control});

  /// Optional label displayed above the field.
  final material.Widget? label;

  /// Optional placeholder text.
  final String? hint;

  /// Optional managed controller configuration.
  final FoxTextFieldControl? control;

  @override
  material.Widget build(material.BuildContext context) {
    final theme = material.Theme.of(context);

    return ColumnBox(
      style: FlexBoxStyler()
          .crossAxisAlignment(material.CrossAxisAlignment.start)
          .spacing(label == null ? 0 : 6),
      children: [
        if (label != null)
          material.DefaultTextStyle.merge(
            style: theme.textTheme.labelMedium,
            child: label!,
          ),
        material.TextField(
          controller: control?.controller,
          onChanged: control?.onChange == null
              ? null
              : (value) {
                  final controller = control!.controller;
                  if (controller.value.text != value) {
                    controller.value = controller.value.copyWith(
                      text: value,
                      selection: material.TextSelection.collapsed(
                        offset: value.length,
                      ),
                      composing: material.TextRange.empty,
                    );
                  }
                  control!.onChange?.call(controller.value);
                },
          decoration: material.InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}

/// A themed checkbox.
class FoxCheckbox extends material.StatelessWidget {
  /// Creates a themed checkbox.
  const FoxCheckbox({required this.value, super.key, this.onChange});

  /// Whether the checkbox is selected.
  final bool value;

  /// Called when the checkbox value changes.
  final material.ValueChanged<bool?>? onChange;

  @override
  material.Widget build(material.BuildContext context) {
    return material.Checkbox(value: value, onChanged: onChange);
  }
}

/// A themed switch.
class FoxSwitch extends material.StatelessWidget {
  /// Creates a themed switch.
  const FoxSwitch({required this.value, super.key, this.onChange});

  /// Whether the switch is selected.
  final bool value;

  /// Called when the switch value changes.
  final material.ValueChanged<bool>? onChange;

  @override
  material.Widget build(material.BuildContext context) {
    return material.Switch(value: value, onChanged: onChange);
  }
}

/// A themed divider implemented with Mix.
class FoxDivider extends material.StatelessWidget {
  /// Creates a themed divider.
  const FoxDivider({super.key});

  @override
  material.Widget build(material.BuildContext context) {
    return Box(
      style: BoxStyler()
          .height(1)
          .color(material.Theme.of(context).dividerColor),
    );
  }
}

/// A themed label.
class FoxLabel extends material.StatelessWidget {
  /// Creates a themed label.
  const FoxLabel({required this.child, super.key});

  /// The label content.
  final material.Widget child;

  @override
  material.Widget build(material.BuildContext context) {
    return material.DefaultTextStyle.merge(
      style: material.Theme.of(context).textTheme.labelMedium,
      child: child,
    );
  }
}

/// A transparent themed scaffold.
class FoxScaffold extends material.StatelessWidget {
  /// Creates a themed scaffold.
  const FoxScaffold({super.key, this.appBar, this.body});

  /// Optional app bar.
  final material.PreferredSizeWidget? appBar;

  /// Optional body content.
  final material.Widget? body;

  @override
  material.Widget build(material.BuildContext context) {
    return material.Scaffold(
      appBar: appBar,
      body: body,
      backgroundColor: material.Colors.transparent,
    );
  }
}
