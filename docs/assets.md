## Assets en Widgetbook

Si tu app o design system usa assets (imágenes, fuentes, etc.) y quieres mostrarlos en Widgetbook, necesitas configuración adicional.

### Problema

Por default, Widgetbook no tiene acceso a los assets de tu app principal.

```dart
// Esto NO funcionará en Widgetbook sin configuración
Image.asset('assets/images/logo.png')
```

### Solución: Package de Assets Compartido

#### Paso 1: Crear Package de Assets

Crea un nuevo directorio `assets/` en la raíz de tu proyecto:

```
your_project/
├── lib/
├── widgetbook/
└── assets/
    ├── pubspec.yaml
    ├── images/
    │   ├── logo.png
    │   ├── avatar.png
    │   └── background.jpg
    └── fonts/
        ├── Roboto-Regular.ttf
        └── Roboto-Bold.ttf
```

#### Paso 2: Configurar pubspec.yaml del Package de Assets

`assets/pubspec.yaml`:

```yaml
name: assets
description: Shared assets for app and Widgetbook
version: 0.0.0
publish_to: none

environment:
  sdk: ">=3.1.0 <4.0.0"

flutter:
  assets:
    - images/
    - images/icons/
    # Incluye subdirectorios específicos o usa ./ para todos

  fonts:
    - family: Roboto
      fonts:
        - asset: fonts/Roboto-Regular.ttf
        - asset: fonts/Roboto-Bold.ttf
          weight: 700
```

#### Paso 3: Agregar Package de Assets a Ambos Projects

**`pubspec.yaml` (app principal):**

```yaml
dependencies:
  # ...
  assets:
    path: assets
```

**`widgetbook/pubspec.yaml`:**

```yaml
dependencies:
  # ...
  assets:
    path: ../assets # Ruta relativa desde widgetbook/
```

#### Paso 4: Usar Assets con Package Parameter

```dart
// En tu app
Image.asset(
  'images/logo.png',
  package: 'assets',  // IMPORTANTE: especificar package
)

// En Widgetbook
@widgetbook.UseCase(
  name: 'With Logo',
  type: AppHeader,
  path: '[Components]/Header',
)
Widget buildHeaderWithLogo(BuildContext context) {
  return AppHeader(
    logo: Image.asset(
      'images/logo.png',
      package: 'assets',  // Mismo código
    ),
  );
}
```

### Ejemplo Completo

```dart
// widgetbook/lib/branding/logo_usecases.dart
@widgetbook.UseCase(
  name: 'Default',
  type: AppLogo,
  path: '[Branding]/Logo',
)
Widget buildDefaultLogo(BuildContext context) {
  return AppLogo(
    imagePath: 'images/logo.png',
    package: 'assets',
  );
}

// widgets/app_logo.dart
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    required this.imagePath,
    required this.package,
    this.size = 100,
  });

  final String imagePath;
  final String package;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imagePath,
      package: package,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
```

### Assets con Theme

Si tus assets dependen del tema (dark/light):

```dart
@widgetbook.UseCase(
  name: 'Themed Background',
  type: ThemedContainer,
  path: '[Components]/Container',
)
Widget buildThemedContainer(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return ThemedContainer(
    backgroundImage: DecorationImage(
      image: AssetImage(
        isDark ? 'images/bg-dark.jpg' : 'images/bg-light.jpg',
        package: 'assets',
      ),
      fit: BoxFit.cover,
    ),
    child: Text('Content'),
  );
}
```

### Fuentes Personalizadas

```dart
// assets/pubspec.yaml
flutter:
  fonts:
    - family: CustomFont
      fonts:
        - asset: fonts/CustomFont-Regular.ttf
        - asset: fonts/CustomFont-Bold.ttf
          weight: 700
        - asset: fonts/CustomFont-Italic.ttf
          style: italic

// En tu app o Widgetbook
Text(
  'Custom Font Text',
  style: TextStyle(
    fontFamily: 'CustomFont',
    fontFamilyFallback: ['Roboto'],  // Fallback
    package: 'assets',  // IMPORTANTE para fuentes también
  ),
)

// O en tu tema
ThemeData(
  fontFamily: 'CustomFont',
  fontFamilyFallback: ['Roboto'],
  package: 'assets',
)
```

---
