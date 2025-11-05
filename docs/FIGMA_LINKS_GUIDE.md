# Guía: Cómo Obtener Links de Figma para Widgetbook

## Introducción

Los `designLink` en Widgetbook permiten a los diseñadores comparar la implementación real de un componente con el diseño en Figma usando el overlay de Figma en Widgetbook Cloud.

## Paso 1: Acceder a Figma

1. Abre tu archivo de diseño en Figma
2. Ejemplo: [ds-demo](https://www.figma.com/design/eu4y7kUHlOnPQsu160wZkX/ds-demo)

## Paso 2: Seleccionar el Componente/Frame

1. En el panel izquierdo (Layers), navega hasta el componente que quieres enlazar
2. Click en el frame o componente específico (ej: "Button/Primary")
3. El componente debe estar **seleccionado** (borde azul alrededor)

## Paso 3: Copiar el Link

### Opción A: Desde el menú contextual

1. Click derecho en el componente seleccionado
2. Selecciona **"Copy link to selection"** o **"Copiar enlace a la selección"**
3. El link se copia al portapapeles

### Opción B: Desde la barra de herramientas

1. Con el componente seleccionado
2. Click en el botón **Share** (arriba a la derecha)
3. Click en **"Copy link"**
4. Asegúrate de que la opción **"Link to selected frame"** esté marcada

## Paso 4: Entender la Estructura del Link

Un link de Figma típico se ve así:

```
https://www.figma.com/design/[FILE_ID]/[FILE_NAME]?node-id=[NODE_ID]&t=[TOKEN]
```

**Componentes:**
- `FILE_ID`: ID único del archivo de Figma (ej: `eu4y7kUHlOnPQsu160wZkX`)
- `FILE_NAME`: Nombre del archivo (ej: `ds-demo`)
- `NODE_ID`: ID único del frame/componente seleccionado (ej: `1-131`)
- `TOKEN`: Token de sesión (opcional, se puede omitir)

### Ejemplo Real

```
https://www.figma.com/design/eu4y7kUHlOnPQsu160wZkX/ds-demo?node-id=1-131&t=QO0UDXS46aSqMwRT-4
```

## Paso 5: Agregar el Link al Use-Case

```dart
@widgetbook.UseCase(
  name: 'Primary',
  type: AppButton,
  path: '[Buttons]/AppButton/States',
  designLink: 'https://www.figma.com/design/eu4y7kUHlOnPQsu160wZkX/ds-demo?node-id=1-131',
)
Widget buildPrimaryButton(BuildContext context) {
  return AppButton(
    text: 'Primary Button',
    variant: ButtonVariant.primary,
    onPressed: () {},
  );
}
```

## Best Practices

### 1. Mapeo 1:1 entre Figma y Widgetbook

Cada **variante** de un componente en Figma debería tener su propio use-case en Widgetbook con su designLink específico.

**En Figma:**
```
Components/
  Button/
    Primary      → node-id=1-131
    Secondary    → node-id=1-132
    Disabled     → node-id=1-133
    Loading      → node-id=1-134
```

**En Widgetbook:**
```dart
// Use-case para Primary con su node-id específico
@widgetbook.UseCase(
  name: 'Primary',
  designLink: '...?node-id=1-131',
)

// Use-case para Secondary con su node-id específico
@widgetbook.UseCase(
  name: 'Secondary',
  designLink: '...?node-id=1-132',
)
```

### 2. Organización Consistente

Usa la **misma nomenclatura** en Figma y Widgetbook:

- Si en Figma se llama "Primary Button" → en Widgetbook `name: 'Primary'`
- Si en Figma está en "Components/Buttons" → en Widgetbook `path: '[Buttons]/AppButton'`

### 3. Documentar el Mapeo

Crea una tabla de referencia para tu equipo:

| Componente Widgetbook | Ubicación Figma | Node ID |
|-----------------------|-----------------|---------|
| AppButton - Primary   | Components/Button/Primary | 1-131 |
| AppButton - Secondary | Components/Button/Secondary | 1-132 |
| AppButton - Disabled  | Components/Button/Disabled | 1-133 |
| AppButton - Loading   | Components/Button/Loading | 1-134 |
| InfoCard - Default    | Components/Cards/Info | 2-101 |

### 4. Validar los Links

Antes de hacer commit, **valida** que el link funciona:

1. Copia el link
2. Pégalo en un navegador
3. Verifica que te lleva al frame correcto en Figma
4. Si no funciona, el `node-id` puede haber cambiado

### 5. Mantener Sincronizados

Cuando un diseñador actualiza Figma:

1. **No cambies el node-id** a menos que sea absolutamente necesario
2. Si el node-id cambia, actualiza el `designLink` en Widgetbook
3. Comunica los cambios al equipo

## Workflow: Diseñador → Desarrollador

### Para Diseñadores

1. Crea o actualiza el componente en Figma
2. Selecciona el frame del componente
3. Copia el link (click derecho → Copy link to selection)
4. Comparte el link con el desarrollador (Slack, Jira, GitHub issue, etc.)

**Mensaje ejemplo:**
```
🎨 Nuevo componente: Primary Button
Figma: https://www.figma.com/design/eu4y7kUHlOnPQsu160wZkX/ds-demo?node-id=1-131

Especificaciones:
- Color: Primary blue (#2196F3)
- Padding: 16px horizontal, 12px vertical
- Border radius: 8px
```

### Para Desarrolladores

1. Recibe el link de Figma
2. Implementa el componente
3. Crea el use-case en Widgetbook
4. Agrega el `designLink` proporcionado por el diseñador
5. Push → CI build → Widgetbook Cloud
6. Notifica al diseñador para revisión

**Mensaje ejemplo:**
```
✅ Primary Button implementado
Widgetbook: [link del PR con Widgetbook Cloud]

Por favor revisa usando el overlay de Figma en Widgetbook Cloud
```

### Para Diseñadores (Revisión)

1. Abre el link de Widgetbook Cloud
2. Navega al use-case del componente
3. Click en el icono de Figma (overlay)
4. Compara la implementación con el diseño
5. Aprueba o solicita cambios

## Troubleshooting

### "El link no funciona"

- **Problema:** El link redirige a la página principal del archivo
- **Solución:** El `node-id` puede haber cambiado. Selecciona el frame nuevamente y copia el link

### "No veo el botón de Figma en Widgetbook Cloud"

- **Problema:** El `designLink` no está configurado o es inválido
- **Solución:**
  1. Verifica que el `designLink` esté en la anotación del use-case
  2. Ejecuta `dart run build_runner build -d` para regenerar
  3. Haz rebuild y push

### "El overlay no coincide"

- **Problema:** El diseño en Figma fue actualizado pero el componente no
- **Solución:**
  1. Compara las especificaciones (tamaño, color, padding)
  2. Actualiza el componente para que coincida
  3. O solicita al diseñador aclaración

### "Tengo permisos para ver Figma"

- **Problema:** El link requiere permisos de visualización
- **Solución:**
  1. El diseñador debe compartir el archivo con el equipo
  2. O cambiar la configuración a "Anyone with the link can view"

## Ejemplo Completo: Flujo de Trabajo

### 1. Diseñador crea componente

```
Figma: Buttons/Primary (node-id: 1-131)
```

### 2. Diseñador comparte en GitHub Issue

```markdown
## Nuevo componente: Primary Button

**Figma:** https://www.figma.com/design/.../ds-demo?node-id=1-131

**Specs:**
- Background: #2196F3
- Text: #FFFFFF
- Height: 48px
- Border radius: 8px
```

### 3. Desarrollador implementa

```dart
// lib/design_system/buttons/app_button.dart
class AppButton extends StatelessWidget {
  final String text;
  final ButtonVariant variant;
  final VoidCallback? onPressed;
  // ...
}
```

### 4. Desarrollador crea use-case

```dart
// widgetbook/lib/use_cases/buttons_usecases.dart
@widgetbook.UseCase(
  name: 'Primary',
  type: AppButton,
  path: '[Buttons]/AppButton',
  designLink: 'https://www.figma.com/design/.../ds-demo?node-id=1-131',
)
Widget buildPrimaryButton(BuildContext context) {
  return AppButton(
    text: 'Primary Button',
    variant: ButtonVariant.primary,
    onPressed: () {},
  );
}
```

### 5. CI/CD publica a Widgetbook Cloud

### 6. Diseñador revisa en Widgetbook Cloud

```
✅ Aprobado - Coincide con diseño
❌ Solicitar cambios - Border radius es 4px en lugar de 8px
```

## Recursos

- [Documentación oficial de Figma Integration](./figma_integration.md)
- [Guía de uso de Widgetbook](./GUIA_USO_WIDGETBOOK.md)
- [Workflow del equipo](./TEAM_WORKFLOW.md) ← (próximamente)

## Notas para esta Demo

En esta demo, los `node-id` son **simulados** con propósitos de ejemplo:
- `1-131`: Primary Button
- `1-132`: Secondary Button
- `1-133`: Disabled Button
- `1-134`: Loading Button

En un **proyecto real**, debes:
1. Abrir tu archivo de Figma
2. Seleccionar cada frame específico
3. Copiar el link real con el `node-id` correcto
4. Reemplazar los links en los use-cases
