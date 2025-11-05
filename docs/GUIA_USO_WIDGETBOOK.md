# Guía Completa de Widgetbook para Flutter

## Introducción

### ¿Qué es Widgetbook?

**Widgetbook** es un sandbox (entorno aislado) de código abierto y gratuito para Flutter que permite desarrollar y catalogar widgets y pantallas de manera independiente, sin necesidad de ejecutar toda la aplicación.

### Problemas que Resuelve

- **Estados difíciles de alcanzar**: Testing de estados de error, loading, vacío, etc., sin simular flujos completos
- **Tiempo de desarrollo**: No necesitas ejecutar toda la app para probar un widget específico
- **Dependencias externas**: Desarrolla UI sin depender de APIs o fuentes de datos reales
- **Colaboración**: Facilita la revisión con diseñadores, QA y otros desarrolladores
- **Documentación visual**: Catálogo vivo de todos los componentes del design system

### Solución que Ofrece

- Construir UI en aislamiento sin depender de fuentes de datos externas
- Probar widgets en diferentes estados usando **Knobs** (controles dinámicos)
- Probar widgets en diferentes configuraciones (dark mode, idiomas, viewports) usando **Addons**
- Catalogar widgets y pantallas en un solo lugar organizado
- Hosting en la nube con **Widgetbook Cloud** para UI Reviews y detección de regresiones visuales

---

## Configuración Inicial

### Estructura del Proyecto

La estructura recomendada es crear un proyecto Flutter separado para Widgetbook:

```
your_app/
├── pubspec.yaml
├── lib/
│   └── ... (código de tu app)
└── widgetbook/              # Proyecto separado
    ├── pubspec.yaml
    ├── lib/
    │   └── main.dart
    └── ...
```

### Pasos de Instalación

#### 1. Crear el Proyecto Widgetbook

Dentro del directorio de tu aplicación, crea un nuevo proyecto Flutter:

```bash
cd your_app
flutter create widgetbook --empty

# O para plataformas específicas (recomendado para mejor rendimiento):
flutter create widgetbook --empty --platforms=web,macos
```

#### 2. Configurar el Package Name

Edita `widgetbook/pubspec.yaml` para evitar conflicto con el package widgetbook:

```yaml
name: widgetbook_workspace # Cambia esto (default: widgetbook)
description: Widgetbook catalog for your app
publish_to: "none"

environment:
  sdk: ">=3.1.0 <4.0.0"
```

#### 3. Agregar Dependencias

Navega al directorio de widgetbook y agrega las dependencias necesarias:

```bash
cd widgetbook
flutter pub add widgetbook widgetbook_annotation
flutter pub add dev:widgetbook_generator dev:build_runner
```

#### 4. Agregar tu App como Dependencia

En `widgetbook/pubspec.yaml`, agrega tu app principal (o tu package de design system):

```yaml
dependencies:
  flutter:
    sdk: flutter
  widgetbook_annotation: ^3.0.0
  widgetbook: ^3.0.0

  # Tu aplicación principal
  your_app:
    path: ../

  # Si tu design system está en un package separado:
  your_design_system:
    path: ../packages/your_design_system

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.0
  widgetbook_generator: ^3.0.0
```

#### 5. Crear el Archivo Principal

Crea `widgetbook/lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// Este archivo se generará automáticamente
import 'main.directories.g.dart';

void main() {
  runApp(const WidgetbookApp());
}

@widgetbook.App()
class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: directories,
      addons: [
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(
              name: 'Light',
              data: ThemeData.light(),
            ),
            WidgetbookTheme(
              name: 'Dark',
              data: ThemeData.dark(),
            ),
          ],
        ),
      ],
    );
  }
}
```

#### 6. Generar Archivos

```bash
dart run build_runner build -d
```

El flag `-d` elimina archivos generados obsoletos.

#### 7. Ejecutar Widgetbook

```bash
flutter run
```

---

## Conceptos Fundamentales

### Use-Cases

Un **Use-Case** es un estado o variante específica de un componente. Representa una configuración particular del widget que quieres catalogar.

#### Ejemplo Básico

```dart
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:your_app/widgets/cool_button.dart';

@widgetbook.UseCase(name: 'Default', type: CoolButton)
Widget buildCoolButtonUseCase(BuildContext context) {
  return CoolButton(
    text: 'Click me',
    onPressed: () {},
  );
}

@widgetbook.UseCase(name: 'Disabled', type: CoolButton)
Widget buildDisabledButtonUseCase(BuildContext context) {
  return CoolButton(
    text: 'Disabled',
    onPressed: null,
  );
}
```

### Anotaciones

#### @App

Define el punto de entrada de Widgetbook donde se generará el archivo de directorios.

```dart
@widgetbook.App()
class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: directories, // Archivo generado
    );
  }
}
```

#### @UseCase

Define un caso de uso para un componente.

**Parámetros:**

- `name` (requerido): Nombre del use-case
- `type` (requerido): Tipo del widget catalogado
- `path` (opcional): Ruta personalizada en el árbol de navegación
- `designLink` (opcional): URL de Figma para comparación
- `exclude` (opcional): Excluir del archivo generado

**Ejemplo completo:**

```dart
@widgetbook.UseCase(
  name: 'Primary Button',
  type: AppButton,
  path: '[Components]/Buttons',  // [nombre] crea categoría
  designLink: 'https://www.figma.com/file/xxx/yyy?node-id=123',
)
Widget buildPrimaryButton(BuildContext context) {
  return AppButton(
    text: context.knobs.string(label: 'Text', initialValue: 'Primary'),
    style: ButtonStyle.primary,
    onPressed: () {
      // Acción de prueba
      debugPrint('Button pressed!');
    },
  );
}
```

### Generación de Código

Después de crear o modificar use-cases, siempre debes regenerar los archivos:

```bash
# Build único
dart run build_runner build -d

# Watch mode (regenera automáticamente en cada cambio)
dart run build_runner watch -d
```

Esto genera el archivo `main.directories.g.dart` que contiene la estructura del catálogo.

---

## Knobs: Controles Dinámicos

Los **Knobs** permiten modificar parámetros de un widget en tiempo real desde la UI de Widgetbook, sin necesidad de hot reload.

