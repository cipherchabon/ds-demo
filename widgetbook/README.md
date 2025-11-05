# Widgetbook Workspace

Catálogo interactivo de componentes del sistema de diseño para el proyecto DemoApp.

## 🎯 ¿Qué es esto?

Este es el **Widgetbook** del proyecto, un catálogo visual e interactivo de todos los componentes del sistema de diseño. Funciona como un "Storybook" para Flutter, permitiendo:

- 👀 Visualizar componentes aislados
- 🎨 Probar diferentes estados y variantes
- 🔧 Ajustar props con knobs interactivos
- 📱 Ver componentes en diferentes dispositivos
- 🌗 Probar en temas claro/oscuro
- 🔗 Comparar implementación con diseño de Figma

## 🚀 Inicio Rápido

### Ejecutar localmente

```bash
# Desde el directorio raíz del proyecto
cd widgetbook

# Instalar dependencias
flutter pub get

# Generar código (necesario después de cambios en use-cases)
dart run build_runner build --delete-conflicting-outputs

# Ejecutar en Chrome
flutter run -d chrome

# O en un dispositivo/emulador
flutter run
```

El Widgetbook se abrirá en http://localhost:XXXXX (el puerto se mostrará en consola).

### Generar código

Cada vez que modifiques o agregues use-cases, debes regenerar:

```bash
dart run build_runner build --delete-conflicting-outputs
```

O usa watch mode para regenerar automáticamente:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

## 📁 Estructura del Proyecto

```
widgetbook/
├── lib/
│   ├── main.dart                  # Configuración principal de Widgetbook
│   ├── use_cases/                 # Use-cases de componentes
│   │   ├── buttons_usecases.dart  # Use-cases de botones
│   │   ├── cards_usecases.dart    # Use-cases de tarjetas
│   │   ├── inputs_usecases.dart   # Use-cases de inputs
│   │   └── typography_usecases.dart
│   └── fixtures/                  # Datos de ejemplo reutilizables
│       └── user_fixtures.dart     # Fixtures de usuarios
├── pubspec.yaml                   # Dependencias del widgetbook
└── README.md                      # Este archivo
```

## ✍️ Cómo Agregar un Nuevo Componente

### Paso 1: Crear el componente en el proyecto principal

Primero, crea tu componente en el proyecto principal:

```dart
// lib/design_system/buttons/app_button.dart
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Tu implementación...
  }
}
```

### Paso 2: Crear use-cases en Widgetbook

Crea un archivo en `widgetbook/lib/use_cases/`:

```dart
// widgetbook/lib/use_cases/buttons_usecases.dart
import 'package:demoapp/design_system/buttons/app_button.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// Use-case interactivo con knobs
@widgetbook.UseCase(
  name: 'Interactive',
  type: AppButton,
  path: '[Buttons]/AppButton',
  designLink: 'https://www.figma.com/design/.../node-id=1-131', // Opcional
)
Widget buildInteractiveButton(BuildContext context) {
  return AppButton(
    text: context.knobs.string(
      label: 'Text',
      initialValue: 'Click me',
    ),
    onPressed: context.knobs.boolean(label: 'Enabled')
        ? () => debugPrint('Button pressed')
        : null,
  );
}

// Use-case específico
@widgetbook.UseCase(
  name: 'Default',
  type: AppButton,
  path: '[Buttons]/AppButton/States',
)
Widget buildDefaultButton(BuildContext context) {
  return const AppButton(
    text: 'Default Button',
  );
}
```

### Paso 3: Generar código

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Paso 4: Ver en Widgetbook

```bash
flutter run -d chrome
```

El componente aparecerá en el sidebar bajo `Buttons > AppButton`.

## 🎨 Mejores Prácticas

### Organización de Use-Cases

Usa `path` para organizar jerárquicamente:

```dart
path: '[Category]/ComponentName/Subcategory'

// Ejemplos:
path: '[Buttons]/AppButton'              // Raíz del componente
path: '[Buttons]/AppButton/States'       // Estados específicos
path: '[Buttons]/AppButton/Edge Cases'   // Casos extremos
```

### Tipos de Use-Cases

Para cada componente, crea al menos:

