import 'package:demoapp/design_system/buttons/app_button.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Interactive',
  type: AppButton,
  path: '[Buttons]/AppButton',
)
Widget buildInteractiveButton(BuildContext context) {
  return Center(
    child: AppButton(
      text: context.knobs.string(label: 'Text', initialValue: 'Click me'),
      variant: context.knobs.object.dropdown<ButtonVariant>(
        label: 'Variant',
        options: ButtonVariant.values,
        initialOption: ButtonVariant.primary,
        labelBuilder: (v) => v.name.toUpperCase(),
      ),
      isLoading: context.knobs.boolean(label: 'Loading', initialValue: false),
      onPressed: context.knobs.boolean(label: 'Enabled', initialValue: true)
          ? () => debugPrint('Button pressed!')
          : null,
    ),
  );
}

@widgetbook.UseCase(
  name: 'Primary',
  type: AppButton,
  path: '[Buttons]/AppButton/States',
)
Widget buildPrimaryButton(BuildContext context) {
  return Center(
    child: AppButton(
      text: 'Primary Button',
      variant: ButtonVariant.primary,
      onPressed: () => debugPrint('Primary button pressed'),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Secondary',
  type: AppButton,
  path: '[Buttons]/AppButton/States',
)
Widget buildSecondaryButton(BuildContext context) {
  return Center(
    child: AppButton(
      text: 'Secondary Button',
      variant: ButtonVariant.secondary,
      onPressed: () => debugPrint('Secondary button pressed'),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Disabled',
  type: AppButton,
  path: '[Buttons]/AppButton/States',
)
Widget buildDisabledButton(BuildContext context) {
  return Center(
    child: AppButton(
      text: 'Disabled Button',
      variant: ButtonVariant.primary,
      onPressed: null,
    ),
  );
}

@widgetbook.UseCase(
  name: 'Loading',
  type: AppButton,
  path: '[Buttons]/AppButton/States',
)
Widget buildLoadingButton(BuildContext context) {
  return Center(
    child: AppButton(
      text: 'Loading',
      variant: ButtonVariant.primary,
      isLoading: true,
      onPressed: () {},
    ),
  );
}