### Tipos de Knobs Disponibles

#### 1. Boolean

```dart
@widgetbook.UseCase(name: 'Configurable', type: MyWidget)
Widget buildMyWidget(BuildContext context) {
  final enabled = context.knobs.boolean(
    label: 'Enabled',
    initialValue: true,
    description: 'Toggle to enable/disable',
  );

  final nullable = context.knobs.booleanOrNull(
    label: 'Optional Flag',
    initialValue: null,
  );

  return MyWidget(enabled: enabled);
}
```

#### 2. Integer

```dart
final count = context.knobs.int.input(
  label: 'Count',
  initialValue: 5,
  description: 'Number of items to display',
);

final rating = context.knobs.int.slider(
  label: 'Rating',
  initialValue: 3,
  min: 1,
  max: 5,
  divisions: 4,
);
```

#### 3. Double

```dart
final opacity = context.knobs.double.slider(
  label: 'Opacity',
  initialValue: 1.0,
  min: 0.0,
  max: 1.0,
  divisions: 10,
);

final price = context.knobs.double.input(
  label: 'Price',
  initialValue: 99.99,
);
```

#### 4. String

```dart
final title = context.knobs.string(
  label: 'Title',
  initialValue: 'Welcome',
  description: 'The title text',
);

final subtitle = context.knobs.stringOrNull(
  label: 'Subtitle',
  initialValue: null,
);
```

#### 5. Duration

```dart
final animationDuration = context.knobs.duration(
  label: 'Animation Duration',
  initialValue: Duration(milliseconds: 300),
);

final timeout = context.knobs.durationOrNull(
  label: 'Timeout',
  initialValue: null,
);
```

#### 6. DateTime

```dart
final selectedDate = context.knobs.dateTime(
  label: 'Date',
  initialValue: DateTime.now(),
  start: DateTime(2020),
  end: DateTime(2030),
);

final optionalDate = context.knobs.dateTimeOrNull(
  label: 'Optional Date',
  initialValue: null,
);
```

#### 7. Color

```dart
final backgroundColor = context.knobs.color(
  label: 'Background Color',
  initialValue: Colors.blue,
);

final borderColor = context.knobs.colorOrNull(
  label: 'Border Color',
  initialValue: null,
);
```

#### 8. List (Iterable) - Segmented Control

```dart
enum ButtonSize { small, medium, large }

final size = context.knobs.list(
  label: 'Size',
  options: ButtonSize.values,
  labelBuilder: (value) => value.name.toUpperCase(),
);

// Con valores nullable
final optionalSize = context.knobs.listOrNull(
  label: 'Optional Size',
  options: ButtonSize.values,
  labelBuilder: (value) => value.name,
);
```

#### 9. Object - Dropdown

```dart
final alignment = context.knobs.object(
  label: 'Alignment',
  initialOption: Alignment.center,
  options: [
    Option(label: 'Top Left', value: Alignment.topLeft),
    Option(label: 'Top Center', value: Alignment.topCenter),
    Option(label: 'Top Right', value: Alignment.topRight),
    Option(label: 'Center', value: Alignment.center),
    Option(label: 'Bottom Left', value: Alignment.bottomLeft),
    Option(label: 'Bottom Center', value: Alignment.bottomCenter),
    Option(label: 'Bottom Right', value: Alignment.bottomRight),
  ],
);
```

#### 10. Object - Segmented Control

```dart
enum IconType { home, settings, profile }

final iconType = context.knobs.object.segmented(
  label: 'Icon',
  initialOption: IconType.home,
  options: [
    Option(label: 'Home', value: IconType.home),
    Option(label: 'Settings', value: IconType.settings),
    Option(label: 'Profile', value: IconType.profile),
  ],
);
```

### Ejemplo Completo con Múltiples Knobs

```dart
@widgetbook.UseCase(name: 'Configurable Card', type: UserCard)
Widget buildConfigurableCard(BuildContext context) {
  return UserCard(
    name: context.knobs.string(
      label: 'Name',
      initialValue: 'John Doe',
    ),
    age: context.knobs.int.slider(
      label: 'Age',
      initialValue: 30,
      min: 18,
      max: 100,
    ),
    isVerified: context.knobs.boolean(
      label: 'Verified',
      initialValue: true,
    ),
    avatarColor: context.knobs.color(
      label: 'Avatar Color',
      initialValue: Colors.blue,
    ),
    status: context.knobs.list(
      label: 'Status',
      options: UserStatus.values,
      labelBuilder: (status) => status.name,
    ),
    bio: context.knobs.stringOrNull(
      label: 'Bio',
      initialValue: null,
    ),
  );
}
```

---

## Addons: Configuraciones Globales

Los **Addons** envuelven todos los use-cases con configuraciones globales que pueden ser controladas desde la UI de Widgetbook.

### Lista Completa de Addons

#### 1. ThemeAddon (Material)

```dart
import 'package:your_app/theme.dart';

@override
Widget build(BuildContext context) {
  return Widgetbook.material(
    directories: directories,
    addons: [
      MaterialThemeAddon(
        themes: [
          WidgetbookTheme(
            name: 'Light',
            data: AppTheme.light(),
          ),
          WidgetbookTheme(
            name: 'Dark',
            data: AppTheme.dark(),
          ),
          WidgetbookTheme(
            name: 'High Contrast',
            data: AppTheme.highContrast(),
          ),
        ],
      ),
    ],
  );
}
```

#### 2. ThemeAddon (Cupertino)

```dart
return Widgetbook.cupertino(
  directories: directories,
  addons: [
    CupertinoThemeAddon(
      themes: [
        WidgetbookTheme(
          name: 'Light',
          data: CupertinoThemeData(brightness: Brightness.light),
        ),
        WidgetbookTheme(
          name: 'Dark',
          data: CupertinoThemeData(brightness: Brightness.dark),
        ),
      ],
    ),
  ],
);
```

#### 3. LocalizationAddon

```dart
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:your_app/l10n/app_localizations.dart';

addons: [
  LocalizationAddon(
    locales: [
      Locale('en', 'US'),
      Locale('es', 'ES'),
      Locale('de', 'DE'),
      Locale('fr', 'FR'),
    ],
    localizationsDelegates: [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
  ),
],
```

