# DemoApp - Widgetbook Demo Incremental

Demo paso a paso de Widgetbook para Flutter, enfocada en aprender el flujo de trabajo desde lo más básico hasta funcionalidades avanzadas.

## 🎯 Objetivo de esta Demo

Aprender Widgetbook de forma **gradual e incremental**:
- Empezar con **1 solo botón**
- Hacer el **primer push manual** a Widgetbook Cloud
- Ir agregando funcionalidades paso a paso
- Evaluar en cada fase si vale la pena continuar

**Filosofía:** De menor a mayor complejidad.

## 📍 Estado Actual: Fase 0 ✅

**Lo que tenemos ahora:**
- ✅ Sistema de diseño básico con componentes en `lib/design_system/`
- ✅ Widgetbook configurado en `widgetbook/`
- ✅ **1 solo componente catalogado:** AppButton
- ✅ **1 solo use-case:** Interactive (con knobs)
- ✅ Addons básicos configurados (Viewport, Theme, Grid, TextScale)

**Lo que NO tenemos (todavía):**
- ❌ GitHub Actions automatizado (se agregará en Fase 5)
- ❌ Links de Figma (se agregarán en Fase 2)
- ❌ Múltiples componentes (se agregarán en Fases 3-6)
- ❌ Fixtures y testing avanzado (se agregarán en Fases 4 y 7)

## 🚀 Próximo Paso: Primer Push Manual

Tu siguiente tarea es hacer el **primer push a Widgetbook Cloud** manualmente usando el CLI.

**Guía completa:** [`docs/PRIMER_PUSH_MANUAL.md`](./docs/PRIMER_PUSH_MANUAL.md)

**Resumen rápido:**

```bash
# 1. Ir al directorio de widgetbook
cd widgetbook

# 2. Instalar dependencias
flutter pub get

# 3. Generar código
dart run build_runner build --delete-conflicting-outputs

# 4. Construir para web
flutter build web --release --base-href="/widgetbook/"

# 5. Instalar CLI (solo primera vez)
dart pub global activate widgetbook_cli

# 6. Push a Cloud
widgetbook cloud build push \
  --api-key "9ba437347f12fd3a8c8267142db7abcaf0c48022bd4e6838dd023464fa031346" \
  --branch "main" \
  --commit "$(git rev-parse HEAD)" \
  --repository "usuario/tu-repo" \
  --actor "$(git config user.name)" \
  --build-path build/web
```

**¿Problemas?** Consulta la sección de Troubleshooting en `docs/PRIMER_PUSH_MANUAL.md`.

## 📋 Roadmap de la Demo

Esta demo está organizada en **10 fases incrementales**. Puedes detenerte en cualquier momento.

| Fase | Objetivo | Estado |
|------|----------|--------|
| **0** | Setup inicial con 1 botón | ✅ **COMPLETADO** |
| **1** | Expandir estados del botón | 🔜 Próximo |
| **2** | Integración con Figma | 🔜 |
| **3** | Agregar segundo componente | 🔜 |
| **4** | Fixtures y datos reutilizables | 🔜 |
| **5** | Automatizar con GitHub Actions | 🔜 |
| **6** | Catalogar componentes restantes | 🔜 |
| **7** | Testing avanzado con mocking | 🔜 |
| **8** | Coverage tracking | 🔜 |
| **9** | Workflow del equipo | 🔜 |
| **10** | Optimizaciones avanzadas | 🔜 |

**Ver roadmap completo:** [`docs/ROADMAP_DEMO.md`](./docs/ROADMAP_DEMO.md)

## 🏗️ Estructura del Proyecto

```
demoapp/
├── lib/
│   └── design_system/          # Componentes del sistema de diseño
│       ├── buttons/
│       │   └── app_button.dart ← Nuestro componente de demo
│       ├── cards/              # Componentes disponibles pero no catalogados aún
│       ├── inputs/
│       └── typography/
│
├── widgetbook/                 # Catálogo de Widgetbook
│   ├── lib/
│   │   ├── main.dart           # Configuración de Widgetbook
│   │   └── use_cases/
│   │       └── buttons_usecases.dart  ← 1 use-case interactivo
│   └── README.md               # Guía del widgetbook
│
├── docs/                       # Documentación completa
│   ├── PRIMER_PUSH_MANUAL.md   ← EMPIEZA AQUÍ
│   ├── ROADMAP_DEMO.md         # Plan de iteraciones
│   ├── GUIA_USO_WIDGETBOOK.md  # Guía completa de Widgetbook
│   ├── FIGMA_LINKS_GUIDE.md    # Para Fase 2
│   ├── GITHUB_SETUP.md         # Para Fase 5
│   ├── TEAM_WORKFLOW.md        # Para Fase 9
│   └── ...
│
└── .github/
    └── workflows/
        └── widgetbook.yml.disabled  # Se activará en Fase 5
```

## 🎨 ¿Qué es Widgetbook?

Widgetbook es como "Storybook" pero para Flutter. Permite:

- 👀 Ver componentes aislados sin ejecutar toda la app
- 🎨 Probar diferentes estados y variantes
- 🔧 Modificar props en tiempo real con knobs
- 📱 Simular diferentes dispositivos (iPhone, iPad, Android)
- 🌗 Ver componentes en tema claro y oscuro
- 🔗 Comparar implementación vs diseño de Figma

