# Changelog

> Format: each release is `## vX.Y.Z — YYYY-MM-DD` with a one-line summary, `Plugins bumped:`, `Marketplace:`, `Breaking changes:`, and (when applicable) `Upstream pin state`.
>
> Maintainer-only entries (no consumer-facing changes) are noted as `## maintenance — YYYY-MM-DD` and do not bump `metadata.version`.

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