#### 4. ViewportAddon

```dart
import 'package:widgetbook/widgetbook.dart';

addons: [
  ViewportAddon(
    devices: [
      // iOS Devices
      ...Viewports.ios,
      // Android Devices
      ...Viewports.android,
      // Desktops
      ...Viewports.desktops,
      // Custom
      Viewport(
        name: 'Custom Tablet',
        size: Size(800, 1200),
      ),
    ],
  ),
],
```

Viewports predefinidos disponibles:

- `Viewports.all` - Todos los dispositivos
- `Viewports.ios` - Dispositivos iOS
- `Viewports.android` - Dispositivos Android
- `Viewports.desktops` - Desktop sizes
- `Viewports.mobile` - Móviles (iOS + Android)

#### 5. AlignmentAddon

```dart
addons: [
  AlignmentAddon(),
],
```

Permite ajustar la alineación del widget en pantalla (TopLeft, Center, BottomRight, etc.)

#### 6. GridAddon

```dart
addons: [
  GridAddon(),
],
```

Muestra una grilla overlay para verificar alineaciones y espaciados.

#### 7. InspectorAddon

```dart
addons: [
  InspectorAddon(),
],
```

Habilita el inspector de widgets de Flutter dentro de Widgetbook.

#### 8. SemanticsAddon

```dart
addons: [
  SemanticsAddon(),
],
```

Muestra información de accesibilidad (semantic labels, hints, etc.)

#### 9. TextScaleAddon

```dart
addons: [
  TextScaleAddon(
    scales: [0.8, 1.0, 1.2, 1.5, 2.0, 3.0],
  ),
],
```

Prueba diferentes escalas de texto para accesibilidad.

#### 10. TimeDilationAddon

```dart
addons: [
  TimeDilationAddon(
    scales: [1.0, 2.0, 5.0, 10.0],
  ),
],
```

Ralentiza las animaciones para debugging (slow motion).

#### 11. ZoomAddon

```dart
addons: [
  ZoomAddon(),
],
```

Permite hacer zoom in/out del widget.

#### 12. AccessibilityAddon

```dart
addons: [
  AccessibilityAddon(),
],
```

Simula diferentes condiciones de accesibilidad como daltonismo.

#### 13. BuilderAddon

```dart
addons: [
  BuilderAddon(
    name: 'Safe Area',
    builder: (context, child) {
      return SafeArea(child: child);
    },
  ),
],
```

Permite envolver todos los use-cases con un widget personalizado.

### Orden de los Addons

**IMPORTANTE**: El orden de los addons importa. Los primeros addons son los más externos en el árbol de widgets.

**Orden recomendado:**

```dart
addons: [
  ViewportAddon(...),      // 1. Más externo
  MaterialThemeAddon(...), // 2.
  LocalizationAddon(...),  // 3.
  AlignmentAddon(),        // 4.
  TextScaleAddon(...),     // 5.
  BuilderAddon(...),       // 6. Más interno
],
```

### Ejemplo Completo con Múltiples Addons

```dart
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:your_app/theme.dart';
import 'package:your_app/l10n/app_localizations.dart';
import 'main.directories.g.dart';

void main() {
  runApp(const WidgetbookApp());
}

@widgetbook.App()
class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: directories,
      addons: [
        // Device & Viewport
        ViewportAddon(
          devices: [
            ...Viewports.ios,
            ...Viewports.android,
          ],
        ),

        // Theme
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(name: 'Light', data: AppTheme.light()),
            WidgetbookTheme(name: 'Dark', data: AppTheme.dark()),
          ],
        ),

        // Localization
        LocalizationAddon(
          locales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
        ),

        // Layout & Alignment
        AlignmentAddon(),
        GridAddon(),

        // Accessibility
        TextScaleAddon(scales: [0.8, 1.0, 1.2, 1.5, 2.0]),
        AccessibilityAddon(),
        SemanticsAddon(),

        // Development
        InspectorAddon(),
        TimeDilationAddon(scales: [1.0, 2.0, 5.0]),
        ZoomAddon(),

        // Custom Wrapper
        BuilderAddon(
          name: 'Padding',
          builder: (context, child) => Padding(
            padding: EdgeInsets.all(16),
            child: child,
          ),
        ),
      ],
    );
  }
}
```

---

## Design Systems en Packages Externos

Widgetbook es ideal cuando tu design system vive en un package separado de tu aplicación principal, una práctica común en arquitecturas monorepo.

### Configuración Monorepo

#### Estructura Recomendada: Single Widgetbook

Esta es la configuración más común y recomendada:

```
monorepo/
├── my_app/                           # Tu aplicación Flutter
│   ├── lib/
│   └── pubspec.yaml
├── packages/
│   └── my_design_system/             # Tu design system
│       ├── lib/
│       │   ├── buttons/
│       │   ├── cards/
│       │   └── ...
│       └── pubspec.yaml
└── widgetbook/                       # Un solo Widgetbook para todo
    ├── lib/
    │   └── main.dart
    └── pubspec.yaml
```

**Configuración de `widgetbook/pubspec.yaml`:**

```yaml
name: widgetbook_workspace
description: Widgetbook catalog for design system
publish_to: "none"

environment:
  sdk: ">=3.1.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter
  widgetbook_annotation: ^3.0.0
  widgetbook: ^3.0.0

  # Tu design system (path dependency)
  my_design_system:
    path: ../packages/my_design_system

  # Opcional: tu app si quieres catalogar pantallas completas
  my_app:
    path: ../my_app

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.0
  widgetbook_generator: ^3.0.0
```

**Crear use-cases en `widgetbook/lib/`:**

```dart
// widgetbook/lib/buttons/primary_button.dart
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:my_design_system/buttons/primary_button.dart';

@widgetbook.UseCase(
  name: 'Default',
  type: PrimaryButton,
  path: '[Design System]/Buttons',
)
Widget buildPrimaryButton(BuildContext context) {
  return PrimaryButton(
    text: context.knobs.string(label: 'Text', initialValue: 'Primary'),
    onPressed: () {},
  );
}

@widgetbook.UseCase(
  name: 'Loading',
  type: PrimaryButton,
  path: '[Design System]/Buttons',
)
Widget buildLoadingPrimaryButton(BuildContext context) {
  return PrimaryButton(
    text: 'Loading',
    isLoading: true,
    onPressed: () {},
  );
}
```

