## Integración CI/CD

La integración con CI/CD permite automatizar el proceso de build y deploy a Widgetbook Cloud en cada commit.

### Pre-requisitos

1. **Cuenta en Widgetbook Cloud**: Crear cuenta en [widgetbook.io](https://widgetbook.io)
2. **Proyecto creado**: Crear un proyecto en Widgetbook Cloud
3. **API Key**: Obtener el API key del proyecto (Settings → API Keys)
4. **Widgetbook configurado**: Tener Widgetbook funcionando localmente

### GitHub Actions - Configuración Completa

#### Paso 1: Guardar API Key como Secret

1. Ve a tu repositorio en GitHub
2. Settings → Secrets and variables → Actions
3. New repository secret
4. Name: `WIDGETBOOK_API_KEY`
5. Value: Tu API key (empieza con `wba_`)

#### Paso 2: Crear Workflow

Crea `.github/workflows/widgetbook-cloud.yml`:

```yaml
name: Widgetbook Cloud Hosting

# Ejecutar en cada push a cualquier branch
on:
  push:
    branches:
      - "**"
  pull_request:
    branches:
      - "**"

# Ejecutar solo en cambios relevantes (opcional)
# on:
#   push:
#     paths:
#       - 'lib/**'
#       - 'packages/**'
#       - 'widgetbook/**'
#       - 'pubspec.yaml'

jobs:
  widgetbook-cloud-hosting:
    runs-on: ubuntu-latest

    # Permisos necesarios para GitHub status checks
    permissions:
      contents: read
      statuses: write
      pull-requests: write

    steps:
      # 1. Checkout del código
      - name: Checkout repository
        uses: actions/checkout@v4

      # 2. Setup de Flutter
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          channel: "stable"
          flutter-version: "3.24.0" # Especifica la versión
          cache: true

      # 3. Verificar versión de Flutter
      - name: Flutter doctor
        run: flutter doctor -v

      # 4. Bootstrap de la app principal
      - name: Bootstrap main app
        run: |
          flutter pub get
          dart run build_runner build --delete-conflicting-outputs

      # 5. Si usas Melos (opcional)
      # - name: Setup Melos
      #   run: |
      #     dart pub global activate melos
      #     melos bootstrap

      # 6. Bootstrap y build de Widgetbook
      - name: Build Widgetbook
        working-directory: widgetbook
        run: |
          flutter pub get
          dart run build_runner build --delete-conflicting-outputs
          flutter build web --release --target lib/main.dart

      # 7. Instalar Widgetbook CLI
      - name: Install Widgetbook CLI
        run: dart pub global activate widgetbook_cli

      # 8. Push a Widgetbook Cloud
      - name: Push to Widgetbook Cloud
        working-directory: widgetbook
        run: |
          widgetbook cloud build push \
            --api-key ${{ secrets.WIDGETBOOK_API_KEY }} \
            --branch ${{ github.head_ref || github.ref_name }} \
            --repository ${{ github.repository }} \
            --commit ${{ github.sha }} \
            --actor ${{ github.actor }}

      # 9. Comentar en PR con link (opcional)
      - name: Comment PR
        if: github.event_name == 'pull_request'
        uses: actions/github-script@v7
        with:
          script: |
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: '🎨 Widgetbook build completed! View the catalog and UI review in the commit status checks.'
            })
```

#### Paso 3: Workflow con Caché (Optimizado)

Para builds más rápidos, agrega caché de dependencias:

```yaml
name: Widgetbook Cloud Hosting (Optimized)

on:
  push:
    branches: ["**"]

jobs:
  widgetbook-cloud-hosting:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      statuses: write

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          channel: stable
          cache: true

      # Cache de dependencias de la app principal
      - name: Cache app dependencies
        uses: actions/cache@v3
        with:
          path: |
            ~/.pub-cache
            .dart_tool
          key: ${{ runner.os }}-pub-${{ hashFiles('**/pubspec.lock') }}
          restore-keys: |
            ${{ runner.os }}-pub-

      - name: Get app dependencies
        run: flutter pub get

      # Cache de dependencias de Widgetbook
      - name: Cache widgetbook dependencies
        uses: actions/cache@v3
        with:
          path: |
            widgetbook/.dart_tool
          key: ${{ runner.os }}-widgetbook-${{ hashFiles('widgetbook/pubspec.lock') }}
          restore-keys: |
            ${{ runner.os }}-widgetbook-

      - name: Build Widgetbook
        working-directory: widgetbook
        run: |
          flutter pub get
          dart run build_runner build -d
          flutter build web -t lib/main.dart

      - name: Install Widgetbook CLI
        run: dart pub global activate widgetbook_cli

      - name: Push to Widgetbook Cloud
        working-directory: widgetbook
        run: widgetbook cloud build push --api-key ${{ secrets.WIDGETBOOK_API_KEY }}
```

#### Codemagic

`codemagic.yaml`:

```yaml
workflows:
  widgetbook-workflow:
    name: Widgetbook Cloud

    environment:
      flutter: stable

      vars:
        WIDGETBOOK_API_KEY: Encrypted(...) # Encriptar con Codemagic CLI

    scripts:
      - name: Get dependencies
        script: |
          flutter pub get
          cd widgetbook
          flutter pub get

      - name: Build Widgetbook
        script: |
          cd widgetbook
          dart run build_runner build -d
          flutter build web -t lib/main.dart

      - name: Push to Widgetbook Cloud
        script: |
          dart pub global activate widgetbook_cli
          cd widgetbook
          dart pub global run widgetbook_cli cloud build push --api-key $WIDGETBOOK_API_KEY

    triggering:
      events:
        - push
      branch_patterns:
        - pattern: "*"
```

### Troubleshooting CI/CD

#### Error: "API key is invalid"

```bash
# Verificar que el secret esté configurado correctamente
# El API key debe empezar con wba_

# En GitHub Actions:
echo "Key length: ${#WIDGETBOOK_API_KEY}"  # Debe ser > 20

# Verificar en Widgetbook Cloud:
# Settings → API Keys → Regenerar si es necesario
```

#### Error: "Build failed - assets not found"

```yaml
# Asegúrate de hacer pub get en AMBOS directorios
- name: Bootstrap
  run: |
    flutter pub get  # App principal
    cd widgetbook
    flutter pub get  # Widgetbook
```

#### Error: "Out of memory"

```yaml
# Aumentar memoria disponible para Dart
- name: Build Widgetbook
  run: |
    cd widgetbook
    flutter build web --dart-define=FLUTTER_WEB_USE_SKIA=true
  env:
    DART_VM_OPTIONS: "--old_gen_heap_size=4096"
```

#### Build muy lento

```yaml
# Agregar caché
- uses: actions/cache@v3
  with:
    path: |
      ~/.pub-cache
      **/.dart_tool
    key: ${{ runner.os }}-pub-${{ hashFiles('**/pubspec.lock') }}

# Usar flutter build web con opciones de optimización
- run: flutter build web --release --web-renderer html --tree-shake-icons
```

---
