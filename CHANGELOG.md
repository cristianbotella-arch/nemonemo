# Changelog

> Format: each release is `## vX.Y.Z — YYYY-MM-DD` with a one-line summary, `Plugins bumped:`, `Marketplace:`, `Breaking changes:`, and (when applicable) `Upstream pin state`.
>
> Maintainer-only entries (no consumer-facing changes) are noted as `## maintenance — YYYY-MM-DD` and do not bump `metadata.version`.

## v1.8.0 — 2026-05-28

Nuevo plugin propio `nemo-comments`: skill que se activa cuando Claude va a escribir o editar comentarios en código. Default: no comentar. Solo añade comentario si explica un WHY no obvio, y siempre conciso (1-2 líneas).

Añadidos:

- **Nuevo plugin** `plugins/nemo-comments/` con la skill `nemo-comments` (`skills/nemo-comments/SKILL.md`).
- **Regla núcleo**: por defecto NO escribir comentarios. Un comentario solo justifica su existencia si explica algo que el código no puede expresar por sí mismo y que sorprendería al próximo lector.
- **Qué SÍ justifica un comentario**: WHY no obvio, workaround referenciado, invariante sutil que el tipo no captura, gotcha del dominio, TODO/FIXME con ticket o contexto.
- **Qué NO**: resumir lo que el código hace, repetir nombres de identificadores, narrar el contexto de la edición ("added for X flow", "fix for ticket Y"), marcar código eliminado, encabezados decorativos, docstrings inflados sobre funciones triviales.
- **Longitud**: 1 línea por defecto, 2 si referencia ticket/issue, nunca un párrafo.
- **Docstrings**: mismas reglas — un docstring multi-sección sobre una función pequeña con nombre claro y tipos es ruido.
- **Tres preguntas filtro** antes de escribir cualquier comentario.
- **6 ejemplos** en SKILL.md cubriendo: código autoexplicativo (sin comentario), WHY no obvio, workaround referenciado, invariante, anti-ejemplo de docstring inflado, TODO con contexto.
- **Evals iniciales**: 3 casos en `evals/evals.json` (helper trivial, custom hook con bug de Safari, refactor que limpia ruido). Benchmark con baseline: with_skill 12/12 (100%), without_skill 8/12 (67%), Δ +0.30 pass rate.

Plugins bumped:
- nemo-comments: nuevo plugin a 0.1.0

Marketplace: 1.7.0 → 1.8.0 (minor — nuevo plugin propio)

Breaking changes: none

## v1.7.0 — 2026-05-28

`nemo-habla`: nuevo slash command `/castellano-antiguo` (modo escriba castellano de la Baja Edad Media, siglos XIII-XV) mutuamente excluyente con `/llados-mode`. Ambos modos refuerzan activación SÓLO por slash command explícito — prohibida cualquier auto-activación por trigger phrases o inferencia de contexto.

Añadidos:

- **Nuevo comando** `commands/castellano-antiguo.md` con persona de escriba medieval: tratamiento de "vuestra merced" / "vos", reglas ortográficas arcaicas (`v` en imperfecto, `f-` inicial, `ç/z`, `x` por `j`, `nn/ñ`, contracciones, enclisis), léxico medieval (pronombres, adverbios, sustantivos, verbos), conjugaciones `-ades/-edes/-ides` y futuro analítico (`dezir vos he`). Fuente atribuida: CEDEC/INTEF Proyecto EDIA (CC BY-SA 4.0 ES), ampliada con arcaísmos del Cantar de Mio Cid y el Libro de Buen Amor.
- **Exclusión mutua** entre `/llados-mode` y `/castellano-antiguo`: activar uno desactiva el otro.
- **Sección "Activación SÓLO por slash command (INNEGOCIABLE)"** en ambos comandos: prohíbe activación automática por trigger phrases del texto, inferencia de contexto, similitud temática o sugerencia de otra skill / hook / agente. Sólo entran por invocación explícita de `/llados-mode` o `/castellano-antiguo`.
- **Regla de oro** común: el modo es envoltorio de tono — bloques de código, comandos de shell, identificadores, mensajes de error y URLs van EXACTOS y en inglés moderno.
- **Excepción auto-claridad** común: ambos modos rompen el personaje para avisos de seguridad y confirmaciones de acciones irreversibles.

Plugins bumped:
- nemo-habla: 0.2.0 → 0.3.0 (minor — nuevo slash command `/castellano-antiguo` + sección de activación-sólo-por-comando en ambos comandos)

Marketplace: 1.6.0 → 1.7.0 (minor — incorpora feature nueva en plugin propio)

