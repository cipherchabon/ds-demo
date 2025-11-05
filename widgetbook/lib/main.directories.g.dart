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
import 'package:widgetbook_workspace/use_cases/cards_usecases.dart'
    as _widgetbook_workspace_use_cases_cards_usecases;
import 'package:widgetbook_workspace/use_cases/inputs_usecases.dart'
    as _widgetbook_workspace_use_cases_inputs_usecases;
import 'package:widgetbook_workspace/use_cases/typography_usecases.dart'
    as _widgetbook_workspace_use_cases_typography_usecases;

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
                    .buildInteractiveButton,
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
                        .buildDisabledButton,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'Loading',
                    builder: _widgetbook_workspace_use_cases_buttons_usecases
                        .buildLoadingButton,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'Primary',
                    builder: _widgetbook_workspace_use_cases_buttons_usecases
                        .buildPrimaryButton,
                  ),
                  _widgetbook.WidgetbookUseCase(
                    name: 'Secondary',
                    builder: _widgetbook_workspace_use_cases_buttons_usecases
                        .buildSecondaryButton,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  ),
  _widgetbook.WidgetbookCategory(
    name: 'Cards',
    children: [
      _widgetbook.WidgetbookFolder(
        name: 'InfoCard',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'InfoCard',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _widgetbook_workspace_use_cases_cards_usecases
                    .buildInfoCardDefault,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'With Icon',
                builder: _widgetbook_workspace_use_cases_cards_usecases
                    .buildInfoCardWithIcon,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'UserCard',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'UserCard',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _widgetbook_workspace_use_cases_cards_usecases
                    .buildUserCardDefault,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Verified User',
                builder: _widgetbook_workspace_use_cases_cards_usecases
                    .buildUserCardVerified,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'With Avatar',
                builder: _widgetbook_workspace_use_cases_cards_usecases
                    .buildUserCardWithAvatar,
              ),
            ],
          ),
        ],
      ),
    ],
  ),
  _widgetbook.WidgetbookCategory(
    name: 'Inputs',
    children: [
      _widgetbook.WidgetbookFolder(
        name: 'AppSearchField',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'AppSearchField',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Custom Placeholder',
                builder: _widgetbook_workspace_use_cases_inputs_usecases
                    .buildSearchFieldCustom,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _widgetbook_workspace_use_cases_inputs_usecases
                    .buildSearchFieldDefault,
              ),
            ],
          ),
        ],
      ),
      _widgetbook.WidgetbookFolder(
        name: 'AppTextField',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'AppTextField',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'Default',
                builder: _widgetbook_workspace_use_cases_inputs_usecases
                    .buildTextFieldDefault,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Disabled',
                builder: _widgetbook_workspace_use_cases_inputs_usecases
                    .buildTextFieldDisabled,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'With Error',
                builder: _widgetbook_workspace_use_cases_inputs_usecases
                    .buildTextFieldError,
              ),
            ],
          ),
        ],
      ),
    ],
  ),
  _widgetbook.WidgetbookCategory(
    name: 'Typography',
    children: [
      _widgetbook.WidgetbookFolder(
        name: 'AppText',
        children: [
          _widgetbook.WidgetbookComponent(
            name: 'AppText',
            useCases: [
              _widgetbook.WidgetbookUseCase(
                name: 'All Variants',
                builder: _widgetbook_workspace_use_cases_typography_usecases
                    .buildAllVariants,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Custom Colors',
                builder: _widgetbook_workspace_use_cases_typography_usecases
                    .buildCustomColors,
              ),
              _widgetbook.WidgetbookUseCase(
                name: 'Interactive',
                builder: _widgetbook_workspace_use_cases_typography_usecases
                    .buildInteractiveText,
              ),
            ],
          ),
        ],
      ),
    ],
  ),
];
