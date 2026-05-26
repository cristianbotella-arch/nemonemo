---
description: Conventions for authoring and modifying plugin files in nemonemo
globs: plugins/**
---

- `SKILL.md` must have YAML frontmatter with `name` and `description` fields.
- Skill `description` must include trigger phrases — words/patterns that cause Claude to activate the skill.
- Command `.md` files must have YAML frontmatter with `description` field.
- Reference files are plain markdown without frontmatter.
- All changes to plugin content must be tested with `claude --plugin-dir plugins/<name>` (load the plugin in isolation and exercise it).
- Hook scripts must use `${CLAUDE_PLUGIN_ROOT}` for paths, never relative paths.
- Hook scripts must guarantee exit 0 — use `trap 'exit 0' ERR` or equivalent to avoid blocking the session.
- JSON files must validate with `python3 -m json.tool`.
- Before pushing changes to `.claude-plugin/marketplace.json` or any plugin's `plugin.json`, run `bash scripts/marketplace-health.sh` — `python3 -m json.tool` only validates JSON syntax, not Claude Code's marketplace schema. The health script catches reserved-field shape errors, version drift between `plugin.json` and `marketplace.json`, missing plugin paths, and broken dependency references.
- When modifying `marketplace.json`, keep source URLs as `https://` (never `git@ssh`).
- The `name` field in `marketplace.json` entries MUST match the `name` field in the corresponding `plugin.json`. For reference-mode entries, this means using the upstream's plugin name (you cannot rebrand without vendoring).
- For plugins vendored from upstream sources, note origin at top of `SKILL.md` (or equivalent component file). Use a single-line HTML comment immediately after the YAML frontmatter, invisible in rendered markdown but searchable in source: `<!-- Curated from <repo>/<path> · <license>. <Unmodified | Adapted: <one-line summary>>. -->`
- When updating from upstream, diff against local customizations before overwriting. Use `/update-check` to do this cleanly.
- Slash-command `` `!`backtick`` `` context loaders MUST NOT rely on shell-glob expansion. The harness pipes these through `eval` in the user's shell (zsh by default on macOS), where glob expansion can fail with `(eval):1: no matches found:` even when files exist. Use `python3 -c "import glob, json; ..."` for any path enumeration in those loaders.
- Plugins that write state outside the current project root (typically `~/.claude/channels/<plugin>/`) must document every writable file in the plugin's `references/operational.md` § sandbox section so consumers can add them to `sandbox.filesystem.allowWrite`.