#### Configuración con Melos

Si usas **Melos** para gestionar tu monorepo y encuentras problemas con path dependencies, usa esta configuración:

**`melos.yaml` en la raíz:**

```yaml
name: my_project
repository: https://github.com/youruser/yourrepo

packages:
  - apps/**
  - packages/**
  - widgetbook/ # Agregar widgetbook al workspace

command:
  bootstrap:
    environment:
      sdk: ">=3.1.0 <4.0.0"
      flutter: ">=3.10.0"

scripts:
  analyze:
    run: melos exec -- flutter analyze
    description: Analyze all packages

  test:
    run: melos exec -- flutter test
    description: Run tests for all packages

  widgetbook:
    run: cd widgetbook && flutter run
    description: Run Widgetbook
```

**`widgetbook/pubspec.yaml` con Melos:**

```yaml
name: widgetbook_workspace
description: Widgetbook catalog
publish_to: "none"

environment:
  sdk: ">=3.1.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter
  widgetbook_annotation: ^3.0.0
  widgetbook: ^3.0.0

  # Con Melos, usa versiones en lugar de paths
  my_design_system: ^1.0.0
  my_app: ^1.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.0
  widgetbook_generator: ^3.0.0
```

**Comandos con Melos:**

```bash
# Bootstrap (links automáticamente los packages)
melos bootstrap

# Navegar a widgetbook y ejecutar
cd widgetbook
flutter run

# O usar el script de melos
melos run widgetbook
```

#### Alternativa: Per-Package Widgetbook

Para proyectos muy grandes, puedes tener un Widgetbook por cada package:

```
monorepo/
├── my_app/
│   └── widgetbook/
│       ├── lib/
│       └── pubspec.yaml
└── packages/
    ├── design_system/
    │   └── widgetbook/
    │       ├── lib/
    │       └── pubspec.yaml
    └── feature_auth/
        └── widgetbook/
            ├── lib/
            └── pubspec.yaml
```

Cada `widgetbook/pubspec.yaml` solo referencia su package padre:

```yaml
# packages/design_system/widgetbook/pubspec.yaml
dependencies:
  design_system:
    path: ../
```

### Ejemplo Completo: Design System Externo

Supongamos que tienes un design system con estos componentes:

```
packages/my_design_system/
├── lib/
│   ├── buttons/
│   │   ├── primary_button.dart
│   │   ├── secondary_button.dart
│   │   └── text_button.dart
│   ├── cards/
│   │   ├── info_card.dart
│   │   └── media_card.dart
│   └── inputs/
│       ├── text_field.dart
│       └── search_field.dart
└── pubspec.yaml
```

**Estructura de Widgetbook:**

```
widgetbook/
├── lib/
│   ├── main.dart
│   ├── buttons/
│   │   ├── primary_button_usecases.dart
│   │   ├── secondary_button_usecases.dart
│   │   └── text_button_usecases.dart
│   ├── cards/
│   │   ├── info_card_usecases.dart
│   │   └── media_card_usecases.dart
│   └── inputs/
│       ├── text_field_usecases.dart
│       └── search_field_usecases.dart
└── pubspec.yaml
```

**`widgetbook/lib/buttons/primary_button_usecases.dart`:**

```dart
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:my_design_system/buttons/primary_button.dart';

@widgetbook.UseCase(
  name: 'Default',
  type: PrimaryButton,
  path: '[Buttons]/Primary',
)
Widget buildDefaultPrimaryButton(BuildContext context) {
  return PrimaryButton(
    text: context.knobs.string(label: 'Text', initialValue: 'Click me'),
    icon: context.knobs.listOrNull(
      label: 'Icon',
      options: [Icons.add, Icons.check, Icons.arrow_forward],
      labelBuilder: (icon) => icon.toString(),
    ),
    onPressed: () {},
  );
}

@widgetbook.UseCase(
  name: 'Disabled',
  type: PrimaryButton,
  path: '[Buttons]/Primary',
)
Widget buildDisabledPrimaryButton(BuildContext context) {
  return PrimaryButton(
    text: 'Disabled',
    onPressed: null,
  );
}

@widgetbook.UseCase(
  name: 'Loading',
  type: PrimaryButton,
  path: '[Buttons]/Primary',
)
Widget buildLoadingPrimaryButton(BuildContext context) {
  return PrimaryButton(
    text: 'Loading',
    isLoading: true,
    onPressed: () {},
  );
}

@widgetbook.UseCase(
  name: 'Full Width',
  type: PrimaryButton,
  path: '[Buttons]/Primary',
)
Widget buildFullWidthPrimaryButton(BuildContext context) {
  return SizedBox(
    width: double.infinity,
    child: PrimaryButton(
      text: 'Full Width',
      onPressed: () {},
    ),
  );
}
```

---

## Widgetbook CLI

El **Widgetbook CLI** es una herramienta de línea de comandos que ofrece utilidades para gestionar tu catálogo de Widgetbook, especialmente para integraciones con CI/CD y Widgetbook Cloud.

### Instalación

```bash
dart pub global activate widgetbook_cli
```

Verifica la instalación:

```bash
widgetbook --version
```

### Comandos Disponibles

#### 1. `cloud build push`

Sube un build de Widgetbook a **Widgetbook Cloud**.

**Sintaxis:**

```bash
widgetbook cloud build push --api-key <API_KEY>
```

**Argumentos completos:**

| Argumento        | Requerido | Default               | Descripción                                        |
| ---------------- | --------- | --------------------- | -------------------------------------------------- |
| `--path`         | No        | `./`                  | Ruta al proyecto de Widgetbook                     |
| `--api-key`      | **Sí**    | -                     | API key del proyecto (obtener de Widgetbook Cloud) |
| `--branch`       | No        | Branch actual (git)   | Nombre del branch                                  |
| `--commit`       | No        | HEAD commit (git)     | SHA del commit                                     |
| `--repository`   | No        | Nombre del repo (git) | Nombre del repositorio                             |
| `--actor`        | No        | Git user.name         | Usuario que ejecutó el build                       |
| `--git-provider` | No        | Auto-detectado        | Provider de Git (github, gitlab, etc.)             |