Breaking changes: none

## v1.6.0 — 2026-05-28

`nemo-habla` (`/llados-mode`): ampliación sustancial del vocabulario y patrones del modo Llados en `commands/llados-mode.md`.

Añadidos:

- **Muletilla nueva** `"es como fok"` (deformación de *what the fuck*) en intensificadores, con dosis baja (1 de cada 4-5) para no pisar a `fucking`/`fakin`.
- **Frases literales nuevas:** `"¡PANZA!"` (exclamación seca), `"¿Miro a un lado y qué veo? ¡PANZA!"` (variante corta de la frase madre), `"No estáis en mi lineage."` (descalificativo elitista), `"Estás gordo y tienes la culpa."` (culpa al user al estilo crudo).
- **Spanglish:** `lineage` añadido a la lista.
- **Nueva obsesión temática** `"Lee libros (los que importan)"` con referentes Napoleon Hill (*Think and Grow Rich*) y Robert Kiyosaki (*Rich Dad Poor Dad*).
- **Nueva sección "Trofeos materiales"** con coches (Lamborghini Huracán, Ferrari), relojes (Rolex Daytona, Audemars Piguet, Richard Mille), mansiones en Miami y marcas (Gucci, Louis Vuitton, Prada). Incluye regla de dosificación explícita (máx 1 trofeo por respuesta, ~1 de cada 3-4 respuestas) y excepción para conversaciones serias.
- **Quinto patrón argumental** *Chantaje aspiracional (yo tengo / tú no tendrás)*: contraste explícito entre lo que el personaje tiene y lo que el user nunca alcanzará si sigue su ritmo actual.
- **Ejemplo nuevo** *"¿Vale la pena aprender Rust?"* que ejercita los trofeos + chantaje + sustancia técnica correcta.

La Regla de Oro (tono ≠ sustancia técnica) y la excepción auto-claridad siguen intactas — todo lo nuevo es envoltorio.

Plugins bumped:
- nemo-habla: 0.1.1 → 0.2.0 (minor — enriquecimiento sustancial de contenido en `commands/llados-mode.md`, sin cambios estructurales ni en el hook de idioma)

Marketplace: 1.5.1 → 1.6.0 (minor — incorpora cambios materiales de plugin propio)

Breaking changes: none

## v1.5.1 — 2026-05-28

`nemo-habla` (`/llados-mode`): nueva sub-sección **"Firma recurrente — fucking panza"** en `commands/llados-mode.md`. Es la combinación estrella del personaje (viene directa de su frase madre *"miro a los lados y solo veo fucking panzas..."*) y ahora figura como sello identitario del modo con regla de dosificación explícita: ~1 de cada 3-4 respuestas, en apertura/cierre/medio según encaje, con excepción explícita para conversaciones serias (postmortems, avisos de seguridad). Sin cambios en el hook de idioma ni en metadatos del plugin.

Plugins bumped:
- nemo-habla: 0.1.0 → 0.1.1 (patch — enriquecimiento de contenido en `commands/llados-mode.md`, sin cambios estructurales)

Marketplace: 1.5.0 → 1.5.1 (patch — solo cambio de contenido en plugin propio, sin breaking)

Breaking changes: none

## v1.5.0 — 2026-05-27

Nuevo plugin propio `nemo-habla` (umbrella de "estilo de comunicación"), con dos componentes:

1. **Hook `UserPromptSubmit`** que reinyecta en cada turno una directiva para que Claude responda siempre en español (es-ES). Va por `UserPromptSubmit` (no `SessionStart`) a propósito — se re-emite en cada mensaje del usuario, así sobrevive al resumen de contexto de sesiones largas y le gana al drift al inglés de skills escritas en inglés (p.ej. `caveman`, cuyas instrucciones y ejemplos son 100% en inglés y mandan "active every response"). El código, los comentarios de código y los términos técnicos propios permanecen en inglés. Si hay un modo compacto activo, se respeta pero en español compacto: la compresión afecta a la verbosidad, no al idioma.
2. **Slash command `/llados-mode`** que activa un modo persona: Claude habla como Amadeo Lladós (Llados Fitness) — motivación fitness agresiva, spanglish, "fucking", roast a "plebeyos" y "mileuristas". Self-contained (reglas empotradas en el comando, patrón de `nemo-caveman`). Regla de oro innegociable: solo afecta al TONO, la corrección técnica/código/comandos quedan exactos. Off con "stop llados" / "modo normal". Caricatura de personaje público, con atribución de fuentes en el archivo.

Plugins bumped:
- nemo-habla: NEW → 0.1.0 (plugin propio nuevo — hook `UserPromptSubmit` + comando `/llados-mode`)

