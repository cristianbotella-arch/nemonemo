---
name: nemo-comments
description: Mantén los comentarios de código mínimos y concisos. Úsala SIEMPRE que vayas a escribir, editar o valorar un comentario en código — comentarios inline, docstrings, JSDoc/TSDoc, Python docstrings, comentarios de bloque y TODOs. También cuando estés escribiendo código y dudes si añadir un comentario o no. Activa esta skill aunque el usuario no mencione "comentarios": cualquier edición o creación de código en cualquier lenguaje cuenta. El default es NO comentar; un comentario solo justifica su existencia si explica un WHY no obvio, y nunca debe ser largo.
---

# nemo-comments

Por defecto, **no escribas comentarios**. El código bien escrito se explica solo: nombres claros, funciones pequeñas, control de flujo directo. Un comentario es deuda: envejece, miente, y obliga al lector a leer dos veces lo mismo.

Esta skill se activa porque vas a tocar código. Antes de escribir cualquier comentario nuevo — o de conservar uno que ya existía cuando reescribes un bloque — pasa el filtro de esta página.

## La regla

**Escribe un comentario solo si — y solo si — explica algo que el código no puede expresar por sí mismo, y que sorprendería al próximo lector.**

Si quitando el comentario un lector competente seguiría entendiendo el código sin perder información relevante, **no lo escribas**.

## Qué SÍ justifica un comentario

- **Un WHY no obvio**: una restricción externa, una decisión deliberada que parecería un error sin contexto.
- **Un workaround concreto**: un bug de un sistema externo, una particularidad del runtime. Referencia el origen (issue, ticket, navegador, versión).
- **Un invariante sutil que el tipo no captura**: "this list MUST stay sorted — downstream binary-searches it", "callers must hold the lock before entering".
- **Una gotcha del dominio**: una regla de negocio sin la cual el código parece arbitrario ("rounding to 2 decimals because invoices are stored in cents").
- **TODO / FIXME con ticket o contexto claro**: nunca un TODO huérfano.

## Qué NO justifica un comentario

- Resumir lo que el código hace ("iterate over users", "increment counter"). El código ya lo dice.
- Repetir lo que el nombre del identificador ya transmite (`// the user's email` sobre `userEmail`).
- Documentar parámetros uno a uno cuando los tipos ya los describen.
- Narrar el contexto de la edición ("added for the X flow", "fix for ticket NEMO-123", "used by Y"). Eso pertenece al commit message o al PR, no al código — envejece mal y rota silenciosamente.
- Marcar código eliminado (`// removed login check`). Si está fuera, está fuera; el VCS guarda historia.
- Encabezados decorativos (`// ============ HELPERS ============`).
- Explicar lo evidente (`// returns true if x > 0` sobre `return x > 0`).

## Longitud

- **Una línea siempre que sea posible.** Casi todos los comentarios útiles caben en una línea.
- Dos líneas si necesitas referenciar un issue/ticket además del WHY.
- Más de dos líneas: sospecha. Si de verdad hace falta más, casi siempre la solución es mejor nombre, extraer función o un test que documente el comportamiento, **no** más prosa.
- Nunca pongas un párrafo. Nunca pongas un docstring multi-sección en una función trivial. El docstring de una función de 3 líneas que recibe un `int` y devuelve un `bool` es ruido.

## Docstrings (JSDoc / TSDoc / Python / etc.)

Aplican exactamente las mismas reglas. Un docstring no es gratis solo porque la convención del lenguaje lo permita.

- API pública con comportamiento no obvio: una línea describiendo el contrato (qué garantiza, qué supone), y solo entonces detalles si hay efectos secundarios, errores específicos, o restricciones de uso.
- Función pequeña con nombre claro y tipos: **sin docstring**.
- No repitas los tipos en prosa si el lenguaje ya los expresa.

## Antes de escribir el comentario, hazte estas tres preguntas

1. Si borro este comentario, ¿alguien razonable se confundiría leyendo el código? Si no → bórralo.
2. ¿Estoy explicando WHAT o WHY? Si es WHAT → casi siempre el código debe cambiar, no añadirse comentario.
3. ¿Esto seguirá siendo cierto dentro de seis meses? Si depende del estado actual del repo (callers, tickets en vuelo, refactor en curso), va al PR, no al código.

## Cuando estás editando código existente

- Si reescribes un bloque, **revalúa** los comentarios que ya estaban: borra los que ya no aporten, no los arrastres por inercia.
- Si encuentras un comentario que ahora es mentira (el código cambió y el comentario no), corrígelo o bórralo — no lo dejes podrido.
- No añadas comentarios para "explicar el cambio" que acabas de hacer. Eso va en el commit.

## Ejemplos

**Ejemplo 1 — código autoexplicativo, sin comentario:**

```ts
function isAdult(user: User): boolean {
  return user.age >= 18;
}
```

No: `// returns true if the user is an adult`.

**Ejemplo 2 — WHY no obvio, una línea:**

```ts
// Safari fires `resize` twice on rotation — debounce or we double-render.
window.addEventListener('resize', debounce(handleResize, 50));
```

**Ejemplo 3 — workaround referenciado:**

```python
# Workaround for upstream bug python/cpython#98765 — remove once 3.13 lands.
tz = ZoneInfo("UTC") if sys.version_info < (3, 13) else datetime.UTC
```

**Ejemplo 4 — invariante que el tipo no captura:**

```ts
// Must stay sorted: `findByPrefix` binary-searches this.
const SUPPORTED_LOCALES: readonly string[] = [...].sort();
```

**Ejemplo 5 — qué NO hacer:**

```ts
// This function takes a list of items and calculates the total price
// by iterating over each item and summing its price field. It then
// returns the total as a number. Used in the checkout flow to display
// the grand total to the user before they confirm the order.
function totalPrice(items: Item[]): number {
  return items.reduce((sum, it) => sum + it.price, 0);
}
```

El nombre `totalPrice` y los tipos ya lo dicen todo. El docstring es puro ruido y, además, miente apenas alguien añada IVA o descuentos. Versión correcta: **sin comentario**.

**Ejemplo 6 — TODO con contexto:**

```ts
// TODO(NEMO-412): switch to streaming once the backend exposes /events.
return await fetchAll();
```

No: `// TODO: improve this`.

## Idioma de los comentarios

Escribe los comentarios en el mismo idioma que el resto del código del archivo. Si el repo está en inglés, comentarios en inglés. No mezcles idiomas dentro de un mismo archivo.