**Ejemplo básico:**

```bash
cd widgetbook
widgetbook cloud build push --api-key wba_1234567890abcdef
```

**Ejemplo con parámetros personalizados:**

```bash
widgetbook cloud build push \
  --path ./widgetbook \
  --api-key wba_1234567890abcdef \
  --branch feature/new-button \
  --commit abc123def456 \
  --repository my-org/my-app \
  --actor "John Doe"
```

**Uso en CI/CD:**

```bash
# GitHub Actions
widgetbook cloud build push --api-key ${{ secrets.WIDGETBOOK_API_KEY }}

# GitLab CI
widgetbook cloud build push --api-key $WIDGETBOOK_API_KEY

# Variables de entorno
export WIDGETBOOK_API_KEY="wba_1234567890abcdef"
widgetbook cloud build push
```

#### 2. `coverage` (Experimental)

Verifica qué porcentaje de los widgets de tu design system tienen al menos un use-case en Widgetbook.

**Sintaxis:**

```bash
widgetbook coverage
```

**Argumentos:**

| Argumento        | Requerido | Default        | Descripción                                     |
| ---------------- | --------- | -------------- | ----------------------------------------------- |
| `--package`      | No        | `./`           | Directorio de tu app o package de design system |
| `--widgetbook`   | No        | `./widgetbook` | Directorio de Widgetbook                        |
| `--min-coverage` | No        | `100`          | Porcentaje mínimo requerido (0-100)             |

**Ejemplo básico:**

```bash
widgetbook coverage
```

**Ejemplo con paths personalizados:**

```bash
widgetbook coverage \
  --package ./packages/my_design_system \
  --widgetbook ./widgetbook \
  --min-coverage 80
```

**Output de ejemplo:**

```
Analyzing coverage...

Widgets with use-cases: 45
Total widgets: 50
Coverage: 90%

Missing use-cases for:
  - lib/widgets/advanced_chart.dart
  - lib/widgets/custom_calendar.dart
  - lib/widgets/video_player.dart
  - lib/widgets/map_view.dart
  - lib/widgets/signature_pad.dart

✗ Coverage is below minimum threshold of 100%
```

**Ignorar widgets específicos:**

Si hay widgets que no quieres catalogar (como la app principal), agrégales el comentario:

```dart
// widgetbook: ignore
class MyApp extends StatelessWidget {
  // ...
}

// widgetbook: ignore
class InternalDevWidget extends StatelessWidget {
  // ...
}
```

**Uso en CI:**

```yaml
- name: Check Widgetbook Coverage
  run: |
    dart pub global activate widgetbook_cli
    widgetbook coverage --min-coverage 85
```

Si la cobertura está por debajo del mínimo, el comando fallará con exit code 1, bloqueando el build.

---

## Widgetbook Cloud

**Widgetbook Cloud** es una plataforma SaaS de hosting y revisión para equipos frontend de Flutter.

### ¿Qué es Widgetbook Cloud?

Es un servicio que hostea tus builds de Widgetbook y proporciona herramientas de colaboración para equipos:

- **Hosting automático**: Cada commit genera un build hosteado accesible por URL
- **UI Reviews**: Comparación visual automática entre branches
- **Golden tests en la nube**: Detección de regresiones visuales
- **Integración con VCS**: Status checks en Pull Requests (GitHub, GitLab, etc.)
- **Colaboración**: Comparte con diseñadores, PMs, QA sin necesidad de checkout local

### Beneficios Principales

#### 1. Builds Hosting

- Cada commit genera automáticamente un build web de Widgetbook
- Builds optimizados y cacheados para carga rápida
- Acceso vía URL única para cada commit/branch
- No necesitas self-hosting ni infraestructura propia

#### 2. UI Reviews

- Comparación visual automática entre base branch y head branch
- Detección de diferencias pixel-perfect
- Aprobación/rechazo de cambios visuales
- Comentarios y anotaciones sobre componentes específicos

#### 3. Visual Pull Requests

- Status check automático en PRs
- Link directo a la review desde el PR
- Bloqueo de merge si hay cambios visuales no aprobados (configurable)
- Histórico de cambios visuales en cada PR

#### 4. Multi-Snapshot Reviews

- Captura múltiples configuraciones por use-case
- Prueba diferentes temas, idiomas, viewports simultáneamente
- Comparación automática de todas las variantes

#### 5. Comparación con Figma

- Overlay de diseños de Figma sobre implementación
- Detección de diferencias entre diseño y código
- Link directo al componente en Figma

### Workflow Completo de UI Review

```mermaid
1. Developer hace cambios en un branch
   ↓
2. Push a remote
   ↓
3. CI/CD ejecuta: build + widgetbook cloud build push
   ↓
4. Widgetbook Cloud genera review automática
   ↓
5. Commit status en GitHub/GitLab con link a review
   ↓
6. Designer/Reviewer abre el link
   ↓
7. Widgetbook Cloud muestra diferencias visuales
   ↓
8. Reviewer aprueba o solicita cambios
   ↓
9. Estado se refleja en commit status del PR
   ↓
10. Si aprobado → merge permitido
    Si cambios solicitados → merge bloqueado (opcional)
```

### Code Review vs UI Review

| Aspecto         | Code Review                                                  | UI Review                                         |
| --------------- | ------------------------------------------------------------ | ------------------------------------------------- |
| **Propósito**   | Encontrar bugs, problemas de performance, calidad del código | Encontrar diferencias visuales, regresiones de UI |
| **Comparación** | Cambios de código entre commits                              | Diferencias visuales entre builds                 |
| **Herramienta** | GitHub, GitLab, Bitbucket                                    | Widgetbook Cloud                                  |
| **Reviewers**   | Developers                                                   | Designers, PMs, QA, Developers                    |
| **Formato**     | Diffs de texto                                               | Comparación de screenshots                        |
| **Aprobación**  | LGTM comment                                                 | Approve en Widgetbook Cloud                       |
| **Bloqueo**     | Tests fallando, approvals faltantes                          | Cambios visuales no aprobados                     |

