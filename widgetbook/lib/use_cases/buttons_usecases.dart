import 'package:demoapp/design_system/buttons/app_button.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

/// Use-case interactivo del AppButton
///
/// Permite explorar todas las variantes y estados del botón usando knobs.
@widgetbook.UseCase(
  name: 'Interactive',
  type: AppButton,
  path: '[Buttons]/AppButton',
  designLink: 'https://www.figma.com/design/eu4y7kUHlOnPQsu160wZkX/ds-demo?node-id=1-131&t=QO0UDXS46aSqMwRT-4',
)
Widget buildAppButtonInteractive(BuildContext context) {
  return Center(
    child: AppButton(
      text: context.knobs.string(
        label: 'Text',
        initialValue: 'Haz click aquí',
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

/// Use-case Primary - Estado por defecto del botón
@widgetbook.UseCase(
  name: 'Primary',
  type: AppButton,
  path: '[Buttons]/AppButton/States',
  designLink: 'https://www.figma.com/design/eu4y7kUHlOnPQsu160wZkX/ds-demo?node-id=1-131',
)
Widget buildAppButtonPrimary(BuildContext context) {
  return Center(
    child: AppButton(
      text: 'Primary Button',
      variant: ButtonVariant.primary,
      onPressed: () => debugPrint('Primary button pressed'),
    ),
  );
}

/// Use-case Secondary - Variante secondary del botón
@widgetbook.UseCase(
  name: 'Secondary',
  type: AppButton,
  path: '[Buttons]/AppButton/States',
  designLink: 'https://www.figma.com/design/eu4y7kUHlOnPQsu160wZkX/ds-demo?node-id=1-131',
)
Widget buildAppButtonSecondary(BuildContext context) {
  return Center(
    child: AppButton(
      text: 'Secondary Button',
      variant: ButtonVariant.secondary,
      onPressed: () => debugPrint('Secondary button pressed'),
    ),
  );
}

/// Use-case Disabled - Botón deshabilitado
@widgetbook.UseCase(
  name: 'Disabled',
  type: AppButton,
  path: '[Buttons]/AppButton/States',
  designLink: 'https://www.figma.com/design/eu4y7kUHlOnPQsu160wZkX/ds-demo?node-id=1-131',
)
Widget buildAppButtonDisabled(BuildContext context) {
  return Center(
    child: AppButton(
      text: 'Disabled Button',
      variant: ButtonVariant.primary,
      onPressed: null, // null = disabled
    ),
  );
}

/// Use-case Loading - Botón en estado de carga
@widgetbook.UseCase(
  name: 'Loading',
  type: AppButton,
  path: '[Buttons]/AppButton/States',
  designLink: 'https://www.figma.com/design/eu4y7kUHlOnPQsu160wZkX/ds-demo?node-id=1-131',
)
Widget buildAppButtonLoading(BuildContext context) {
  return Center(
    child: AppButton(
      text: 'Loading...',
      variant: ButtonVariant.primary,
      isLoading: true,
      onPressed: () {},
    ),
  );
}
