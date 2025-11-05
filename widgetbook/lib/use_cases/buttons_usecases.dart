import 'package:demoapp/design_system/buttons/app_button.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Use-case interactivo del AppButton
///
/// Este es el punto de partida de la demo de Widgetbook.
/// Permite explorar todas las variantes y estados del botón usando knobs.
@widgetbook.UseCase(
  name: 'Interactive',
  type: AppButton,
  path: '[Buttons]/AppButton',
)
Widget buildAppButtonInteractive(BuildContext context) {
  return Center(
    child: AppButton(
      text: context.knobs.string(
        label: 'Text',
        initialValue: 'Click me',
      ),
      variant: context.knobs.object.dropdown<ButtonVariant>(
        label: 'Variant',
        options: ButtonVariant.values,
        initialOption: ButtonVariant.primary,
        labelBuilder: (variant) => variant.name.toUpperCase(),
      ),
      isLoading: context.knobs.boolean(
        label: 'Loading',
        initialValue: false,
      ),
      onPressed: context.knobs.boolean(
        label: 'Enabled',
        initialValue: true,
      )
          ? () => debugPrint('Button pressed!')
          : null,
    ),
  );
}
