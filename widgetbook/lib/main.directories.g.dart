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
              ),
            ],
          ),
        ],
      ),
    ],
  ),
];
