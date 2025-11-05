import 'package:demoapp/design_system/typography/app_text.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Interactive',
  type: AppText,
  path: '[Typography]/AppText',
)
Widget buildInteractiveText(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: AppText(
      context.knobs.string(label: 'Text', initialValue: 'Texto de ejemplo'),
      variant: context.knobs.object.dropdown<TextVariant>(
        label: 'Variant',
        options: TextVariant.values,
        initialOption: TextVariant.body,
        labelBuilder: (v) => v.name.toUpperCase(),
      ),
      color: context.knobs.colorOrNull(label: 'Color', initialValue: null),
      textAlign: context.knobs.objectOrNull.dropdown<TextAlign>(
        label: 'Text Align',
        options: [
          TextAlign.left,
          TextAlign.center,
          TextAlign.right,
          TextAlign.justify,
        ],
        labelBuilder: (align) => align.toString().split('.').last,
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'All Variants',
  type: AppText,
  path: '[Typography]/AppText',
)
Widget buildAllVariants(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText('Heading 1', variant: TextVariant.h1),
        SizedBox(height: 16),
        AppText('Heading 2', variant: TextVariant.h2),
        SizedBox(height: 16),
        AppText('Heading 3', variant: TextVariant.h3),
        SizedBox(height: 16),
        AppText(
          'Este es un texto de cuerpo (body). Es ideal para párrafos largos y contenido principal.',
          variant: TextVariant.body,
        ),
        SizedBox(height: 16),
        AppText(
          'Este es un texto de caption. Se usa para texto secundario o notas.',
          variant: TextVariant.caption,
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'Custom Colors',
  type: AppText,
  path: '[Typography]/AppText',
)
Widget buildCustomColors(BuildContext context) {
  return const Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText('Texto en azul', variant: TextVariant.h2, color: Colors.blue),
        SizedBox(height: 16),
        AppText('Texto en rojo', variant: TextVariant.body, color: Colors.red),
        SizedBox(height: 16),
        AppText(
          'Texto en verde',
          variant: TextVariant.caption,
          color: Colors.green,
        ),
      ],
    ),
  );
}