---

## Ejemplos Prácticos Completos

### Ejemplo 1: Button Component con Todos los Estados

```dart
// design_system/lib/buttons/app_button.dart
enum ButtonVariant { primary, secondary, outlined, text }
enum ButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    // Implementación del botón
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Row(
              mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: _iconSize),
                  SizedBox(width: 8),
                ],
                Text(text),
              ],
            ),
    );
  }

  double get _iconSize {
    switch (size) {
      case ButtonSize.small:
        return 16;
      case ButtonSize.medium:
        return 20;
      case ButtonSize.large:
        return 24;
    }
  }
}

// widgetbook/lib/buttons/app_button_usecases.dart
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:my_design_system/buttons/app_button.dart';

// Use-case interactivo
@widgetbook.UseCase(
  name: 'Interactive',
  type: AppButton,
  path: '[Buttons]/AppButton',
  designLink: 'https://www.figma.com/file/xxx/DS?node-id=101-201',
)
Widget buildInteractiveButton(BuildContext context) {
  return AppButton(
    text: context.knobs.string(
      label: 'Text',
      initialValue: 'Button',
    ),
    variant: context.knobs.list(
      label: 'Variant',
      options: ButtonVariant.values,
      labelBuilder: (v) => v.name,
    ),
    size: context.knobs.list(
      label: 'Size',
      options: ButtonSize.values,
      labelBuilder: (s) => s.name,
    ),
    icon: context.knobs.listOrNull(
      label: 'Icon',
      options: [Icons.add, Icons.check, Icons.arrow_forward, Icons.download],
      labelBuilder: (i) => i.toString().split('.').last,
    ),
    isLoading: context.knobs.boolean(
      label: 'Loading',
      initialValue: false,
    ),
    isFullWidth: context.knobs.boolean(
      label: 'Full Width',
      initialValue: false,
    ),
    onPressed: context.knobs.boolean(label: 'Enabled', initialValue: true)
        ? () {}
        : null,
  );
}

// Estados específicos
@widgetbook.UseCase(
  name: 'Primary',
  type: AppButton,
  path: '[Buttons]/AppButton/States',
)
Widget buildPrimaryButton(BuildContext context) {
  return AppButton(
    text: 'Primary Button',
    variant: ButtonVariant.primary,
    onPressed: () {},
  );
}

@widgetbook.UseCase(
  name: 'Secondary',
  type: AppButton,
  path: '[Buttons]/AppButton/States',
)
Widget buildSecondaryButton(BuildContext context) {
  return AppButton(
    text: 'Secondary Button',
    variant: ButtonVariant.secondary,
    onPressed: () {},
  );
}

@widgetbook.UseCase(
  name: 'Disabled',
  type: AppButton,
  path: '[Buttons]/AppButton/States',
)
Widget buildDisabledButton(BuildContext context) {
  return AppButton(
    text: 'Disabled Button',
    variant: ButtonVariant.primary,
    onPressed: null,  // Disabled
  );
}

@widgetbook.UseCase(
  name: 'Loading',
  type: AppButton,
  path: '[Buttons]/AppButton/States',
)
Widget buildLoadingButton(BuildContext context) {
  return AppButton(
    text: 'Loading',
    variant: ButtonVariant.primary,
    isLoading: true,
    onPressed: () {},
  );
}

@widgetbook.UseCase(
  name: 'With Icon',
  type: AppButton,
  path: '[Buttons]/AppButton/Variants',
)
Widget buildButtonWithIcon(BuildContext context) {
  return AppButton(
    text: 'Download',
    icon: Icons.download,
    variant: ButtonVariant.primary,
    onPressed: () {},
  );
}

@widgetbook.UseCase(
  name: 'Full Width',
  type: AppButton,
  path: '[Buttons]/AppButton/Variants',
)
Widget buildFullWidthButton(BuildContext context) {
  return SizedBox(
    width: 300,
    child: AppButton(
      text: 'Full Width Button',
      variant: ButtonVariant.primary,
      isFullWidth: true,
      onPressed: () {},
    ),
  );
}

// Comparación de tamaños
@widgetbook.UseCase(
  name: 'All Sizes',
  type: AppButton,
  path: '[Buttons]/AppButton/Comparison',
)
Widget buildAllSizes(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      AppButton(
        text: 'Small',
        size: ButtonSize.small,
        onPressed: () {},
      ),
      SizedBox(height: 16),
      AppButton(
        text: 'Medium',
        size: ButtonSize.medium,
        onPressed: () {},
      ),
      SizedBox(height: 16),
      AppButton(
        text: 'Large',
        size: ButtonSize.large,
        onPressed: () {},
      ),
    ],
  );
}
```

### Ejemplo 2: Card Component con Mocking

