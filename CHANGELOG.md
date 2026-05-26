# Changelog

> Format: each release is `## vX.Y.Z — YYYY-MM-DD` with a one-line summary, `Plugins bumped:`, `Marketplace:`, `Breaking changes:`, and (when applicable) `Upstream pin state`.

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
