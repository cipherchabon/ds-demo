# Workflow del Equipo: Widgetbook en Producción

Esta guía describe el flujo de trabajo completo para usar Widgetbook en un entorno de producción con equipos de desarrollo frontend/mobile y producto/diseño.

## 🎯 Objetivo

Establecer un proceso colaborativo donde diseñadores y desarrolladores trabajen juntos eficientemente, usando Widgetbook como fuente única de verdad para el sistema de diseño.

---

## 👥 Roles y Responsabilidades

### Diseñadores (Producto/UX/UI)

**Responsabilidades:**
- ✏️ Crear y mantener componentes en Figma
- 🔗 Proporcionar links de Figma a desarrolladores
- 👀 Revisar implementaciones en Widgetbook Cloud
- ✅ Aprobar o solicitar cambios en componentes
- 📱 Probar diferentes estados y dispositivos
- 🎨 Garantizar consistencia con el sistema de diseño

**Herramientas:**
- Figma (diseño)
- Widgetbook Cloud (revisión)
- GitHub (comentarios en PRs)

### Desarrolladores (Frontend/Mobile)

**Responsabilidades:**
- 💻 Implementar componentes según diseños de Figma
- 📚 Crear use-cases en Widgetbook para todos los estados
- 🔗 Agregar `designLink` a use-cases
- 🧪 Probar componentes con diferentes props/estados
- 🐛 Corregir inconsistencias señaladas por diseñadores
- 📖 Documentar componentes y props

**Herramientas:**
- Flutter/Dart (desarrollo)
- Widgetbook (catálogo)
- Widgetbook Cloud (validación)
- GitHub (CI/CD)

### QA/Product Managers

**Responsabilidades:**
- 🔍 Revisar componentes en Widgetbook Cloud
- ✓ Validar casos edge y estados de error
- 📋 Verificar accesibilidad y usabilidad
- 📊 Aprobar componentes antes de producción

**Herramientas:**
- Widgetbook Cloud (revisión)
- GitHub (tracking)

---

## 🔄 Flujo de Trabajo Completo

### Fase 1: Diseño (Figma)

**Diseñador:**

1. Crea o actualiza componente en Figma
2. Define todas las variantes (primary, secondary, disabled, etc.)
3. Documenta especificaciones (colores, tamaños, espaciado)
4. Obtiene link de Figma para cada variante:
   - Click derecho en frame → "Copy link to selection"
   - O usa el botón Share → "Copy link"

**Output:**
- Componentes en Figma con todas sus variantes
- Links de Figma listos para compartir

**Ejemplo:**
```
Nuevo componente: Primary Button
Figma: https://www.figma.com/design/.../ds-demo?node-id=1-131

Specs:
- Color de fondo: #2196F3
- Texto: #FFFFFF
- Alto: 48px
- Border radius: 8px
- Padding: 16px horizontal
```

---

### Fase 2: Comunicación (GitHub/Jira/Slack)

**Diseñador:**

Crea un ticket o issue con:
- Nombre del componente
- Link(s) de Figma
- Especificaciones técnicas
- Casos de uso esperados
- Prioridad

**Ejemplo de GitHub Issue:**
```markdown
## 🎨 Nuevo Componente: AppButton

**Descripción:**
Implementar botón del sistema de diseño con 3 variantes

**Figma Links:**
- Primary: https://figma.com/.../node-id=1-131
- Secondary: https://figma.com/.../node-id=1-132
- Disabled: https://figma.com/.../node-id=1-133

**Estados requeridos:**
- Default
- Hover (solo web)
- Pressed
- Disabled
- Loading

**Prioridad:** Alta
**Asignado a:** @developer
```

---

### Fase 3: Implementación (Flutter)

**Desarrollador:**

#### 3.1 Crear el componente

```bash
# Crear archivo del componente
touch lib/design_system/buttons/app_button.dart
```