1. **Interactive:** Con knobs para explorar todas las props
2. **Default:** Estado por defecto del componente
3. **Estados específicos:** Disabled, Loading, Error, etc.
4. **Edge cases:** Textos largos, sin datos, etc.

**Ejemplo:**

```dart
// 1. Interactive
@widgetbook.UseCase(name: 'Interactive', ...)
Widget buildInteractive(BuildContext context) {
  return Component(
    text: context.knobs.string(...),
    enabled: context.knobs.boolean(...),
  );
}

// 2. Default
@widgetbook.UseCase(name: 'Default', ...)
Widget buildDefault(BuildContext context) {
  return const Component(text: 'Hello');
}

// 3. Estados específicos
@widgetbook.UseCase(name: 'Disabled', ...)
Widget buildDisabled(BuildContext context) {
  return const Component(text: 'Hello', enabled: false);
}

// 4. Edge cases
@widgetbook.UseCase(name: 'Long Text', ...)
Widget buildLongText(BuildContext context) {
  return const Component(
    text: 'Este es un texto muy largo que puede causar overflow...',
  );
}
```

### Usar Fixtures para Datos

En lugar de hardcodear datos, usa fixtures:

```dart
// ❌ NO HACER
@widgetbook.UseCase(...)
Widget buildCard(BuildContext context) {
  return UserCard(
    name: 'Juan Pérez',
    email: 'juan@example.com',
  );
}

// ✅ HACER
import '../fixtures/user_fixtures.dart';

@widgetbook.UseCase(...)
Widget buildCard(BuildContext context) {
  const user = UserFixtures.standard;
  return UserCard(
    name: user.name,
    email: user.email,
  );
}
```

### Agregar Links de Figma

Agrega `designLink` para permitir comparación con diseño:

```dart
@widgetbook.UseCase(
  name: 'Primary',
  type: AppButton,
  path: '[Buttons]/AppButton',
  designLink: 'https://www.figma.com/design/FILE_ID/FILE_NAME?node-id=NODE_ID',
)
```

Cómo obtener el link:
1. Abre Figma
2. Selecciona el frame del componente
3. Click derecho → "Copy link to selection"
4. Pega el link en el use-case

## 🔧 Knobs Disponibles

Los knobs permiten modificar props en tiempo real:

```dart
// String
context.knobs.string(
  label: 'Title',
  initialValue: 'Hello',
)

// Boolean
context.knobs.boolean(
  label: 'Enabled',
  initialValue: true,
)

// Number (double)
context.knobs.double.slider(
  label: 'Opacity',
  initialValue: 1.0,
  min: 0.0,
  max: 1.0,
)

// Integer
context.knobs.int.slider(
  label: 'Items',
  initialValue: 5,
  min: 0,
  max: 10,
)

// Dropdown (enum)
context.knobs.dropdown<ButtonVariant>(
  label: 'Variant',
  options: ButtonVariant.values,
  initialOption: ButtonVariant.primary,
)

// Dropdown con object
context.knobs.object.dropdown<IconData>(
  label: 'Icon',
  options: [Icons.home, Icons.search, Icons.settings],
  labelBuilder: (icon) => icon.toString(),
)

// Nullable dropdown
context.knobs.objectOrNull.dropdown<IconData>(
  label: 'Icon',
  options: [Icons.home, Icons.search],
)

// Color
context.knobs.color(
  label: 'Background',
  initialValue: Colors.blue,
)

// List
context.knobs.list<String>(
  label: 'Items',
  options: ['A', 'B', 'C'],
  labelBuilder: (item) => item,
)
```

## 🎛️ Addons Configurados

En `main.dart` están configurados estos addons:

- **🖥️ Viewport:** Simula diferentes dispositivos (iPhone, iPad, Android)
- **🎨 Theme:** Cambia entre tema claro y oscuro
- **🌐 Localization:** Cambia idioma (actualmente: español)
- **📐 Alignment:** Alinea componentes (center, top-left, etc.)

Addons adicionales disponibles (actualmente comentados):

- **📏 Grid:** Muestra grid de alineación
- **🔍 Zoom:** Hace zoom en componentes
- **📝 TextScale:** Prueba con diferentes tamaños de texto
- **🔎 Inspector:** Inspecciona la estructura del widget

Para habilitarlos, descomenta en `main.dart:35-41`.

## 📊 Coverage

Verifica qué componentes están catalogados:

