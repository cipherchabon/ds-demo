import 'package:demoapp/design_system/inputs/app_search_field.dart';
import 'package:demoapp/design_system/inputs/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// AppTextField Use-Cases
@widgetbook.UseCase(
  name: 'Default',
  type: AppTextField,
  path: '[Inputs]/AppTextField',
)
Widget buildTextFieldDefault(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: AppTextField(
      label: context.knobs.string(
        label: 'Label',
        initialValue: 'Nombre completo',
      ),
      hintText: context.knobs.stringOrNull(
        label: 'Hint Text',
        initialValue: 'Ingresa tu nombre',
      ),
      onChanged: (value) => debugPrint('Text changed: $value'),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Error',
  type: AppTextField,
  path: '[Inputs]/AppTextField',
)
Widget buildTextFieldError(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16),
    child: AppTextField(
      label: 'Email',
      hintText: 'ejemplo@correo.com',
      errorText: 'Por favor ingresa un email válido',
    ),
  );
}

@widgetbook.UseCase(
  name: 'Disabled',
  type: AppTextField,
  path: '[Inputs]/AppTextField',
)
Widget buildTextFieldDisabled(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16),
    child: AppTextField(
      label: 'Teléfono',
      hintText: '+58 412 1234567',
      enabled: false,
    ),
  );
}

// AppSearchField Use-Cases
@widgetbook.UseCase(
  name: 'Default',
  type: AppSearchField,
  path: '[Inputs]/AppSearchField',
)
Widget buildSearchFieldDefault(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: AppSearchField(
      hintText: context.knobs.string(
        label: 'Hint Text',
        initialValue: 'Buscar...',
      ),
      onChanged: (value) => debugPrint('Search: $value'),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Custom Placeholder',
  type: AppSearchField,
  path: '[Inputs]/AppSearchField',
)
Widget buildSearchFieldCustom(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16),
    child: AppSearchField(hintText: 'Buscar productos...'),
  );
}