```dart
// lib/design_system/buttons/app_button.dart
class AppButton extends StatelessWidget {
  final String text;
  final ButtonVariant variant;
  final bool isLoading;
  final VoidCallback? onPressed;

  const AppButton({
    super.key,
    required this.text,
    this.variant = ButtonVariant.primary,
    this.isLoading = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Implementación...
  }
}
```

#### 3.2 Crear use-cases en Widgetbook

```dart
// widgetbook/lib/use_cases/buttons_usecases.dart
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Primary',
  type: AppButton,
  path: '[Buttons]/AppButton/States',
  designLink: 'https://figma.com/.../node-id=1-131',  // ← Link de Figma
)
Widget buildPrimaryButton(BuildContext context) {
  return AppButton(
    text: 'Primary Button',
    variant: ButtonVariant.primary,
    onPressed: () {},
  );
}

@widgetbook.UseCase(
  name: 'Interactive',
  type: AppButton,
  path: '[Buttons]/AppButton',
  designLink: 'https://figma.com/.../node-id=1-131',
)
Widget buildInteractiveButton(BuildContext context) {
  return AppButton(
    text: context.knobs.string(label: 'Text', initialValue: 'Click me'),
    variant: context.knobs.dropdown(
      label: 'Variant',
      options: ButtonVariant.values,
    ),
    isLoading: context.knobs.boolean(label: 'Loading'),
    onPressed: context.knobs.boolean(label: 'Enabled', initialValue: true)
        ? () => debugPrint('Pressed')
        : null,
  );
}
```

#### 3.3 Generar Widgetbook

```bash
cd widgetbook
dart run build_runner build --delete-conflicting-outputs
```

#### 3.4 Probar localmente

```bash
cd widgetbook
flutter run -d chrome
```

Verifica:
- ✅ Todos los estados se ven correctos
- ✅ Los knobs funcionan (use-case interactivo)
- ✅ No hay errores en consola
- ✅ El componente es responsive

#### 3.5 Commit y Push

```bash
git checkout -b feat/app-button-component
git add .
git commit -m "feat: Implementar AppButton con 3 variantes

- Agregar componente AppButton (primary, secondary, text)
- Crear use-cases en Widgetbook con Figma links
- Agregar estado de loading
- Soportar habilitado/deshabilitado

Relacionado: #123"

git push origin feat/app-button-component
```

#### 3.6 Crear Pull Request

En GitHub:
1. Click "Create Pull Request"
2. Título: `feat: Implementar AppButton component`
3. Descripción:

```markdown
## 🎨 Implementación de AppButton

**Issue:** #123

### Cambios
- ✅ Componente AppButton implementado
- ✅ 3 variantes: primary, secondary, text
- ✅ Estado de loading
- ✅ Use-cases en Widgetbook
- ✅ Figma links agregados

### Widgetbook Cloud
El CI generará automáticamente el build de Widgetbook.
Revisar en el comentario automático abajo.

### Checklist de Diseño
- [ ] Primary button coincide con Figma
- [ ] Secondary button coincide con Figma
- [ ] Estado disabled es correcto
- [ ] Loading spinner se ve bien
- [ ] Funciona en diferentes tamaños de pantalla

cc @designer para revisión
```

---

### Fase 4: CI/CD Automático

**GitHub Actions (automático):**

1. ✅ Instala Flutter
2. ✅ Descarga dependencias
3. ✅ Genera Widgetbook con build_runner
4. ✅ Ejecuta coverage check (opcional)
5. ✅ Construye Widgetbook para web
6. ✅ Sube build a Widgetbook Cloud
7. ✅ Comenta en el PR con link de Widgetbook Cloud

**Output:**
- ✅ Status check en el PR (verde = success, rojo = failed)
- 💬 Comentario automático con link de Widgetbook Cloud

**Comentario automático ejemplo:**
```
📚 Widgetbook Cloud

Tu Widgetbook ha sido publicado exitosamente.

🔗 Ver Widgetbook en Cloud

Branch: feat/app-button-component
Commit: abc123d
```

---

### Fase 5: Revisión de Diseño

**Diseñador:**

#### 5.1 Acceder a Widgetbook Cloud

