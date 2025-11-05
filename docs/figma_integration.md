## Integración con Figma

Widgetbook Cloud permite comparar tus implementaciones de Flutter con los diseños originales de Figma, facilitando el proceso de Design QA.

### Configuración

#### Paso 1: Obtener Link de Figma

1. Abre tu archivo de Figma
2. Selecciona el frame o component que corresponde al widget
3. Right-click → `Copy/Paste as` → `Copy link`
4. El link tendrá formato: `https://www.figma.com/file/FILE_ID/FILE_NAME?node-id=NODE_ID`

#### Paso 2: Agregar designLink al Use-Case

```dart
@widgetbook.UseCase(
  name: 'Primary Button',
  type: AppButton,
  path: '[Buttons]/Primary',
  designLink: 'https://www.figma.com/file/abc123/DesignSystem?node-id=123-456',
)
Widget buildPrimaryButton(BuildContext context) {
  return AppButton(
    text: 'Primary Button',
    onPressed: () {},
  );
}
```

#### Paso 3: Regenerar y Hacer Push

```bash
# Regenerar archivos
dart run build_runner build -d

# Commit y push
git add .
git commit -m "feat: add Figma link to primary button"
git push

# El CI/CD automáticamente hará push a Widgetbook Cloud
```

### Uso en Widgetbook Cloud

Una vez que el build esté en Widgetbook Cloud:

1. **Abrir el use-case** en Widgetbook Cloud
2. **Activar Figma overlay**: Click en el botón "Figma" en la toolbar
3. **Ajustar overlay**:
   - Opacidad del overlay
   - Posición (drag & drop)
   - Escala (zoom)
4. **Comparar** visualmente el diseño vs implementación
5. **Detectar diferencias**:
   - Spacing incorrecto
   - Colores ligeramente diferentes
   - Tamaños de fuente
   - Bordes y sombras
   - Íconos

### Ejemplo Completo: Design System con Figma Links

```dart
// widgetbook/lib/buttons/button_usecases.dart
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Primary',
  type: AppButton,
  path: '[Buttons]/AppButton',
  designLink: 'https://www.figma.com/file/xxx/DS?node-id=101-201',
)
Widget buildPrimaryButton(BuildContext context) {
  return AppButton.primary(
    text: context.knobs.string(label: 'Text', initialValue: 'Primary'),
    onPressed: () {},
  );
}

@widgetbook.UseCase(
  name: 'Secondary',
  type: AppButton,
  path: '[Buttons]/AppButton',
  designLink: 'https://www.figma.com/file/xxx/DS?node-id=101-202',
)
Widget buildSecondaryButton(BuildContext context) {
  return AppButton.secondary(
    text: context.knobs.string(label: 'Text', initialValue: 'Secondary'),
    onPressed: () {},
  );
}

@widgetbook.UseCase(
  name: 'Disabled',
  type: AppButton,
  path: '[Buttons]/AppButton',
  designLink: 'https://www.figma.com/file/xxx/DS?node-id=101-203',
)
Widget buildDisabledButton(BuildContext context) {
  return AppButton.primary(
    text: 'Disabled',
    onPressed: null,
  );
}

// widgetbook/lib/cards/info_card_usecases.dart
@widgetbook.UseCase(
  name: 'Default',
  type: InfoCard,
  path: '[Cards]/InfoCard',
  designLink: 'https://www.figma.com/file/xxx/DS?node-id=201-301',
)
Widget buildInfoCard(BuildContext context) {
  return InfoCard(
    title: context.knobs.string(label: 'Title', initialValue: 'Information'),
    description: context.knobs.string(
      label: 'Description',
      initialValue: 'This is an informational card with some content.',
    ),
    icon: Icons.info_outline,
  );
}

@widgetbook.UseCase(
  name: 'Success',
  type: InfoCard,
  path: '[Cards]/InfoCard',
  designLink: 'https://www.figma.com/file/xxx/DS?node-id=201-302',
)
Widget buildSuccessCard(BuildContext context) {
  return InfoCard.success(
    title: 'Success!',
    description: 'Your action completed successfully.',
  );
}

@widgetbook.UseCase(
  name: 'Error',
  type: InfoCard,
  path: '[Cards]/InfoCard',
  designLink: 'https://www.figma.com/file/xxx/DS?node-id=201-303',
)
Widget buildErrorCard(BuildContext context) {
  return InfoCard.error(
    title: 'Error',
    description: 'Something went wrong. Please try again.',
  );
}
```

### Multi-Snapshot con Figma

Puedes combinar Figma links con multi-snapshot para capturar múltiples variantes:

```dart
@widgetbook.App(
  cloudAddonsConfigs: {
    'Mobile Light': [
      ViewportAddonConfig(Viewports.mobile.first),
      ThemeAddonConfig('Light'),
    ],
    'Mobile Dark': [
      ViewportAddonConfig(Viewports.mobile.first),
      ThemeAddonConfig('Dark'),
    ],
    'Tablet Light': [
      ViewportAddonConfig(Viewports.tablet),
      ThemeAddonConfig('Light'),
    ],
  },
)
class WidgetbookApp extends StatelessWidget {
  // ...
}

@widgetbook.UseCase(
  name: 'Responsive Card',
  type: ProductCard,
  designLink: 'https://www.figma.com/file/xxx/DS?node-id=301-401',
  cloudKnobsConfigs: {
    'Short Content': [
      StringKnobConfig('title', 'Product'),
      StringKnobConfig('description', 'Short desc'),
    ],
    'Long Content': [
      StringKnobConfig('title', 'Very Long Product Name That Wraps'),
      StringKnobConfig('description', 'This is a much longer description that will test how the card handles text overflow and wrapping behavior.'),
    ],
  },
)
Widget buildProductCard(BuildContext context) {
  return ProductCard(
    title: context.knobs.string(label: 'Title', initialValue: 'Product'),
    description: context.knobs.string(label: 'Description', initialValue: 'Description'),
  );
}
```

Esto generará múltiples snapshots en Widgetbook Cloud, cada uno con su respectivo Figma overlay para comparación.

### Workflow de Design QA

1. **Designer** actualiza componente en Figma
2. **Developer** implementa el componente en Flutter
3. **Developer** agrega/actualiza el `designLink` en el use-case
4. **Developer** hace commit y push
5. **CI/CD** genera build y lo sube a Widgetbook Cloud
6. **Designer** abre Widgetbook Cloud y activa Figma overlay
7. **Designer** compara pixel-perfect y reporta discrepancias
8. **Developer** ajusta implementación
9. **Repeat** hasta que coincida perfectamente

### Tips para Figma Integration

- **Organización**: Usa la misma estructura de paths en Widgetbook que en Figma
- **Naming**: Nombra los use-cases igual que los components en Figma
- **Variants**: Crea un use-case por cada variant del component en Figma
- **Responsive**: Usa multi-snapshot para probar diferentes viewports si el diseño es responsive
- **Estados**: Crea use-cases para todos los estados (default, hover, pressed, disabled, loading, error)

---