```bash
# Ver coverage
widgetbook coverage --path lib/

# Con threshold (falla si < 80%)
widgetbook coverage --path lib/ --threshold 80
```

Output ejemplo:
```
📊 Widgetbook Coverage Report

Total widgets: 10
Cataloged widgets: 8
Coverage: 80.0%

✅ Cataloged:
  - AppButton
  - InfoCard
  - UserCard
  ...

❌ Not cataloged:
  - SomeOtherWidget
  - AnotherWidget
```

## ☁️ Widgetbook Cloud

Este proyecto está configurado para subir automáticamente a Widgetbook Cloud en cada push/PR.

### Ver en Cloud

- URL: https://app.widgetbook.io
- Proyecto: DemoApp Design System

### ¿Cómo funciona?

1. Haces commit y push a GitHub
2. GitHub Actions ejecuta el workflow `.github/workflows/widgetbook.yml`
3. El workflow:
   - Genera el Widgetbook
   - Construye para web
   - Sube a Widgetbook Cloud
4. Un comentario automático aparece en el PR con el link

### Ver builds anteriores

En Widgetbook Cloud puedes:
- Ver builds de diferentes branches
- Comparar cambios entre commits
- Ver el histórico completo

## 🐛 Troubleshooting

### "Error: build_runner failed"

**Problema:** Anotaciones incorrectas o código inválido

**Solución:**
```bash
# Limpia builds anteriores
flutter clean

# Reinstala dependencias
flutter pub get

# Regenera con verbose output
dart run build_runner build --delete-conflicting-outputs --verbose
```

### "No veo mi componente en Widgetbook"

**Checklist:**
- ✅ ¿Agregaste la anotación `@widgetbook.UseCase`?
- ✅ ¿Ejecutaste `dart run build_runner build`?
- ✅ ¿Reiniciaste la app?
- ✅ ¿El componente está en el proyecto principal (no en widgetbook)?

### "Hot reload no funciona en Widgetbook"

**Problema:** Los cambios en use-cases requieren regeneración

**Solución:**
- Usa `dart run build_runner watch` en lugar de `build`
- O regenera manualmente después de cada cambio

### "Error: WIDGETBOOK_API_KEY not found" (en CI)

**Problema:** El secret no está configurado en GitHub

**Solución:**
- Ve a GitHub → Settings → Secrets → Actions
- Agrega `WIDGETBOOK_API_KEY` con el valor correcto
- Ver [docs/GITHUB_SETUP.md](../docs/GITHUB_SETUP.md)

## 📚 Recursos

- [Documentación oficial de Widgetbook](https://docs.widgetbook.io)
- [Guía de uso completa](../docs/GUIA_USO_WIDGETBOOK.md)
- [Workflow del equipo](../docs/TEAM_WORKFLOW.md)
- [Integración con Figma](../docs/figma_integration.md)
- [Testing y Mocking](../docs/mocking_testing.md)

## 🤝 Contribuir

### Agregar un nuevo componente

1. Implementa el componente en `lib/design_system/`
2. Crea use-cases en `widgetbook/lib/use_cases/`
3. Agrega fixtures si es necesario en `widgetbook/lib/fixtures/`
4. Genera código: `dart run build_runner build -d`
5. Prueba localmente: `flutter run -d chrome`
6. Commit y push

### Modificar un componente existente

1. Modifica el componente en `lib/design_system/`
2. Actualiza use-cases si es necesario
3. Regenera: `dart run build_runner build -d`
4. Verifica que no rompiste otros use-cases
5. Commit y push

## 💡 Tips

- 🔄 Usa `watch` mode durante desarrollo: `dart run build_runner watch -d`
- 📱 Prueba en diferentes devices usando el addon Viewport
- 🌗 Siempre prueba en tema claro Y oscuro
- 📸 Toma screenshots de Widgetbook para documentación
- 🔗 Agrega designLinks para facilitar revisiones de diseño
- 🧪 Usa fixtures en lugar de hardcodear datos
- 📏 Crea use-cases de edge cases (textos largos, sin datos, etc.)

---

**¿Preguntas o problemas?**

- 📖 Consulta la [documentación completa](../docs/)
- 🐛 Reporta issues en GitHub
- 💬 Pregunta en el canal de Slack del equipo
