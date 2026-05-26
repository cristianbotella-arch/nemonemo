# Changelog

> Format: each release is `## vX.Y.Z — YYYY-MM-DD` with a one-line summary, `Plugins bumped:`, `Marketplace:`, `Breaking changes:`, and (when applicable) `Upstream pin state`.

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
