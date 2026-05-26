---
description: Validate that user-facing docs stay in sync with marketplace.json
globs: README.md, CHANGELOG.md, .claude-plugin/marketplace.json
---

# Marketplace doc consistency

When `marketplace.json` changes, treat it as the canonical source of truth for the plugin catalog and validate that all user-facing docs match.

## Validations to run

1. **Plugin count parity**: number of plugin rows in the README plugin tables (`### Propios (vendorizados)` + `### Referenciados ...`) ==
   `python3 -c "import json; print(len(json.load(open('.claude-plugin/marketplace.json'))['plugins']))"`

2. **No stale references**: grep for plugin names in `README.md`, `CHANGELOG.md`, `plugins/*/commands/*.md`, `plugins/*/skills/**/*.md` that no longer appear in `marketplace.json` — flag them as deletion or rename candidates. Exclude historical-only files (closed CHANGELOG entries, `.upstream/`).

3. **`/plugin install` lines**: every `/plugin install <name>` line in the README's Quick Start must reference a plugin that exists in `marketplace.json`.

4. **CHANGELOG newest entry mentions all bumped plugins**: when `marketplace.json` `metadata.version` changes, the matching `## v{X.Y.Z}` entry in `CHANGELOG.md` must list every plugin that changed version.

5. **Owned vs referenced classification**: the README distinguishes between "Propios" (vendorizados) and "Referenciados". Cross-check:
   - Each plugin in `marketplace.json` whose `source.url` contains `cristianbotella-arch/nemonemo` should appear under "Propios".
   - Each plugin whose `source.url` points elsewhere should appear under "Referenciados" with the upstream noted in the Atribución table.

## When mismatches are found

Propose specific edits per mismatch:
- "README has N plugin rows, marketplace has M" → diff the lists, propose exact rows to add or remove.
- "Plugin X appears in README install list but not in marketplace.json" → propose removal from README.
- "Plugin X is in marketplace.json under Propios but its source.url points to dev-forge" → propose moving to Referenciados table.

Apply only after explicit user approval (no autonomous edits).

## When sync is clean

Report: `Marketplace docs consistent with marketplace.json (N plugins: P owned, R referenced).`
