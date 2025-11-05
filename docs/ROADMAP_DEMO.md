# Roadmap de la Demo: Widgetbook Incremental

Este roadmap describe el plan de implementación incremental de Widgetbook para la demo. La idea es empezar con lo mínimo y crecer gradualmente, aprendiendo y aceiting el flujo en cada iteración.

## 🎯 Filosofía: De Menor a Mayor

Cada fase agrega complejidad gradualmente:
1. **Entender** qué hace cada pieza
2. **Practicar** el workflow
3. **Evaluar** si vale la pena el siguiente paso
4. **Iterar** con confianza

## 📊 Estado Actual

### ✅ Fase 0: Setup Inicial (COMPLETADO)

**Objetivo:** Tener lo mínimo funcional para hacer el primer push a Cloud.

**Implementado:**
- ✅ Proyecto base de Flutter con diseño de sistema
- ✅ Widgetbook workspace configurado
- ✅ **1 solo componente:** AppButton
- ✅ **1 solo use-case:** Interactive (con knobs)
- ✅ Addons básicos: Viewport, Theme, Localization, Alignment, Grid, TextScale
- ✅ Documentación del primer push manual

### ✅ Fase 1: Expandir Estados del Botón (COMPLETADO)

**Objetivo:** Entender cómo catalogar diferentes estados de un componente.

**Implementado:**
- ✅ Use-case `Primary` (estado por defecto)
- ✅ Use-case `Secondary` (variante)
- ✅ Use-case `Disabled` (estado deshabilitado)
- ✅ Use-case `Loading` (estado de carga)
- ✅ Use-case `Interactive` (con knobs) - ya existía

**Componentes activos:**
- `AppButton` - 5 use-cases totales

**Use-cases totales:** 5

### ✅ Fase 2: Integración con Figma (COMPLETADO)

**Objetivo:** Aprender cómo conectar componentes con diseños de Figma.

**Implementado:**
- ✅ `designLink` agregado a todos los 5 use-cases del botón
- ✅ Usando Figma: https://www.figma.com/design/eu4y7kUHlOnPQsu160wZkX/ds-demo
- ✅ Diseñadores pueden usar overlay de Figma en Widgetbook Cloud

### ✅ Fase 5: Automatización con GitHub Actions (COMPLETADO)

**Objetivo:** Eliminar el proceso manual de push.

**Implementado:**
- ✅ Workflow activado en `.github/workflows/widgetbook.yml`
- ✅ Push automático en cada push a main/develop
- ✅ Push automático en cada PR
- ✅ Comentarios automáticos en PRs con link de Widgetbook Cloud
- ✅ Status check en PRs

**Próximo paso:** Agregar segundo componente (Fase 3) o agregar fixtures (Fase 4).

---

## 🔜 Fases Futuras

### Fase 1: Expandir Estados del Botón ✅ COMPLETADA

**Objetivo:** Entender cómo catalogar diferentes estados de un componente.

**Tareas:**
1. Agregar use-case `Primary` (estado por defecto)
2. Agregar use-case `Secondary` (variante)
3. Agregar use-case `Disabled` (estado deshabilitado)
4. Agregar use-case `Loading` (estado de carga)

**Resultado esperado:**
- 5 use-cases del AppButton
- Entender cómo organizar use-cases por estados
- Ver cómo se ven múltiples use-cases en Widgetbook Cloud

**Tiempo estimado:** 30 minutos

**Documentación:**
```dart
// Ejemplo de nuevos use-cases a agregar:

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

// Similar para Secondary, Disabled, Loading
```

---

### Fase 2: Integración con Figma

**Objetivo:** Aprender cómo conectar componentes con diseños de Figma.

**Pre-requisitos:**
- Tener acceso al archivo de Figma
- Conocer los node-ids de los componentes

**Tareas:**
1. Obtener links de Figma para cada variante del botón
2. Agregar `designLink` a cada use-case
3. Regenerar código
4. Push a Cloud
5. Verificar overlay de Figma

**Resultado esperado:**
- Todos los use-cases del botón tienen `designLink`
- Diseñadores pueden comparar implementación vs diseño
- Entender el valor del overlay de Figma

