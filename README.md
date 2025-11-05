# DemoApp - Sistema de Diseño con Widgetbook

Demo de un sistema de diseño en Flutter con integración completa de Widgetbook para colaboración entre equipos de desarrollo y diseño.

## 🎯 Descripción del Proyecto

Este proyecto es una demostración de cómo implementar un flujo de trabajo profesional de sistema de diseño utilizando **Widgetbook** como catálogo de componentes, integrando:

- 🎨 Componentes de UI reutilizables
- 📚 Catálogo interactivo con Widgetbook
- 🔄 CI/CD automatizado con GitHub Actions
- ☁️ Publicación automática a Widgetbook Cloud
- 🔗 Integración con Figma para QA de diseño
- 🧪 Testing con fixtures y mocking

## 🏗️ Estructura del Proyecto

```
demoapp/
├── lib/
│   └── design_system/          # Componentes del sistema de diseño
│       ├── buttons/
│       │   └── app_button.dart
│       ├── cards/
│       │   ├── info_card.dart
│       │   └── user_card.dart
│       ├── inputs/
│       │   ├── app_text_field.dart
│       │   └── app_search_field.dart
│       └── typography/
│           └── app_text.dart
│
├── widgetbook/                 # Catálogo de Widgetbook
│   ├── lib/
│   │   ├── main.dart
│   │   ├── use_cases/         # Use-cases de todos los componentes
│   │   └── fixtures/          # Datos de ejemplo reutilizables
│   └── README.md
│
├── docs/                       # Documentación completa
│   ├── GUIA_USO_WIDGETBOOK.md
│   ├── TEAM_WORKFLOW.md
│   ├── GITHUB_SETUP.md
│   ├── FIGMA_LINKS_GUIDE.md
│   ├── figma_integration.md
│   ├── mocking_testing.md
│   ├── CICDIntegration.md
│   └── assets.md
│
└── .github/
    └── workflows/
        └── widgetbook.yml      # CI/CD para Widgetbook Cloud
```

## 🚀 Inicio Rápido

### Requisitos

- Flutter SDK 3.24.0 o superior
- Dart 3.9.2 o superior
- Un editor (VS Code, Android Studio, IntelliJ)

### Instalación

```bash
# Clonar el repositorio
git clone <tu-repo>
cd demoapp

# Instalar dependencias del proyecto principal
flutter pub get

# Instalar dependencias de Widgetbook
cd widgetbook
flutter pub get
```

### Ejecutar la App Principal

```bash
# Desde el directorio raíz
flutter run
```

### Ejecutar Widgetbook

```bash
# Ir al directorio de widgetbook
cd widgetbook

# Generar código
dart run build_runner build --delete-conflicting-outputs

# Ejecutar en Chrome
flutter run -d chrome
```

El Widgetbook se abrirá en tu navegador y podrás explorar todos los componentes del sistema de diseño.

## 📚 Widgetbook

### ¿Qué es Widgetbook?

Widgetbook es como "Storybook" pero para Flutter. Permite:

- 👀 Ver componentes aislados sin ejecutar toda la app
- 🎨 Probar diferentes estados y variantes
- 📱 Simular diferentes dispositivos (iPhone, iPad, Android)
- 🌗 Ver componentes en tema claro y oscuro
- 🔧 Modificar props en tiempo real con knobs
- 🔗 Comparar implementación vs diseño de Figma

### Componentes Catalogados

- **Botones:** AppButton (primary, secondary, text, loading, disabled)
- **Tarjetas:** InfoCard, UserCard (verified, no avatar, edge cases)
- **Inputs:** AppTextField, AppSearchField
- **Tipografía:** AppText (h1, h2, h3, body, caption)

### Acceder a Widgetbook Cloud

- URL: https://app.widgetbook.io
- El CI/CD publica automáticamente en cada PR
- Los diseñadores pueden revisar sin instalar nada

Ver [widgetbook/README.md](./widgetbook/README.md) para más información.

## 🔄 Workflow de Desarrollo

### Para Desarrolladores

1. Crear/modificar componente en `lib/design_system/`
2. Crear use-cases en `widgetbook/lib/use_cases/`
3. Agregar `designLink` de Figma (opcional)
4. Regenerar: `dart run build_runner build -d`
5. Commit y push
6. El CI automáticamente publica a Widgetbook Cloud