```dart
// design_system/lib/cards/user_card.dart
class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
    required this.user,
    this.onTap,
  });

  final User user;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(user.avatarUrl),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          user.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        if (user.isVerified) ...[
                          SizedBox(width: 8),
                          Icon(Icons.verified, size: 16, color: Colors.blue),
                        ],
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      user.email,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (user.bio != null) ...[
                      SizedBox(height: 8),
                      Text(
                        user.bio!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// widgetbook/lib/fixtures/user_fixtures.dart
class UserFixtures {
  static User regular() => User(
        id: '1',
        name: 'John Doe',
        email: 'john.doe@example.com',
        avatarUrl: 'https://i.pravatar.cc/150?img=1',
        isVerified: false,
        bio: null,
      );

  static User verified() => User(
        id: '2',
        name: 'Jane Smith',
        email: 'jane.smith@example.com',
        avatarUrl: 'https://i.pravatar.cc/150?img=5',
        isVerified: true,
        bio: 'Software Engineer | Flutter Developer',
      );

  static User withLongBio() => User(
        id: '3',
        name: 'Alice Johnson',
        email: 'alice.j@example.com',
        avatarUrl: 'https://i.pravatar.cc/150?img=10',
        isVerified: true,
        bio:
            'Passionate developer with 10+ years of experience in mobile development. '
            'Love building beautiful UIs with Flutter. Always learning new things.',
      );
}

// widgetbook/lib/cards/user_card_usecases.dart
@widgetbook.UseCase(
  name: 'Interactive',
  type: UserCard,
  path: '[Cards]/UserCard',
)
Widget buildInteractiveUserCard(BuildContext context) {
  return UserCard(
    user: User(
      id: '1',
      name: context.knobs.string(label: 'Name', initialValue: 'John Doe'),
      email: context.knobs.string(
        label: 'Email',
        initialValue: 'john@example.com',
      ),
      avatarUrl: 'https://i.pravatar.cc/150?img=1',
      isVerified: context.knobs.boolean(label: 'Verified', initialValue: false),
      bio: context.knobs.stringOrNull(label: 'Bio', initialValue: null),
    ),
    onTap: () => debugPrint('Card tapped'),
  );
}

@widgetbook.UseCase(
  name: 'Regular User',
  type: UserCard,
  path: '[Cards]/UserCard/States',
)
Widget buildRegularUser(BuildContext context) {
  return UserCard(user: UserFixtures.regular());
}

@widgetbook.UseCase(
  name: 'Verified User',
  type: UserCard,
  path: '[Cards]/UserCard/States',
)
Widget buildVerifiedUser(BuildContext context) {
  return UserCard(user: UserFixtures.verified());
}

@widgetbook.UseCase(
  name: 'Long Bio',
  type: UserCard,
  path: '[Cards]/UserCard/States',
)
Widget buildLongBio(BuildContext context) {
  return UserCard(user: UserFixtures.withLongBio());
}
```

### Ejemplo 3: Pantalla Completa con Múltiples Dependencias

```dart
// widgetbook/lib/screens/profile_screen_usecases.dart
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockAuthService extends Mock implements AuthService {}
class MockUserRepository extends Mock implements UserRepository {}
class MockAnalyticsService extends Mock implements AnalyticsService {}

@widgetbook.UseCase(
  name: 'Authenticated User',
  type: ProfileScreen,
  path: '[Screens]/Profile',
)
Widget buildAuthenticatedProfile(BuildContext context) {
  // Setup mocks
  final mockAuth = MockAuthService();
  final mockUserRepo = MockUserRepository();
  final mockAnalytics = MockAnalyticsService();

  // Configure auth
  when(() => mockAuth.isAuthenticated).thenReturn(true);
  when(() => mockAuth.currentUserId).thenReturn('user123');

  // Configure user data
  when(() => mockUserRepo.getUserById('user123')).thenAnswer(
    (_) async => UserFixtures.verified(),
  );
  when(() => mockUserRepo.getUserStats('user123')).thenAnswer(
    (_) async => UserStats(
      postsCount: 42,
      followersCount: 1250,
      followingCount: 380,
    ),
  );

  // Configure analytics (no-op for mocks)
  when(() => mockAnalytics.logScreenView('profile')).thenAnswer((_) async {});

  return MultiProvider(
    providers: [
      Provider<AuthService>.value(value: mockAuth),
      Provider<UserRepository>.value(value: mockUserRepo),
      Provider<AnalyticsService>.value(value: mockAnalytics),
    ],
    child: ProfileScreen(),
  );
}

@widgetbook.UseCase(
  name: 'Loading State',
  type: ProfileScreen,
  path: '[Screens]/Profile',
)
Widget buildLoadingProfile(BuildContext context) {
  final mockAuth = MockAuthService();
  final mockUserRepo = MockUserRepository();

  when(() => mockAuth.isAuthenticated).thenReturn(true);
  when(() => mockAuth.currentUserId).thenReturn('user123');

  // Simulate slow loading
  when(() => mockUserRepo.getUserById('user123')).thenAnswer(
    (_) async {
      await Future.delayed(Duration(hours: 1));  // Never completes
      return UserFixtures.regular();
    },
  );

  return MultiProvider(
    providers: [
      Provider<AuthService>.value(value: mockAuth),
      Provider<UserRepository>.value(value: mockUserRepo),
    ],
    child: ProfileScreen(),
  );
}

@widgetbook.UseCase(
  name: 'Error State',
  type: ProfileScreen,
  path: '[Screens]/Profile',
)
Widget buildErrorProfile(BuildContext context) {
  final mockAuth = MockAuthService();
  final mockUserRepo = MockUserRepository();

  when(() => mockAuth.isAuthenticated).thenReturn(true);
  when(() => mockAuth.currentUserId).thenReturn('user123');

  when(() => mockUserRepo.getUserById('user123')).thenThrow(
    Exception('Failed to load user data'),
  );

  return MultiProvider(
    providers: [
      Provider<AuthService>.value(value: mockAuth),
      Provider<UserRepository>.value(value: mockUserRepo),
    ],
    child: ProfileScreen(),
  );
}
```

---

## Best Practices

### 1. Organización

```dart
// Usa paths para organizar jerárquicamente
@UseCase(
  name: 'Primary',
  type: Button,
  path: '[Components]/Buttons/Primary',  // [nombre] = categoría
)

@UseCase(
  name: 'Info',
  type: Card,
  path: '[Components]/Cards/Info',
)

@UseCase(
  name: 'Login',
  type: LoginScreen,
  path: '[Screens]/Authentication/Login',
)
```

### 2. Naming Conventions

```dart
// Use-cases: buildXxxYyy
Widget buildPrimaryButton(BuildContext context) { }
Widget buildLoadingState(BuildContext context) { }

// Fixtures: XxxFixtures.yyy()
UserFixtures.verified()
ProductFixtures.outOfStock()

// Mocks: MockXxx
class MockAuthService extends Mock implements AuthService {}
```

### 3. Cobertura Completa

Cataloga todos los estados posibles:

- **Default state**
- **Empty state** (sin datos)
- **Loading state** (cargando)
- **Error state** (error)
- **Success state** (éxito)
- **Disabled state** (deshabilitado)
- **Edge cases** (textos muy largos, números grandes, etc.)

### 4. Use Knobs para Interactividad