1. Click en el link del comentario automático en el PR
2. O ve directamente a [app.widgetbook.io](https://app.widgetbook.io)
3. Selecciona el branch del PR

#### 5.2 Revisar el componente

1. **Navegar al componente:**
   - Sidebar izquierdo → Buttons → AppButton

2. **Probar diferentes estados:**
   - Click en cada use-case (Primary, Secondary, Disabled, Loading)
   - Usa el use-case "Interactive" para probar con knobs

3. **Comparar con Figma (Overlay):**
   - Click en el icono de Figma (arriba a la derecha)
   - Se abre overlay con el diseño de Figma sobre la implementación
   - Ajusta opacidad para comparar píxel a píxel
   - Verifica:
     - ✓ Colores coinciden
     - ✓ Tamaños coinciden
     - ✓ Espaciado es correcto
     - ✓ Tipografía es correcta

4. **Probar en diferentes dispositivos:**
   - Usa el addon "Viewport" (toolbar superior)
   - Selecciona iPhone 15, iPad, Android, etc.
   - Verifica que se vea bien en todos

5. **Probar en tema claro/oscuro:**
   - Usa el addon "Theme" (toolbar superior)
   - Cambia entre Light y Dark
   - Verifica contraste y legibilidad

6. **Probar accesibilidad:**
   - Usa el addon "Text Scale" (si está habilitado)
   - Prueba con diferentes tamaños de fuente
   - Verifica que el componente no se rompa

#### 5.3 Dar feedback

**Si está correcto:**
```markdown
✅ **Aprobado desde perspectiva de diseño**

He revisado el componente en Widgetbook Cloud y coincide con el diseño de Figma:
- ✅ Colores correctos
- ✅ Tamaños correctos
- ✅ Espaciado correcto
- ✅ Se ve bien en móvil y tablet
- ✅ Funciona en tema claro y oscuro

Excelente trabajo! 🎉
```

**Si necesita cambios:**
```markdown
🔧 **Solicitar cambios**

He revisado en Widgetbook Cloud y encontré algunas inconsistencias:

1. **Primary button - Border radius**
   - Esperado (Figma): 8px
   - Actual (Widgetbook): 4px
   - Fix: Actualizar border radius a 8px

2. **Loading state - Color del spinner**
   - Esperado: Color blanco
   - Actual: Color del tema
   - Fix: Forzar color blanco para el spinner

3. **Disabled state - Opacidad**
   - Se ve demasiado transparente
   - Sugerencia: Usar opacity 0.5 en lugar de 0.3

Screenshots adjuntos para referencia.
```

---

### Fase 6: Iteración (si es necesario)

**Desarrollador:**

1. Lee el feedback del diseñador
2. Realiza los cambios solicitados
3. Commit y push (al mismo branch):

```bash
git add .
git commit -m "fix: Ajustar border radius y loading spinner del AppButton

- Actualizar border radius de 4px a 8px
- Forzar color blanco para loading spinner
- Ajustar opacidad del estado disabled a 0.5"

git push origin feat/app-button-component
```

4. CI/CD se ejecuta automáticamente otra vez
5. Nuevo comentario con link actualizado
6. Diseñador revisa nuevamente

**Este ciclo se repite hasta que el diseñador apruebe.**

---

### Fase 7: Aprobación y Merge

**Una vez aprobado:**

1. ✅ Diseñador aprueba el PR (GitHub Reviews)
2. ✅ Desarrollador mergea a main/develop
3. ✅ CI/CD se ejecuta en main
4. ✅ Widgetbook Cloud ahora muestra el componente en la rama main

**El componente está listo para usarse en producción.**

---

## 📊 Dashboard de Widgetbook Cloud

### Para Diseñadores

**Qué pueden hacer:**
- 👀 Ver todos los componentes del sistema de diseño
- 🔄 Comparar diferentes versiones (branches)
- 📱 Probar en diferentes dispositivos
- 🎨 Ver componentes en diferentes temas
- 🔗 Comparar con Figma usando overlay
- 📸 Tomar screenshots para documentación
- ✅ Aprobar componentes visualmente

### Para Desarrolladores

**Qué pueden hacer:**
- 📚 Ver catálogo completo de componentes
- 🧪 Probar props/estados con knobs
- 🔍 Ver código fuente de use-cases
- 📖 Documentación de componentes
- 🐛 Debugear problemas visuales
- 📊 Ver coverage de componentes

### Para QA/PM

**Qué pueden hacer:**
- ✓ Validar funcionalidad de componentes
- 📋 Verificar que existan todos los estados
- 🔍 Probar casos edge
- 📱 Verificar responsive design
- ♿ Validar accesibilidad
- 📊 Ver progreso del sistema de diseño

---

## 🎯 Best Practices

### Para Diseñadores

#### ✅ DO (Hacer)

- ✅ Proporcionar links de Figma específicos para cada variante
- ✅ Revisar componentes en Widgetbook Cloud tan pronto como el CI termine
- ✅ Probar en múltiples dispositivos y temas
- ✅ Dar feedback específico y accionable
- ✅ Aprobar PRs cuando todo esté correcto
- ✅ Mantener Figma actualizado y organizado
- ✅ Documentar decisiones de diseño en comments

#### ❌ DON'T (No hacer)

- ❌ Asumir que el desarrollador "debería saberlo"
- ❌ Dar feedback vago como "no se ve bien"
- ❌ Ignorar el Widgetbook Cloud y solo revisar código
- ❌ Cambiar diseños de Figma sin comunicar
- ❌ Aprobar componentes sin revisar en diferentes dispositivos

### Para Desarrolladores

#### ✅ DO (Hacer)

- ✅ Crear use-case para CADA estado del componente
- ✅ Agregar `designLink` a todos los use-cases
- ✅ Crear al menos un use-case interactivo con knobs
- ✅ Probar localmente antes de push
- ✅ Usar fixtures para datos de ejemplo
- ✅ Documentar props complejas
- ✅ Responder rápido al feedback de diseñadores
- ✅ Hacer commits pequeños y frecuentes

#### ❌ DON'T (No hacer)

- ❌ Pushear código sin probar en Widgetbook local
- ❌ Ignorar errores de build_runner
- ❌ Omitir use-cases de estados "obvios"
- ❌ Hardcodear datos en use-cases (usar fixtures)
- ❌ Mergear sin aprobación del diseñador
- ❌ Cambiar componentes sin actualizar use-cases

---

## 🔧 Comandos Útiles

### Desarrolladores

```bash
# Ejecutar Widgetbook localmente
cd widgetbook
flutter run -d chrome

# Generar código (después de cambios en use-cases)
dart run build_runner build --delete-conflicting-outputs

# Ver coverage de componentes
widgetbook coverage --path lib/

# Ver coverage con threshold
widgetbook coverage --path lib/ --threshold 80

# Limpiar builds anteriores
flutter clean
cd widgetbook && flutter clean
```

### CI/CD

```bash
# Ver logs de GitHub Actions
# Ve a: github.com/tu-repo/actions

# Re-ejecutar workflow fallido
# Click en "Re-run jobs" en la página de Actions

# Ver status checks de PR
# Ve a la pestaña "Checks" en el PR
```

---

## 🐛 Troubleshooting

### "No veo el botón de Figma en Widgetbook Cloud"

**Problema:** El overlay de Figma no aparece

**Solución:**
1. Verifica que el `designLink` esté en el use-case
2. Ejecuta `dart run build_runner build -d`
3. Push nuevamente
4. Espera a que CI termine

### "El build de Widgetbook falla en CI"

**Problema:** Status check rojo en PR

**Solución:**
1. Ve a Actions tab en GitHub
2. Click en el workflow fallido
3. Lee los logs para ver el error
4. Problemas comunes:
   - ❌ Error de build_runner → Verifica anotaciones
   - ❌ Error de Flutter build → Verifica sintaxis
   - ❌ Error de upload → Verifica API key

### "El overlay de Figma no coincide"

**Problema:** El diseño de Figma se ve desalineado

**Solución:**
1. Verifica que el node-id sea correcto
2. Asegúrate de que estás en el use-case correcto
3. Considera que el overlay es aproximado, no píxel-perfect
4. Usa zoom para ver detalles

### "Changes requested pero no entiendo qué cambiar"

**Problema:** Feedback vago del diseñador

**Solución:**
1. Responde en el PR solicitando clarificación
2. Agenda una llamada rápida para revisar juntos
3. Comparte screenshots de lo que ves en tu local vs Cloud
4. Usa la función de comentarios inline en GitHub

---

## 📈 Métricas de Éxito

### Para el equipo

- **Velocidad de desarrollo:** Tiempo de ticket a producción
- **Iteraciones:** Número de vueltas de feedback por componente (objetivo: < 2)
- **Coverage:** % de componentes catalogados en Widgetbook (objetivo: > 80%)
- **Aprobación:** % de componentes aprobados en primera revisión (objetivo: > 70%)
- **Consistencia:** Diferencias reportadas entre Figma y implementación

### KPIs individuales

**Diseñadores:**
- Tiempo promedio de respuesta a PRs (objetivo: < 24h)
- Calidad de feedback (específico vs vago)
- Actualización de Figma tras cambios

**Desarrolladores:**
- Componentes implementados por semana
- Coverage de use-cases (objetivo: 100% de estados)
- Tiempo de fix tras feedback (objetivo: < 48h)

---

## 🚀 Próximos Pasos

### Nivel 1: Básico (Ya implementado en esta demo)

- ✅ CI/CD con GitHub Actions
- ✅ Widgetbook Cloud automático
- ✅ Figma integration (designLink)
- ✅ Fixtures para datos de ejemplo
- ✅ Coverage tracking

### Nivel 2: Intermedio (Opcional)

- 🔄 Configurar Codemagic (además de GitHub Actions)
- 🔔 Notificaciones de Slack cuando se sube un build
- 📸 Multi-snapshot para pruebas visuales automáticas
- ♿ Addons de accesibilidad (TextScale, Semantics)
- 📊 Dashboard de métricas de sistema de diseño

### Nivel 3: Avanzado (Futuro)

- 🤖 Visual regression tests automáticos
- 📦 Publicar componentes como package separado
- 🌐 Internationalization testing
- 🔐 Branch protection rules basados en Widgetbook
- 📝 Generación automática de changelog de componentes

---

## 📚 Recursos Adicionales

- [Guía de uso de Widgetbook](./GUIA_USO_WIDGETBOOK.md)
- [Integración con Figma](./figma_integration.md)
- [Guía de links de Figma](./FIGMA_LINKS_GUIDE.md)
- [Setup de GitHub Actions](./GITHUB_SETUP.md)
- [Testing y Mocking](./mocking_testing.md)
- [Widgetbook Docs oficiales](https://docs.widgetbook.io)

---

## 💡 Tips Finales

### Comunicación

- 💬 Usa threads en PRs para mantener conversaciones organizadas
- 📸 Adjunta screenshots cuando reportes problemas visuales
- 🎥 Graba videos cortos para explicar bugs complejos
- 🔗 Siempre linkea al PR o issue relacionado

### Organización

- 📁 Organiza components en Widgetbook igual que en Figma
- 🏷️ Usa nombres consistentes entre Figma y Widgetbook
- 📝 Documenta decisiones de diseño en use-cases
- 🗂️ Agrupa use-cases por categoría ([Buttons], [Cards], etc.)

### Productividad

- ⚡ Usa el use-case interactivo primero para explorar
- 💾 Crea fixtures reutilizables para datos comunes
- 🔁 Automatiza todo lo que puedas
- 📅 Agenda revisiones regulares de sistema de diseño

---

**¿Preguntas?**

- 🐛 Reporta bugs: [GitHub Issues](https://github.com/tu-repo/issues)
- 💬 Discusiones: [GitHub Discussions](https://github.com/tu-repo/discussions)
- 📧 Contacto: design-system@tuempresa.com