### Para Diseñadores

1. Recibir notificación de nuevo PR
2. Abrir link de Widgetbook Cloud (del comentario en PR)
3. Revisar componente en diferentes estados
4. Usar overlay de Figma para comparar diseño vs implementación
5. Aprobar o solicitar cambios en el PR

Ver [docs/TEAM_WORKFLOW.md](./docs/TEAM_WORKFLOW.md) para el flujo completo.

## ⚙️ CI/CD

### GitHub Actions

El proyecto incluye un workflow de GitHub Actions que:

1. ✅ Ejecuta en cada push a `main`/`develop` y en PRs
2. ✅ Genera el código de Widgetbook con build_runner
3. ✅ Ejecuta coverage check (opcional)
4. ✅ Construye Widgetbook para web
5. ✅ Sube a Widgetbook Cloud automáticamente
6. ✅ Comenta en el PR con el link de Widgetbook Cloud

### Configuración

Para que funcione en tu repositorio:

1. Ve a GitHub → Settings → Secrets → Actions
2. Agrega `WIDGETBOOK_API_KEY` con tu API key
3. El workflow se ejecutará automáticamente

Ver [docs/GITHUB_SETUP.md](./docs/GITHUB_SETUP.md) para detalles.

## 🎨 Integración con Figma

Los use-cases de Widgetbook incluyen links directos a los diseños de Figma usando el parámetro `designLink`:

```dart
@widgetbook.UseCase(
  name: 'Primary',
  type: AppButton,
  path: '[Buttons]/AppButton',
  designLink: 'https://www.figma.com/design/.../node-id=1-131',
)
```

Esto permite a los diseñadores:
- Ver el diseño original directamente desde Widgetbook Cloud
- Usar el overlay de Figma para comparar píxel a píxel
- Aprobar o solicitar cambios con confianza

Ver [docs/FIGMA_LINKS_GUIDE.md](./docs/FIGMA_LINKS_GUIDE.md) para obtener links de Figma.

## 🧪 Testing y Fixtures

El proyecto incluye **fixtures** reutilizables para datos de ejemplo:

```dart
// widgetbook/lib/fixtures/user_fixtures.dart
const user = UserFixtures.verified;

UserCard(
  name: user.name,
  email: user.email,
  avatarUrl: user.avatarUrl,
  isVerified: user.isVerified,
)
```

Beneficios:
- ✅ Datos consistentes en todos los use-cases
- ✅ Fácil mantenimiento
- ✅ Incluye edge cases (nombres largos, emails largos, etc.)

También incluye **mocktail** para mocking en casos más complejos.

Ver [docs/mocking_testing.md](./docs/mocking_testing.md) para ejemplos.

## 📊 Coverage

Verifica qué componentes están catalogados en Widgetbook:

```bash
cd widgetbook
widgetbook coverage --path lib/
```

El CI también ejecuta esto automáticamente y muestra los resultados.

## 📖 Documentación

El proyecto incluye documentación completa en la carpeta `docs/`:

| Documento | Descripción |
|-----------|-------------|
| [GUIA_USO_WIDGETBOOK.md](./docs/GUIA_USO_WIDGETBOOK.md) | Guía completa de Widgetbook (50KB) |
| [TEAM_WORKFLOW.md](./docs/TEAM_WORKFLOW.md) | Workflow para equipos de dev y diseño |
| [GITHUB_SETUP.md](./docs/GITHUB_SETUP.md) | Setup de CI/CD con GitHub Actions |
| [FIGMA_LINKS_GUIDE.md](./docs/FIGMA_LINKS_GUIDE.md) | Cómo obtener y usar links de Figma |
| [figma_integration.md](./docs/figma_integration.md) | Integración avanzada con Figma |
| [mocking_testing.md](./docs/mocking_testing.md) | Testing y mocking en Widgetbook |
| [CICDIntegration.md](./docs/CICDIntegration.md) | CI/CD con diferentes plataformas |
| [assets.md](./docs/assets.md) | Gestión de assets compartidos |

## 🎯 Casos de Uso

### 1. Desarrollo de Componentes