```dart
// Buena práctica: usar knobs para estados comunes
@UseCase(name: 'Interactive', type: Button)
Widget build(BuildContext context) {
  return Button(
    text: context.knobs.string(label: 'Text', initialValue: 'Click me'),
    enabled: context.knobs.boolean(label: 'Enabled', initialValue: true),
    loading: context.knobs.boolean(label: 'Loading', initialValue: false),
  );
}
```

### 5. Fixtures Reutilizables

```dart
// Crea fixtures reutilizables para datos complejos
class ProductFixtures {
  static List<Product> all() => [regular(), premium(), outOfStock()];
  static Product regular() => Product(/* ... */);
  static Product premium() => Product(/* ... */);
  static Product outOfStock() => Product(/* ... */);
}
```

### 6. Ignorar Widgets Internos

```dart
// widgetbook: ignore
class _InternalWidget extends StatelessWidget {
  // Widget interno que no debe estar en el catálogo
}

// widgetbook: ignore
class MyApp extends StatelessWidget {
  // La app principal no necesita use-case
}
```

### 7. Multi-Snapshot para Testing Exhaustivo

```dart
@App(
  cloudAddonsConfigs: {
    'iOS Light': [
      DeviceAddonConfig(Devices.ios.iPhone13),
      ThemeAddonConfig('Light'),
    ],
    'iOS Dark': [
      DeviceAddonConfig(Devices.ios.iPhone13),
      ThemeAddonConfig('Dark'),
    ],
    'Android Light': [
      DeviceAddonConfig(Devices.android.samsungGalaxyS21),
      ThemeAddonConfig('Light'),
    ],
  },
)
```

### 8. Orden de Addons

```dart
// Orden correcto: de más externo a más interno
addons: [
  ViewportAddon(...),       // 1. Viewport
  MaterialThemeAddon(...),  // 2. Theme
  LocalizationAddon(...),   // 3. Localization
  AlignmentAddon(),         // 4. Layout helpers
  TextScaleAddon(...),      // 5. Accessibility
  InspectorAddon(),         // 6. Dev tools
]
```

### 9. Design Links para Todos los Components

```dart
// Siempre agrega designLink cuando hay diseño en Figma
@UseCase(
  name: 'Primary Button',
  type: Button,
  designLink: 'https://www.figma.com/file/xxx?node-id=yyy',
)
```

### 10. CI/CD Obligatorio

- Configura CI/CD desde el inicio
- Cada commit debe generar un build en Widgetbook Cloud
- Habilita UI Reviews en todos los PRs
- Considera bloquear merge si hay cambios visuales no aprobados

### 11. Coverage Checks

```yaml
# .github/workflows/widgetbook-coverage.yml
- name: Check Coverage
  run: |
    dart pub global activate widgetbook_cli
    widgetbook coverage --min-coverage 80
```

### 12. Documentation

```dart
// Usa description en knobs para documentar
context.knobs.int.slider(
  label: 'Max Items',
  initialValue: 10,
  min: 1,
  max: 100,
  description: 'Maximum number of items to display in the list. '
               'Values above 50 may impact performance.',
)
```

---

## Recursos Adicionales

### Documentación Oficial

- **Sitio web**: [https://widgetbook.io](https://widgetbook.io)
- **Documentación**: [https://docs.widgetbook.io](https://docs.widgetbook.io)
- **GitHub**: [https://github.com/widgetbook/widgetbook](https://github.com/widgetbook/widgetbook)

### Comunidad

- **Discord**: [https://discord.com/invite/zT4AMStAJA](https://discord.com/invite/zT4AMStAJA)
- **GitHub Discussions**: [https://github.com/widgetbook/widgetbook/discussions](https://github.com/widgetbook/widgetbook/discussions)
- **Issues**: [https://github.com/widgetbook/widgetbook/issues](https://github.com/widgetbook/widgetbook/issues)

### Packages

- **widgetbook**: Package principal de Widgetbook
- **widgetbook_annotation**: Anotaciones para generación de código
- **widgetbook_generator**: Generador de código (dev_dependency)
- **widgetbook_cli**: CLI para Widgetbook Cloud

### Comandos Útiles

```bash
# Instalar CLI
dart pub global activate widgetbook_cli

# Generar código (build único)
dart run build_runner build -d

# Generar código (watch mode)
dart run build_runner watch -d

# Limpiar archivos generados
dart run build_runner clean

# Ejecutar Widgetbook
flutter run

# Push a Widgetbook Cloud
widgetbook cloud build push --api-key <key>

# Check coverage
widgetbook coverage --min-coverage 85

# Build para web (antes de push)
flutter build web -t lib/main.dart
```

### Configuración de Telemetría

Widgetbook Generator recolecta datos anónimos de uso. Para desactivar:

```yaml
# build.yaml en la raíz del proyecto
targets:
  $default:
    builders:
      widgetbook_generator:telemetry:
        enabled: false
```

### Presentación de Slides

Para una introducción visual a Widgetbook:
[Google Slides Presentation](https://docs.google.com/presentation/d/1ZIhWEJovIaLJQn-4ZYq8n8miJe8QwQUr63DJ6FjwWPE)

---

## Conclusión

Widgetbook es una herramienta esencial para equipos que trabajan con Flutter, especialmente cuando:

1. **Tienes un design system** en un package separado
2. **Trabajas en equipo** con diseñadores, PMs, y QA
3. **Necesitas UI Reviews** automatizadas
4. **Quieres detectar regresiones visuales** antes de producción
5. **Buscas documentación viva** de tus componentes

### Próximos Pasos

1. **Instalar Widgetbook** en tu proyecto
2. **Crear use-cases** para tus componentes principales
3. **Configurar CI/CD** con GitHub Actions (o tu proveedor)
4. **Crear cuenta** en Widgetbook Cloud
5. **Integrar con Figma** para Design QA
6. **Establecer workflow** de UI Reviews en tu equipo

### Soporte

Si tienes preguntas o problemas:

- Revisa la [documentación oficial](https://docs.widgetbook.io)
- Únete al [Discord](https://discord.com/invite/zT4AMStAJA)
- Crea un [issue en GitHub](https://github.com/widgetbook/widgetbook/issues)

---

**Fecha de creación**: 2025
**Versión de Widgetbook**: 3.x
**Versión de Flutter**: 3.10+