**Tiempo estimado:** 20 minutos

**Ejemplo:**
```dart
@widgetbook.UseCase(
  name: 'Primary',
  type: AppButton,
  path: '[Buttons]/AppButton/States',
  designLink: 'https://www.figma.com/design/.../node-id=1-131', // ← Agregar esto
)
```

**Guía:** Ver `docs/FIGMA_LINKS_GUIDE.md`

---

### Fase 3: Segundo Componente

**Objetivo:** Practicar el flujo completo con un componente nuevo.

**Tareas:**
1. Elegir componente a agregar (sugerencia: `InfoCard` o `UserCard`)
2. Crear archivo de use-cases: `widgetbook/lib/use_cases/cards_usecases.dart`
3. Agregar use-case interactivo
4. Agregar use-cases de estados específicos
5. Agregar `designLink` si está disponible
6. Regenerar, build, push

**Resultado esperado:**
- 2 componentes en Widgetbook
- Flujo de agregar componentes es familiar
- Entender organización con `path`

**Tiempo estimado:** 45 minutos

**Organización sugerida:**
```
[Buttons]/
  AppButton/
    Interactive
    States/
      Primary
      Secondary
      Disabled
      Loading

[Cards]/
  InfoCard/
    Interactive
    States/
      Default
      With Icon
```

---

### Fase 4: Fixtures y Datos Reutilizables

**Objetivo:** Aprender a manejar datos complejos de forma DRY.

**Cuándo hacerlo:** Cuando tengas componentes que usan datos complejos (ej: UserCard con nombre, email, avatar).

**Tareas:**
1. Crear `widgetbook/lib/fixtures/` directory
2. Crear fixture class (ej: `UserFixture`)
3. Definir datos de ejemplo (standard, verified, edge cases)
4. Actualizar use-cases para usar fixtures
5. Push y verificar

**Resultado esperado:**
- Datos consistentes entre use-cases
- Fácil mantenimiento
- Edge cases bien documentados

**Tiempo estimado:** 30 minutos

**Ejemplo:**
```dart
// widgetbook/lib/fixtures/user_fixtures.dart
class UserFixtures {
  static const standard = UserFixture(
    name: 'Ana García',
    email: 'ana@example.com',
  );

  static const longName = UserFixture(
    name: 'José Antonio Fernández de la Cruz',
    email: 'jose@example.com',
  );
}
```

**Guía:** Ver `docs/mocking_testing.md`

---

### Fase 5: Automatización con GitHub Actions

**Objetivo:** Eliminar el proceso manual de push.

**Pre-requisitos:**
- Repositorio en GitHub
- Workflow funcionando manualmente
- Equipo familiarizado con el proceso manual

**Tareas:**
1. Renombrar `.github/workflows/widgetbook.yml.disabled` → `widgetbook.yml`
2. Configurar `WIDGETBOOK_API_KEY` en GitHub Secrets
3. Hacer un push de prueba
4. Verificar que el workflow se ejecuta
5. Ver comentario automático en PR

**Resultado esperado:**
- Push automático en cada PR
- Comentarios con links en PRs
- Status check en PRs
- ¡No más push manual! 🎉

**Tiempo estimado:** 30 minutos (si todo va bien)

**Guía:** Ver `docs/GITHUB_SETUP.md`

---

### Fase 6: Componentes Restantes

**Objetivo:** Catalogar todos los componentes del sistema de diseño.

**Tareas:**
1. Agregar `AppTextField` con sus estados
2. Agregar `AppSearchField`
3. Agregar `AppText` (typography)
4. Agregar use-cases para cada componente
5. Agregar `designLink` para todos

**Resultado esperado:**
- Sistema de diseño completo catalogado
- Alta cobertura de componentes
- Documentación visual completa

**Tiempo estimado:** 2-3 horas

**Coverage objetivo:** 100% de componentes públicos

---

### Fase 7: Testing Avanzado

**Objetivo:** Agregar mocking para componentes complejos.

**Cuándo hacerlo:** Cuando tengas componentes con lógica compleja o que dependen de servicios.

**Tareas:**
1. Agregar dependencia `mocktail`
2. Crear mocks de servicios/providers
3. Usar mocks en use-cases
4. Documentar patrones de mocking