```bash
# Crear componente
# → lib/design_system/buttons/new_button.dart

# Crear use-case
# → widgetbook/lib/use_cases/buttons_usecases.dart

# Generar y probar
cd widgetbook
dart run build_runner build -d
flutter run -d chrome
```

### 2. Revisión de Diseño

```
Diseñador recibe PR
  → Abre Widgetbook Cloud desde comentario
  → Navega al componente
  → Activa overlay de Figma
  → Compara diseño vs implementación
  → Aprueba o solicita cambios
```

### 3. QA de Componentes

```
QA abre Widgetbook Cloud
  → Prueba diferentes viewports (iPhone, iPad, Android)
  → Cambia entre tema claro/oscuro
  → Prueba con knobs (enabled, disabled, loading, etc.)
  → Verifica edge cases (textos largos, sin datos)
  → Valida accesibilidad
```

## 🛠️ Comandos Útiles

### Proyecto Principal

```bash
# Ejecutar app
flutter run

# Ejecutar tests
flutter test

# Analizar código
flutter analyze
```

### Widgetbook

```bash
# Desde widgetbook/
dart run build_runner build -d        # Generar código
dart run build_runner watch -d        # Watch mode
flutter run -d chrome                  # Ejecutar
widgetbook coverage --path lib/       # Ver coverage
flutter clean                          # Limpiar builds
```

### CI/CD

```bash
# Ver workflows
# GitHub → Actions tab

# Re-ejecutar workflow
# Click "Re-run jobs" en workflow fallido
```

## 🤝 Contribuir

### Agregar Nuevo Componente

1. Implementa el componente en `lib/design_system/[category]/`
2. Crea use-cases en `widgetbook/lib/use_cases/`
3. Agrega fixtures si es necesario
4. Genera código: `dart run build_runner build -d`
5. Prueba localmente: `flutter run -d chrome`
6. Commit y push
7. Crea PR
8. Espera review de diseño en Widgetbook Cloud

### Modificar Componente Existente

1. Modifica el componente
2. Actualiza use-cases si cambió la API
3. Regenera código
4. Verifica que no rompiste otros use-cases
5. Push y espera review

## 🐛 Troubleshooting

### "build_runner failed"

```bash
flutter clean
cd widgetbook && flutter clean
flutter pub get
cd widgetbook && flutter pub get
dart run build_runner build -d --verbose
```

### "Widgetbook Cloud upload failed"

- Verifica que `WIDGETBOOK_API_KEY` esté configurado en GitHub Secrets
- Revisa los logs de GitHub Actions
- Asegúrate de que el proyecto exista en Widgetbook Cloud

### "No veo el overlay de Figma"

- Verifica que el `designLink` esté en el use-case
- Regenera el código: `dart run build_runner build -d`
- Haz push para que se reconstruya en CI

## 📈 Roadmap

### Implementado ✅

- ✅ Sistema de diseño básico con componentes
- ✅ Widgetbook configurado con addons
- ✅ CI/CD con GitHub Actions
- ✅ Integración con Widgetbook Cloud
- ✅ Links de Figma en use-cases
- ✅ Fixtures para testing
- ✅ Coverage tracking
- ✅ Documentación completa

### Por Implementar 🔜

- 🔜 Visual regression testing automático
- 🔜 Notificaciones de Slack/Discord
- 🔜 Multi-snapshot para responsive testing
- 🔜 Publicar componentes como package
- 🔜 Storybook de accesibilidad
- 🔜 Integración con Codemagic (alternativa a GitHub Actions)

## 📞 Soporte

- 📖 Consulta la [documentación](./docs/)
- 🐛 Reporta bugs en [GitHub Issues](https://github.com/tu-repo/issues)
- 💬 Preguntas en [GitHub Discussions](https://github.com/tu-repo/discussions)
- 📧 Email: design-system@tuempresa.com

## 📝 Licencia

[Tu licencia aquí]

## 🙏 Agradecimientos

- [Widgetbook](https://widgetbook.io) - Amazing tool for Flutter component catalogs
- [Flutter](https://flutter.dev) - Beautiful UI framework
- Equipo de diseño y desarrollo

---

**Hecho con ❤️ para demostrar el flujo de trabajo ideal con Widgetbook**