Marketplace: 1.4.1 → 1.5.0 (minor — nuevo plugin propio, sin breaking)

Breaking changes: none

## v1.4.1 — 2026-05-27

`nemo-siamese`: invertido el orden de apertura de sesión. El banner del gato ahora se imprime DESPUÉS del saludo + efeméride de otros plugins de apertura (p.ej. `rocazul-on-this-day`), en lugar de reclamar la primera posición. Solo cambia la directiva del hook `SessionStart`; el banner ASCII y el cat fact no cambian.

Plugins bumped:
- nemo-siamese: 0.2.3 → 0.2.4 (patch — reordenación de la apertura, sin cambios en el contenido del banner)

Marketplace: 1.4.0 → 1.4.1 (patch — solo cambio de comportamiento de apertura, sin breaking)

Breaking changes: none

## v1.4.0 — 2026-05-26

Nuevo plugin propio `nemo-caveman`: añade el slash command `/caveman` para activar un modo de respuestas ultra-compactas (drop fluff, keep technical substance). Las instrucciones del modo van empotradas en el comando para que el plugin sea self-contained y portable entre máquinas — sin dependencia del plugin `forge-mattpocock`. Reglas adaptadas de `mattpocock/skills` (MIT), con atribución en el archivo.

Plugins bumped:
- nemo-caveman: NEW → 0.1.0 (plugin propio nuevo)

Marketplace: 1.3.2 → 1.4.0 (minor — nuevo plugin propio, sin breaking)

Breaking changes: none

## v1.3.2 — 2026-05-26

Simplificación del banner de `nemo-siamese`: se eliminan el marco, el rótulo "✦ NEMO ✦" y la pelota. Queda solo el gato ASCII + el cat fact. Descripción del plugin actualizada para reflejarlo.

Plugins bumped:
- nemo-siamese: 0.2.1 → 0.2.2 (patch — simplificación estética del banner, sin cambios funcionales)

Marketplace: 1.3.1 → 1.3.2 (patch — solo cambios cosméticos)

Breaking changes: none

## v1.3.1 — 2026-05-26

Fix de `nemo-siamese`: el banner ASCII no se renderizaba al usuario. El hook emitía stdout plano, que en `SessionStart` solo entra como contexto del modelo y no se pinta en la UI. Ahora emite `hookSpecificOutput.additionalContext` con una directiva explícita para que Claude imprima el banner verbatim al inicio de su primera respuesta (compone bien con otros plugins de apertura como `rocazul-on-this-day`).

Plugins bumped:
- nemo-siamese: 0.2.0 → 0.2.1 (patch — fix de contrato, ahora el banner es visible en la UI)

Marketplace: 1.3.0 → 1.3.1 (patch — solo fixes, sin cambios funcionales)

Breaking changes: none

## v1.3.0 — 2026-05-26

Añadido `forge-proactive-qa` como referencia: agente autónomo de QA con Playwright (3 modos, pensado para `/loop`).

Plugins bumped:
- forge-proactive-qa: NEW → 1.2.1 (referencia a `dmedina-dev/dev-forge@main`)

Marketplace: 1.2.0 → 1.3.0 (minor — nuevo plugin referenciado, sin breaking)

Breaking changes: none

## maintenance — 2026-05-26

Added local maintainer tooling — no changes to the catalog, no version bump.

What landed:
- `.claude/commands/` (4 local slash commands, not distributed to consumers):
  - `/marketplace-health` — wraps `scripts/marketplace-health.sh`
  - `/marketplace-release` — marketplace release flow (was at `/release` in forge-commit upstream; renamed here to avoid collision with the consumer-facing reference plugin)
  - `/update-check` — for vendored plugins with `customizations.json`
  - `/check-references` — NEW; compares reference-mode pins against upstream marketplaces (no equivalent in dev-forge, since they use pure vendoring)
- `.claude/rules/` (auto-loaded project rules):
  - `plugin-authoring.md` — conventions for plugin files
  - `marketplace-consistency.md` — README ↔ marketplace.json checks
- `scripts/marketplace-health.sh` — pre-publish sanity check (schema, paths, version drift), auto-skips reference entries
- `docs/`:
  - `customizations-pattern.md` — vendor + customizations model
  - `versioning.md` — semver policy for plugins and marketplace
  - `update-check-guide.md` — detailed flow for the `/update-check` command
- `.gitignore` updated for `.upstream/`, `.claude/worktrees/`, `.claude/settings.local.json`, etc.

Marketplace: no change (still v1.2.0).

Breaking changes: none.

