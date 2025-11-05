# Configuración de GitHub Actions para Widgetbook Cloud

## Prerequisitos

1. Cuenta en Widgetbook Cloud ([app.widgetbook.io](https://app.widgetbook.io))
2. Proyecto creado en Widgetbook Cloud
3. API Key generado (ya lo tienes: `9ba437347f12fd3a8c8267142db7abcaf0c48022bd4e6838dd023464fa031346`)
4. Repositorio en GitHub

## Paso 1: Configurar el Secret en GitHub

1. Ve a tu repositorio en GitHub
2. Click en **Settings** (Configuración)
3. En el menú lateral, ve a **Secrets and variables** → **Actions**
4. Click en **New repository secret**
5. Configura el secret:
   - **Name:** `WIDGETBOOK_API_KEY`
   - **Value:** `9ba437347f12fd3a8c8267142db7abcaf0c48022bd4e6838dd023464fa031346`
6. Click en **Add secret**

## Paso 2: Verificar el Workflow

El workflow ya está configurado en `.github/workflows/widgetbook.yml`

### ¿Qué hace el workflow?

1. **Se ejecuta automáticamente** en:
   - Push a `main` o `develop`
   - Pull Requests hacia `main` o `develop`

2. **Proceso:**
   - ✅ Instala Flutter
   - ✅ Descarga dependencias del proyecto principal
   - ✅ Descarga dependencias de widgetbook
   - ✅ Genera código con build_runner
   - ✅ Construye widgetbook para web
   - ✅ Sube el build a Widgetbook Cloud
   - ✅ Comenta en el PR con el link de Widgetbook Cloud

3. **Optimizaciones incluidas:**
   - Caching de Flutter SDK
   - Build web optimizado para producción
   - Comentarios automáticos en PRs

## Paso 3: Probar el Workflow

### Opción A: Crear un Pull Request

```bash
# Crea una nueva rama
git checkout -b test/widgetbook-ci

# Haz un cambio pequeño (ej: agregar un comentario)
echo "// Test CI" >> widgetbook/lib/main.dart

# Commit y push
git add .
git commit -m "Test: Verificar workflow de Widgetbook"
git push origin test/widgetbook-ci

# Crea un PR en GitHub desde la rama test/widgetbook-ci hacia main
```

### Opción B: Push directo a main/develop

```bash
git checkout main
# Haz cambios...
git commit -m "feat: Actualizar componentes"
git push origin main
```

## Paso 4: Monitorear el Build

1. Ve a la pestaña **Actions** en GitHub
2. Verás el workflow "Widgetbook Cloud" ejecutándose
3. Click para ver logs detallados
4. Si hay errores, revisa los logs para diagnosticar

## Paso 5: Ver en Widgetbook Cloud

1. Una vez que el workflow termine exitosamente
2. Ve a [app.widgetbook.io](https://app.widgetbook.io)
3. Selecciona tu proyecto
4. Deberías ver tu build listado con:
   - Nombre de la rama
   - Commit hash
   - Timestamp
   - Autor

## Status Check en Pull Requests

El workflow agrega un status check a los PRs. Esto permite:

- ✅ Bloquear merge si el build de Widgetbook falla
- ✅ Ver el link directo a Widgetbook Cloud desde el PR
- ✅ Revisar cambios visuales antes de aprobar

### Configurar Branch Protection (Opcional)

Para hacer obligatorio que el build pase antes de mergear:

1. Settings → Branches → Add rule
2. Branch name pattern: `main`
3. Marca "Require status checks to pass before merging"
4. Busca y selecciona: `Build & Upload to Widgetbook Cloud`
5. Save changes

## Troubleshooting

### Error: "WIDGETBOOK_API_KEY not found"

- Verifica que el secret esté configurado correctamente en GitHub
- El nombre debe ser exactamente `WIDGETBOOK_API_KEY`

### Error: "build_runner failed"

- Revisa que todos los use-cases tengan las anotaciones correctas
- Ejecuta localmente: `cd widgetbook && dart run build_runner build -d`

### Error: "Flutter version mismatch"

- Ajusta la versión de Flutter en el workflow (línea 22) para que coincida con la versión que usas localmente
- Verifica con: `flutter --version`

### Error: "Upload to Widgetbook Cloud failed"

- Verifica que el API key sea válido
- Asegúrate de que el proyecto exista en Widgetbook Cloud
- Revisa que tengas permisos para subir builds

## Próximos Pasos

Una vez que el CI funcione:

1. ✅ Configurar Figma links en use-cases (ver `figma_integration.md`)
2. ✅ Implementar coverage checks (ver `GUIA_USO_WIDGETBOOK.md`)
3. ✅ Configurar notificaciones de Slack/Discord para builds
4. ✅ Entrenar al equipo en el workflow de revisión