**Resultado esperado:**
- Componentes complejos testeables
- Conocimiento de patrones de mocking
- Base para testing automático

**Tiempo estimado:** 1-2 horas

**Guía:** Ver `docs/mocking_testing.md`

---

### Fase 8: Coverage Tracking

**Objetivo:** Medir y mejorar cobertura de componentes catalogados.

**Tareas:**
1. Ejecutar `widgetbook coverage --path lib/`
2. Identificar componentes no catalogados
3. Decidir qué catalogar y qué ignorar
4. Agregar `// widgetbook: ignore` a componentes internos
5. Agregar check de coverage al workflow de CI

**Resultado esperado:**
- Conocer coverage exacto
- Quality gate en CI
- Evitar regresiones

**Tiempo estimado:** 30 minutos

**Threshold sugerido:** 80%

---

### Fase 9: Workflow del Equipo

**Objetivo:** Establecer proceso formal para el equipo.

**Tareas:**
1. Presentar Widgetbook al equipo de diseño
2. Capacitar en uso de Widgetbook Cloud
3. Definir proceso de revisión de UI
4. Documentar roles y responsabilidades
5. Establecer métricas de éxito

**Resultado esperado:**
- Equipo alineado en el proceso
- Diseñadores usan Widgetbook Cloud regularmente
- Proceso de aprobación claro

**Tiempo estimado:** 2-3 reuniones

**Guía:** Ver `docs/TEAM_WORKFLOW.md`

---

### Fase 10: Optimizaciones Avanzadas

**Objetivo:** Funcionalidades avanzadas para equipos maduros.

**Opciones:**
- Multi-snapshot para testing visual automático
- Notificaciones de Slack/Discord
- Branch protection con Widgetbook check
- Publicar componentes como package
- Integración con Codemagic

**Resultado esperado:**
- Workflow pulido y profesional
- Alta productividad del equipo
- Sistema de diseño robusto

**Tiempo estimado:** Variable según necesidades

---

## 📅 Calendario Sugerido

### Semana 1: Fundamentos
- **Día 1:** Fase 0 + Primer push manual
- **Día 2:** Fase 1 (expandir botón)
- **Día 3:** Fase 2 (Figma)
- **Día 4:** Fase 3 (segundo componente)
- **Día 5:** Retrospectiva y ajustes

### Semana 2: Automatización
- **Día 1:** Fase 4 (fixtures)
- **Día 2:** Fase 5 (GitHub Actions)
- **Día 3-4:** Fase 6 (componentes restantes)
- **Día 5:** Retrospectiva

### Semana 3: Madurez
- **Día 1:** Fase 7 (testing avanzado)
- **Día 2:** Fase 8 (coverage)
- **Día 3-4:** Fase 9 (workflow del equipo)
- **Día 5:** Evaluación y decisión de Fase 10

---

## ✅ Checklist por Fase

### Fase 0
- [ ] Widgetbook ejecuta localmente
- [ ] Build de web funciona
- [ ] CLI instalado
- [ ] Primer push a Cloud exitoso
- [ ] Componente visible en Cloud

### Fase 1
- [ ] 5 use-cases del botón creados
- [ ] Código regenerado con build_runner
- [ ] Push a Cloud
- [ ] Todos los estados visibles en Cloud

### Fase 2
- [ ] Links de Figma obtenidos
- [ ] `designLink` agregado a use-cases
- [ ] Overlay de Figma funciona en Cloud
- [ ] Diseñador probó el overlay

### Fase 3
- [ ] Segundo componente implementado
- [ ] Use-cases creados y organizados
- [ ] Push a Cloud
- [ ] 2 componentes visibles en Cloud

### Fase 4
- [ ] Fixtures creados
- [ ] Use-cases usan fixtures
- [ ] Edge cases documentados
- [ ] Push y verificación

### Fase 5
- [ ] Workflow renombrado y activo
- [ ] Secret configurado en GitHub
- [ ] Push automático funciona
- [ ] Comentario aparece en PR
- [ ] Status check funciona

### Fase 6
- [ ] Todos los componentes catalogados
- [ ] Cada componente tiene use-cases
- [ ] Coverage > 80%
- [ ] Documentación actualizada

