// dart format width=80
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:widgetbook/widgetbook.dart' as _widgetbook;
import 'package:widgetbook_catalog/widgetbook/use_cases/app_button.dart'
    as _use_cases_switch;
import 'package:widgetbook_catalog/widgetbook/use_cases/button.dart'
    as _use_cases_button;
import 'package:widgetbook_catalog/widgetbook/use_cases/dropdown.dart'
    as _use_cases_dropdown;
import 'package:widgetbook_catalog/widgetbook/use_cases/tab_view.dart'
    as _use_cases_tab_view;
import 'package:widgetbook_catalog/widgetbook/use_cases/title_bar.dart'
    as _use_cases_title_bar;
import 'package:widgetbook_catalog/widgetbook/use_cases/toolbar.dart'
    as _use_cases_toolbar;

final directories = <_widgetbook.WidgetbookNode>[
  _widgetbook.WidgetbookFolder(
    name: 'components',
    children: [
      _widgetbook.WidgetbookComponent(
        name: 'Button',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'all sizes',
            builder: _use_cases_button.allSizes,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'disabled',
            builder: _use_cases_button.disabled,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'outline',
            builder: _use_cases_button.outline,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'primary',
            builder: _use_cases_button.primary,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'secondary',
            builder: _use_cases_button.secondary,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'Switch',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'on',
            builder: _use_cases_switch.on_,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'off',
            builder: _use_cases_switch.off,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'labeled',
            builder: _use_cases_switch.labeled,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'Dropdown',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'basic',
            builder: _use_cases_dropdown.basic,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'placeholder',
            builder: _use_cases_dropdown.placeholder,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'TabView',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'basic',
            builder: _use_cases_tab_view.basic,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'pre-selected',
            builder: _use_cases_tab_view.preSelected,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'TitleBar',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'title only',
            builder: _use_cases_title_bar.titleOnly,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'with actions',
            builder: _use_cases_title_bar.withActions,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'actions only',
            builder: _use_cases_title_bar.actionsOnly,
          ),
        ],
      ),
      _widgetbook.WidgetbookComponent(
        name: 'Toolbar',
        useCases: [
          _widgetbook.WidgetbookUseCase(
            name: 'with title',
            builder: _use_cases_toolbar.withTitle,
          ),
          _widgetbook.WidgetbookUseCase(
            name: 'actions only',
            builder: _use_cases_toolbar.actionsOnly,
          ),
        ],
      ),
    ],
  ),
];
