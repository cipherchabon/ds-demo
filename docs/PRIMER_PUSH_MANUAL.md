# Primer Push Manual a Widgetbook Cloud

Guía paso a paso para hacer tu primer push a Widgetbook Cloud usando el CLI.

## 🎯 Objetivo

Publicar tu Widgetbook manualmente en Widgetbook Cloud para:
- Verificar que todo funciona correctamente
- Entender el proceso antes de automatizarlo
- Ver tu catálogo de componentes en la nube

## 📋 Pre-requisitos

Antes de empezar, asegúrate de tener:

- ✅ Flutter instalado y funcionando
- ✅ Cuenta en [Widgetbook Cloud](https://app.widgetbook.io)
- ✅ Proyecto creado en Widgetbook Cloud
- ✅ API Key de tu proyecto (guardado de forma segura)

**Tu API Key:** `9ba437347f12fd3a8c8267142db7abcaf0c48022bd4e6838dd023464fa031346`

## 🚀 Paso a Paso

### Paso 1: Verificar el Proyecto Local

Primero, asegúrate de que tu Widgetbook funciona localmente:

```bash
# Navega al directorio de widgetbook
cd widgetbook

# Instala dependencias
flutter pub get

# Genera el código de Widgetbook
dart run build_runner build --delete-conflicting-outputs
```

**Verifica que no haya errores.** Si todo está bien, continúa.

### Paso 2: Probar Localmente (Opcional pero Recomendado)

Antes de subir a Cloud, prueba que todo se vea bien:

```bash
# Ejecuta en Chrome
flutter run -d chrome
```

Deberías ver:
- ✅ Un botón en la categoría `[Buttons]/AppButton`
- ✅ El use-case "Interactive" con knobs funcionales
- ✅ Puedes cambiar el texto, variante, loading, y enabled

Si todo se ve bien, cierra el navegador y continúa.

### Paso 3: Construir para Web

Widgetbook Cloud necesita un build de web. Vamos a construirlo:

```bash
# Asegúrate de estar en el directorio widgetbook
cd widgetbook

# Limpia builds anteriores (opcional pero recomendado)
flutter clean

# Reinstala dependencias
flutter pub get

# Regenera código
dart run build_runner build --delete-conflicting-outputs

# Construye para web
flutter build web --release --base-href="/widgetbook/"
```

**Tiempo estimado:** 1-3 minutos dependiendo de tu máquina.

**Output esperado:**
```
✓ Built build/web
```

El build estará en `widgetbook/build/web/`.

### Paso 4: Instalar Widgetbook CLI

Instala el CLI globalmente en tu sistema:

```bash
dart pub global activate widgetbook_cli
```

**Output esperado:**
```
Activated widgetbook_cli X.X.X
```

**Verificar instalación:**

```bash
widgetbook --version
```

Deberías ver el número de versión.

**Troubleshooting:**

Si el comando `widgetbook` no se encuentra, agrega el directorio de pub global al PATH:

```bash
# macOS/Linux
export PATH="$PATH":"$HOME/.pub-cache/bin"

# Agrega esto a tu ~/.zshrc o ~/.bashrc para que persista:
echo 'export PATH="$PATH":"$HOME/.pub-cache/bin"' >> ~/.zshrc
source ~/.zshrc
```

### Paso 5: Hacer el Push a Widgetbook Cloud

Ahora viene la parte importante. Tienes **dos opciones** según tus necesidades:

#### Opción A: Versión Mínima (Solo Requeridos) ⭐ Recomendada para empezar

Si solo quieres subir el build rápidamente:

```bash
cd widgetbook
widgetbook cloud build push \
  --api-key "9ba437347f12fd3a8c8267142db7abcaf0c48022bd4e6838dd023464fa031346"
```

✅ **Ventajas:**
- ¡Solo 1 parámetro requerido!
- Simple y rápido
- Perfecto para el primer push

❌ **Desventajas:**
- No verás información de branch/commit en Cloud
- Más difícil organizar múltiples builds

#### Opción B: Versión Completa (Con Metadata)

Si tienes Git configurado y quieres mejor organización:

```bash
cd widgetbook
widgetbook cloud build push \
  --api-key "9ba437347f12fd3a8c8267142db7abcaf0c48022bd4e6838dd023464fa031346" \
  --branch "$(git rev-parse --abbrev-ref HEAD)" \
  --commit "$(git rev-parse HEAD)" \
  --repository "tu-usuario/tu-repo" \
  --actor "$(git config user.name)"
```

**⚠️ Importante:** Reemplaza `tu-usuario/tu-repo` con tu repositorio real de GitHub (ej: `cypherchabon/demoapp`).

✅ **Ventajas:**
- Ves el nombre de la rama en Cloud
- Ves el commit hash para trazabilidad
- Mejor organización de builds
- Links a GitHub (si configuras repository)

#### Opción C: Sin Git (Valores Estáticos)

Si no tienes Git o los comandos `$(git ...)` fallan:

```bash
cd widgetbook
widgetbook cloud build push \
  --api-key "9ba437347f12fd3a8c8267142db7abcaf0c48022bd4e6838dd023464fa031346" \
  --branch "demo" \
  --commit "primer-push"
```

---

**Parámetros explicados:**

| Parámetro | Requerido | Descripción |
|-----------|-----------|-------------|
| `--api-key` | ✅ **SÍ** | Tu API key de Widgetbook Cloud |
| `--path` | ❌ No | Path al directorio padre de `build/` (default: `./`) |
| `--branch` | ❌ No | La rama actual (ej: main, develop, feat/button) |
| `--commit` | ❌ No | El hash del commit actual |
| `--repository` | ❌ No | Tu repositorio de GitHub (formato: usuario/repo) |
| `--actor` | ❌ No | Tu nombre (quien hizo el push) |

**💡 Nota:** Cuando ejecutas desde el directorio `widgetbook/`, el CLI busca automáticamente `build/web/`, por eso no necesitas especificar `--path`.

**Output esperado:**

```
Uploading build to Widgetbook Cloud...
✓ Build uploaded successfully!

View your build at: https://app.widgetbook.io/...
```

### Paso 6: Verificar en Widgetbook Cloud

1. **Abre el link** que te dio el CLI
2. **O navega manualmente:**
   - Ve a https://app.widgetbook.io
   - Inicia sesión
   - Selecciona tu proyecto
   - Verás tu build listado

3. **Explora tu Widgetbook:**
   - Click en el build más reciente
   - Navega a `[Buttons]` → `AppButton` → `Interactive`
   - Juega con los knobs
   - Prueba diferentes viewports (iPhone, iPad, Android)
   - Cambia entre tema claro y oscuro
   - Habilita el Grid addon
   - Prueba el TextScale addon

**¡Felicidades!** 🎉 Has publicado tu primer Widgetbook en Cloud.

## 🔄 Iteraciones Futuras

Cada vez que hagas cambios:

1. **Modifica tu componente** en `lib/design_system/`
2. **Actualiza use-cases** si es necesario
3. **Regenera código:**
   ```bash
   cd widgetbook
   dart run build_runner build -d
   ```
4. **Construye para web:**
   ```bash
   flutter build web --release --base-href="/widgetbook/"
   ```
5. **Push a Cloud:**
   ```bash
   # Versión mínima
   widgetbook cloud build push --api-key "..."

   # O versión con metadata (recomendada)
   widgetbook cloud build push \
     --api-key "..." \
     --branch "$(git rev-parse --abbrev-ref HEAD)" \
     --commit "$(git rev-parse HEAD)"
   ```

## 💡 Tips para Facilitar el Proceso

### Crear un Script de Push

Crea un archivo `widgetbook/push_to_cloud.sh`:

```bash
#!/bin/bash

# Script para push a Widgetbook Cloud
set -e  # Exit on error

echo "🔨 Building Widgetbook..."
flutter build web --release --base-href="/widgetbook/"

echo "☁️  Pushing to Widgetbook Cloud..."
widgetbook cloud build push \
  --api-key "9ba437347f12fd3a8c8267142db7abcaf0c48022bd4e6838dd023464fa031346" \
  --branch "$(git rev-parse --abbrev-ref HEAD)" \
  --commit "$(git rev-parse HEAD)"

echo "✅ Done! Check Widgetbook Cloud"
```

Dale permisos de ejecución:

```bash
chmod +x widgetbook/push_to_cloud.sh
```

Úsalo:

```bash
cd widgetbook
./push_to_cloud.sh
```

### Usar Variable de Entorno para API Key

En lugar de poner el API key directamente, usa una variable de entorno:

```bash
# Agrega a tu ~/.zshrc o ~/.bashrc
export WIDGETBOOK_API_KEY="9ba437347f12fd3a8c8267142db7abcaf0c48022bd4e6838dd023464fa031346"
```

Luego en el script:

```bash
widgetbook cloud build push \
  --api-key "$WIDGETBOOK_API_KEY" \
  ...
```

## 🐛 Troubleshooting

### "Error: widgetbook command not found"

**Solución:** El CLI no está en tu PATH.

```bash
export PATH="$PATH":"$HOME/.pub-cache/bin"
```

### "Error: API key is invalid"

**Causas posibles:**
- El API key es incorrecto (verifica en Widgetbook Cloud)
- El proyecto no existe en Widgetbook Cloud
- No tienes permisos para subir builds

**Solución:** Ve a Widgetbook Cloud → Settings → API Keys y verifica.

### "Error: build/web directory not found"

**Causa:** No ejecutaste el build de Flutter.

**Solución:**
```bash
flutter build web --release --base-href="/widgetbook/"
```

### "Error: No use-cases found"

**Causa:** No ejecutaste `build_runner` para generar el código.

**Solución:**
```bash
dart run build_runner build --delete-conflicting-outputs
```

### "Upload is very slow"

**Causa:** El build de web puede ser grande (varios MB).

**Solución:** Ten paciencia. La primera vez puede tardar 30-60 segundos.

### "Error: Repository not found"

**Causa:** El formato del repositorio es incorrecto.

**Correcto:** `usuario/repo` (ej: `cypherchabon/demoapp`)
**Incorrecto:** `https://github.com/usuario/repo`

## 📊 Verificar tu Build

Una vez subido, verifica en Widgetbook Cloud:

### Checklist de Verificación

- [ ] El build aparece en la lista
- [ ] El branch es correcto
- [ ] El commit hash es correcto
- [ ] Puedes abrir el build
- [ ] Ves el componente AppButton
- [ ] Los knobs funcionan correctamente
- [ ] Puedes cambiar viewports (iPhone, iPad, etc.)
- [ ] Puedes cambiar temas (Light, Dark)
- [ ] El GridAddon funciona
- [ ] El TextScaleAddon funciona

Si todos los checks pasan, ¡estás listo! ✅

## 🎯 Próximos Pasos

Ahora que tienes tu primer push funcionando, puedes:

1. **Iterar en el botón:**
   - Agregar más use-cases (Primary, Secondary, Disabled)
   - Agregar designLink de Figma
   - Ver los cambios en Cloud

2. **Agregar más componentes:**
   - InfoCard, UserCard, AppTextField, etc.
   - Cada uno con sus use-cases
   - Ver cómo crece tu sistema de diseño

3. **Automatizar:**
   - Activar GitHub Actions (workflow está en `.github/workflows/widgetbook.yml.disabled`)
   - Push automático en cada PR
   - Ver `docs/GITHUB_SETUP.md`

Ver `docs/ROADMAP_DEMO.md` para el plan completo de iteraciones.

## 📚 Recursos

- [Documentación del CLI](https://docs.widgetbook.io/cli/overview)
- [Widgetbook Cloud](https://app.widgetbook.io)
- [Guía de uso de Widgetbook](./GUIA_USO_WIDGETBOOK.md)
- [Workflow del equipo](./TEAM_WORKFLOW.md)

---

**¿Problemas?** Revisa la sección de Troubleshooting o consulta la documentación oficial.
