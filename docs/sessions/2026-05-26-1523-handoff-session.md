# Handoff — Añadir `nemo-caveman` como plugin propio del marketplace

**When:** 2026-05-26 15:23
**Branch:** main
**Last commit:** 53af5a4 feat(nemo-caveman): add /caveman slash command plugin
**Next session focus:** open

## Goal of this session

Crear un plugin propio nuevo (`nemo-caveman`) que registre el slash command `/caveman` activando un modo de respuestas ultra-compactas. Objetivo de portabilidad: que el plugin sea instalable desde el marketplace `nemonemo` en cualquier máquina del usuario, **sin dependencia runtime** del plugin upstream `forge-mattpocock`.

## Current state

- Done:
  - Plugin scaffold: `plugins/nemo-caveman/.claude-plugin/plugin.json` + `plugins/nemo-caveman/commands/caveman.md`.
  - Instrucciones de caveman empotradas en el comando (adaptadas de `mattpocock/skills` MIT, atribución HTML-comment inline tras frontmatter — ver regla `plugin-authoring.md`).
  - `marketplace.json`: nueva entrada `nemo-caveman` v0.1.0; `metadata.version` 1.3.2 → 1.4.0.
  - `README.md`: añadido al quick-start, tabla "Propios", árbol de estructura.
  - `CHANGELOG.md`: entrada `v1.4.0 — 2026-05-26`.
  - `bash scripts/marketplace-health.sh` → all checks passed.
  - Commit 53af5a4 + push a origin/main.
  - Usuario ya hizo `/plugin install nemo-caveman@nemonemo` + `/reload-plugins` → plugin cargado (12 plugins, 12 skills).
  - `~/.claude/commands/caveman.md` (local override previo) borrado por el usuario para evitar colisión.
- In progress: ninguna.
- Blocked: ninguno.

## Open threads

- ¿Replicar el patrón con otros plugins propios? El usuario mencionó curiosidad sobre defaults globales (CLAUDE.md vs hook vs comando) — discusión cerrada en este turno pero podría retomarse.
- No se decidió si el `/caveman` debe poder activarse vía hook al iniciar sesión (default ON). El usuario lo dejó solo como curiosidad.

## Next steps

1. Si el usuario quiere caveman por defecto: opciones discutidas → CLAUDE.md global, hook `SessionStart`, o comando manual. La más robusta = hook.
2. Validar en una segunda máquina que `/plugin marketplace add cristianbotella-arch/nemonemo` + `/plugin install nemo-caveman@nemonemo` funciona end-to-end (portabilidad real).
3. Considerar consolidar la atribución a `mattpocock/skills` en una sección del README o en `docs/atribuciones.md` si se vendoriza más material de esa fuente.

## Skills to invoke next

- `/forge-keeper:sync` — si se quiere actualizar CLAUDE.md / rules / docs con lo aprendido de la sesión (por ejemplo, el patrón "wrap a third-party MIT skill como comando standalone").
- `/forge-keeper:update-check` — para revisar si `forge-mattpocock` ha publicado cambios al skill `caveman` upstream que convendría reflejar en la copia empotrada.
- `update-config` — si finalmente se quiere caveman por defecto vía hook en `~/.claude/settings.json`.

## References

- Plugin: `plugins/nemo-caveman/.claude-plugin/plugin.json`, `plugins/nemo-caveman/commands/caveman.md`
- Marketplace: `.claude-plugin/marketplace.json` (entry `nemo-caveman` v0.1.0)
- Docs: `README.md` (quick start + tabla Propios + árbol), `CHANGELOG.md` (v1.4.0)
- Health check: `scripts/marketplace-health.sh`
- Reglas relevantes: `.claude/rules/plugin-authoring.md`, `.claude/rules/marketplace-consistency.md`
- Commit: `53af5a4`
- Upstream original: `mattpocock/skills` · `skills/productivity/caveman/SKILL.md` (MIT)