**Benefit para equipos:**
- Diseñadores pueden revisar componentes sin instalar nada
- Desarrolladores tienen un catálogo vivo del sistema de diseño
- QA puede probar edge cases fácilmente
- Reducción de idas y vueltas entre diseño y desarrollo

## 💻 Desarrollo Local

### Ejecutar la App Principal

```bash
flutter run
```

### Ejecutar Widgetbook

```bash
cd widgetbook

# Generar código (necesario después de cambios)
dart run build_runner build --delete-conflicting-outputs

# Ejecutar en Chrome
flutter run -d chrome
```

Deberías ver el botón en `[Buttons]/AppButton/Interactive` con knobs funcionales.

## 📚 Documentación

### Para Empezar
- 📖 [`docs/PRIMER_PUSH_MANUAL.md`](./docs/PRIMER_PUSH_MANUAL.md) - Tu primer push a Cloud
- 🗺️ [`docs/ROADMAP_DEMO.md`](./docs/ROADMAP_DEMO.md) - Plan completo de la demo
- 📱 [`widgetbook/README.md`](./widgetbook/README.md) - Guía del widgetbook

### Documentación Completa
- 📘 [`docs/GUIA_USO_WIDGETBOOK.md`](./docs/GUIA_USO_WIDGETBOOK.md) - Guía completa (50KB)
- 🎨 [`docs/FIGMA_LINKS_GUIDE.md`](./docs/FIGMA_LINKS_GUIDE.md) - Integración con Figma
- ⚙️ [`docs/GITHUB_SETUP.md`](./docs/GITHUB_SETUP.md) - GitHub Actions (Fase 5)
- 👥 [`docs/TEAM_WORKFLOW.md`](./docs/TEAM_WORKFLOW.md) - Workflow del equipo (Fase 9)
- 🧪 [`docs/mocking_testing.md`](./docs/mocking_testing.md) - Testing avanzado (Fase 7)
- 🔄 [`docs/CICDIntegration.md`](./docs/CICDIntegration.md) - CI/CD con otras plataformas

## 🎯 Casos de Uso de la Demo

### 1. Para Desarrolladores
Aprender a:
- Catalogar componentes en Widgetbook
- Usar knobs para hacer componentes interactivos
- Organizar use-cases de forma efectiva
- Integrar Widgetbook en el workflow diario

### 2. Para Diseñadores
Aprender a:
- Revisar componentes en Widgetbook Cloud
- Usar el overlay de Figma para comparar diseños
- Dar feedback efectivo en PRs
- Aprobar componentes visualmente

### 3. Para Equipos
Demostrar:
- Flujo de colaboración diseño-desarrollo
- Reducción de iteraciones y malentendidos
- Catálogo vivo del sistema de diseño
- Proceso escalable para equipos grandes

## ✅ Checklist del Primer Push

Antes de continuar a la Fase 1, asegúrate de:

- [ ] Widgetbook ejecuta localmente (`flutter run -d chrome`)
- [ ] Ves el botón con knobs funcionales
- [ ] Build de web completa sin errores
- [ ] CLI de Widgetbook instalado
- [ ] Primer push a Cloud exitoso
- [ ] Puedes ver el botón en Widgetbook Cloud
- [ ] Probaste los knobs (text, variant, loading, enabled)
- [ ] Probaste cambiar viewport (iPhone, iPad)
- [ ] Probaste cambiar tema (Light, Dark)
- [ ] Probaste el Grid addon
- [ ] Probaste el TextScale addon

**¿Todos completos?** ¡Felicidades! Estás listo para la Fase 1. 🎉

Ver `docs/ROADMAP_DEMO.md` para continuar.

## 🐛 Troubleshooting

### "build_runner failed"

```bash
flutter clean
flutter pub get
cd widgetbook
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs --verbose
```

### "widgetbook command not found"

```bash
export PATH="$PATH":"$HOME/.pub-cache/bin"
echo 'export PATH="$PATH":"$HOME/.pub-cache/bin"' >> ~/.zshrc
```

### "No veo el botón en Widgetbook local"

- ¿Ejecutaste `dart run build_runner build`?
- ¿Reiniciaste la app después de regenerar?
- ¿Estás en el directorio `widgetbook/`?

### Más problemas

Consulta `docs/PRIMER_PUSH_MANUAL.md` sección de Troubleshooting.

## 🤝 Contribuir

Este es un proyecto de demo, pero si encuentras mejoras:

1. Crea un issue describiendo el problema
2. Propón una solución
3. Si quieres, crea un PR

## 📞 Soporte

- 📖 Consulta la documentación en `docs/`
- 🐛 Reporta problemas como GitHub Issues
- 💬 Haz preguntas en GitHub Discussions

## 🙏 Agradecimientos

- [Widgetbook](https://widgetbook.io) - Por la herramienta increíble
- [Flutter](https://flutter.dev) - Por el framework
- Comunidad de Flutter por el soporte

---

**Próximo paso:** 📖 Lee [`docs/PRIMER_PUSH_MANUAL.md`](./docs/PRIMER_PUSH_MANUAL.md) y haz tu primer push a Widgetbook Cloud.

**¡Mucha suerte con tu demo!** 🚀