## v1.2.0 — 2026-05-26

`nemo-siamese` evoluciona: banner con cabecera NEMO, gato + pelota y curiosidad aleatoria sobre gatos al final.

Plugins bumped:
- nemo-siamese: 0.1.0 → 0.2.0 (minor — añade cabecera NEMO, pelota, 15 curiosidades aleatorias, script bash `greet.sh` y `facts.txt`)

Marketplace: 1.1.0 → 1.2.0 (minor — feature bump en plugin propio)

Breaking changes: none

## v1.1.0 — 2026-05-26

Primer plugin propio (vendorizado): `nemo-siamese` añade un saludo ASCII de un gato siamés en cada `SessionStart`.

Plugins bumped:
- nemo-siamese: NEW → 0.1.0 (minor — primer release; hook `SessionStart` que imprime ASCII art)

Marketplace: 1.0.0 → 1.1.0 (minor — nuevo plugin propio, sin breaking)

Breaking changes: none

## v1.0.0 — 2026-05-26

Cambio de modelo: de **vendoring** (copias en `plugins/nemo-*`) a **referencia** (catálogo que apunta a `dmedina-dev/dev-forge`). Se añade `forge-keeper` para tener `/update-check`.

Plugins bumped:
- nemo-commit (0.1.0) → REMOVED, reemplazado por `forge-commit` 1.1.3 (referencia a dev-forge)
- nemo-security (0.1.0) → REMOVED, reemplazado por `forge-security` 1.0.2 (referencia)
- nemo-deepthink (0.1.0) → REMOVED, reemplazado por `forge-deepthink` 0.1.0 (referencia)
- nemo-deep-review (0.1.0) → REMOVED, reemplazado por `forge-deep-review` 2.0.2 (referencia)
- forge-keeper: NEW → 1.4.1 (referencia; aporta `/update-check`, `/sync`, `/status`, `/recall`, etc.)

Marketplace: 0.2.0 → 1.0.0 (major — los plugins se renombran de `nemo-*` a `forge-*` porque en modo referencia el `name` del catálogo debe coincidir con el `plugin.json` del upstream)

Breaking changes: **sí**. Los nombres de plugins cambian.

### Migration

```bash
# Para cada plugin que tuvieras instalado:
/plugin uninstall nemo-commit       && /plugin install forge-commit
/plugin uninstall nemo-security     && /plugin install forge-security
/plugin uninstall nemo-deepthink    && /plugin install forge-deepthink
/plugin uninstall nemo-deep-review  && /plugin install forge-deep-review
# Nuevo (para tener /update-check):
/plugin install forge-keeper
```

Las customizaciones que vivían en los plugins vendorizados desaparecen (rebranding de `/release` a "nemonemo", etc.). El comando `/release` sigue funcionando pero menciona "dev-forge" en sus mensajes.

Upstream pin state post-release:
- Todo apunta a `dmedina-dev/dev-forge` main (versiones según `marketplace.json`)

## v0.2.0 — 2026-05-26

Añadidos 3 plugins curados desde `dmedina-dev/dev-forge`: hook de seguridad, skill de deep-thinking, agentes de code review.

Plugins bumped:
- nemo-security: NEW → 0.1.0 (minor — primer release; hook PreToolUse en Edit/Write/MultiEdit)
- nemo-deepthink: NEW → 0.1.0 (minor — `/deepthink` slash command + skill `deep-think`)
- nemo-deep-review: NEW → 0.1.0 (minor — 5 agents + `/deep-review` y `/pr-review`)

Marketplace: 0.1.0 → 0.2.0 (minor — 3 plugins añadidos, sin breaking)

Breaking changes: none

Upstream pin state post-release:
- nemo-security ← `dmedina-dev/dev-forge` main @ forge-security v1.0.2 ← `anthropics/claude-code` main @ `plugins/security-guidance`
- nemo-deepthink ← `dmedina-dev/dev-forge` main @ forge-deepthink v0.1.0
- nemo-deep-review ← `dmedina-dev/dev-forge` main @ forge-deep-review v2.0.2 ← `anthropics/claude-code` main @ `plugins/pr-review-toolkit` + `plugins/code-review`

## v0.1.0 — 2026-05-26

Bootstrap del marketplace con el primer plugin.

Plugins bumped:
- nemo-commit: NEW → 0.1.0 (minor — primer release; 4 comandos de git)

Marketplace: NEW → 0.1.0

Breaking changes: none

Upstream pin state post-release:
- nemo-commit ← `dmedina-dev/dev-forge` main @ forge-commit v1.1.3 ← `anthropics/claude-code` main @ `plugins/commit-commands`