### Fase 7
- [ ] Mocktail agregado
- [ ] Mocks creados
- [ ] Use-cases con mocking funcionan
- [ ] Patrones documentados

### Fase 8
- [ ] Coverage ejecutado localmente
- [ ] Coverage en CI configurado
- [ ] Threshold definido
- [ ] Componentes ignorados marcados

### Fase 9
- [ ] Equipo capacitado
- [ ] Proceso definido y documentado
- [ ] Primera revisión de UI completada
- [ ] Métricas establecidas

---

## 🎓 Aprendizajes Esperados por Fase

| Fase | Aprendizaje Clave |
|------|-------------------|
| 0 | Widgetbook básico funciona |
| 1 | Organizar estados de componentes |
| 2 | Valor de integración con Figma |
| 3 | Flujo de agregar componentes |
| 4 | Gestión de datos complejos |
| 5 | Automatización ahorra tiempo |
| 6 | Sistema de diseño completo |
| 7 | Testing de componentes complejos |
| 8 | Métricas de calidad |
| 9 | Colaboración equipo |

---

## 🚨 Puntos de Decisión

En cada fase, evalúa:

### ¿Continuar o Pausar?

**Continúa si:**
- ✅ El equipo ve valor
- ✅ El proceso es fluido
- ✅ Hay tiempo para la siguiente fase
- ✅ La curva de aprendizaje es manejable

**Pausa si:**
- ⚠️ El equipo no ve valor claro
- ⚠️ Hay problemas técnicos sin resolver
- ⚠️ Faltan recursos o tiempo
- ⚠️ La complejidad es abrumadora

**No hay prisa.** Es mejor dominar cada fase antes de continuar.

---

## 📈 Métricas de Éxito

### Por Fase

- **Fase 0-1:** ¿Puedes hacer push a Cloud sin ayuda?
- **Fase 2:** ¿Los diseñadores entienden el overlay de Figma?
- **Fase 3-6:** ¿Cuánto tiempo toma agregar un componente nuevo?
- **Fase 5:** ¿Cuánto tiempo ahorras con automatización?
- **Fase 9:** ¿Cuántas iteraciones de diseño se eliminan?

### Globales

- **Velocidad:** Tiempo de componente nuevo (diseño → producción)
- **Calidad:** % de componentes aprobados en primera iteración
- **Coverage:** % de componentes catalogados en Widgetbook
- **Adopción:** % del equipo que usa Widgetbook regularmente

---

## 💡 Tips para el Éxito

1. **No saltarse fases:** Cada una construye sobre la anterior
2. **Documentar aprendizajes:** ¿Qué funcionó? ¿Qué no?
3. **Celebrar wins:** Cada fase completada es un logro
4. **Pedir feedback:** Involucrar al equipo temprano
5. **Ser flexible:** Adaptar el roadmap según necesidades

---

## 📚 Recursos por Fase

| Fase | Documentación Relevante |
|------|-------------------------|
| 0 | `docs/PRIMER_PUSH_MANUAL.md` |
| 1 | `widgetbook/README.md` |
| 2 | `docs/FIGMA_LINKS_GUIDE.md` |
| 3-6 | `widgetbook/README.md` |
| 4,7 | `docs/mocking_testing.md` |
| 5 | `docs/GITHUB_SETUP.md`, `docs/CICDIntegration.md` |
| 8 | `docs/GUIA_USO_WIDGETBOOK.md` (sección coverage) |
| 9 | `docs/TEAM_WORKFLOW.md` |

---

## 🎯 Estado Actual: FASES 0, 1, 2, 5 ✅

**Completado:**
- ✅ Fase 0: Setup inicial
- ✅ Fase 1: Expandir estados del botón (5 use-cases)
- ✅ Fase 2: Integración con Figma (designLinks agregados)
- ✅ Fase 5: GitHub Actions automático

**Próximas opciones:**
- Fase 3: Agregar segundo componente (ej: InfoCard o UserCard)
- Fase 4: Implementar fixtures para datos reutilizables
- Fase 6: Catalogar componentes restantes

**¡Gran progreso!** 🚀 El workflow automático está funcionando.
