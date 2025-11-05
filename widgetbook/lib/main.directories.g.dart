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
import 'package:widgetbook_workspace/use_cases/buttons_usecases.dart'
    as _widgetbook_workspace_use_cases_buttons_usecases;

final directories = <_widgetbook.WidgetbookNode>[
  _widgetbook.WidgetbookCategory(
    name: 'Buttons',
    children: [
      _widgetbook.WidgetbookFolder(
        name: 'AppButton',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'AppButton',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Interactive',
                builder: _widgetbook_workspace_use_cases_buttons_usecases
                    .buildAppButtonInteractive,
                designLink:
                    'https://www.figma.com/design/eu4y7kUHlOnPQsu160wZkX/ds-demo?node-id=1-131&t=QO0UDXS46aSqMwRT-4',
              ),
            ],
          ),
          _widgetbook.WidgetbookFolder(
            name: 'States',
            children: [
              _widgetbook.WidgetbookComponent(
                name: 'AppButton',
                useCases: [
                  _widgetbook.WidgetbookUseCase(
                    name: 'Disabled',
                    builder: _widgetbook_workspace_use_cases_buttons_usecases
                        .buildAppButtonDisabled,
                    designLink:
                        'https://www.figma.com/design/eu4y7kUHlOnPQsu160wZkX/ds-demo?node-id=1-131',
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'Loading',
                    builder: _widgetbook_workspace_use_cases_buttons_usecases
                        .buildAppButtonLoading,
                    designLink:
                        'https://www.figma.com/design/eu4y7kUHlOnPQsu160wZkX/ds-demo?node-id=1-131',
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'Primary',
                    builder: _widgetbook_workspace_use_cases_buttons_usecases
                        .buildAppButtonPrimary,
                    designLink:
                        'https://www.figma.com/design/eu4y7kUHlOnPQsu160wZkX/ds-demo?node-id=1-131',
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'Secondary',
                    builder: _widgetbook_workspace_use_cases_buttons_usecases
                        .buildAppButtonSecondary,
                    designLink:
                        'https://www.figma.com/design/eu4y7kUHlOnPQsu160wZkX/ds-demo?node-id=1-131',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  ),
];
