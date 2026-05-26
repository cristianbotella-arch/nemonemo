# External Plugin Customizations Pattern

`nemonemo` curates plugins under two models:

- **Reference** — `marketplace.json` `source.url` points to the upstream repo directly. Files live in upstream. No customization possible. Updates land by bumping the `version` field in our `marketplace.json`.
- **Vendor + customizations** — the plugin is copied into `plugins/<name>/`. We can selectively include/exclude files and modify them. A `customizations.json` documents what changed; `/update-check` uses it to compare against upstream and propose safe merges.

This document covers the vendoring side. For the reference side, see `/check-references` (`.claude/commands/check-references.md`).

## When to vendor (vs reference)

| Situation | Model |
|---|---|
| You want all of upstream's plugin, as-is | Reference |
| You want only some components (e.g., 3 of 5 skills) | Vendor + customizations |
| You want to disable one of the hooks | Vendor + customizations |
| You want to rebrand or modify behaviour | Vendor + customizations |
| Plugin is yours from scratch | Plain vendor (no customizations.json needed) |

## customizations.json schema

Each vendored plugin curated from upstream gets a `customizations.json` in its `.claude-plugin/` directory:

```json
{
  "origin": {
    "type": "github",
    "repo": "owner/repo-name",
    "path": "plugins/plugin-name",
    "ref": "v1.0.0",
    "commit": "abc1234def5678",
    "fetched_at": "2026-05-26",
    "check_url": "https://github.com/owner/repo-name/releases"
  },
  "upstream_status": {
    "last_checked": "2026-05-26",
    "latest_ref": "v1.0.0",
    "latest_commit": "abc1234def5678",
    "has_updates": false,
    "summary": "",
    "changes": []
  },
  "customizations": [
    {
      "id": "custom-01",
      "type": "excluded",
      "target": "skills/some-skill/",
      "summary": "Excluded skill — overlaps with another plugin we curate",
      "reason": "Avoid double activation."
    },
    {
      "id": "custom-02",
      "type": "modified",
      "target": "hooks/hooks.json",
      "summary": "Disabled the PostToolUse hook on Bash",
      "reason": "Noisy in our day-to-day, kept only the Edit/Write matcher."
    }
  ]
}
```

### Field reference

#### `origin`

| Field | Description |
|-------|-------------|
| `type` | Source type: `github` (or `native` for plugins we wrote) |
| `repo` | Repository in `owner/name` format |
| `path` | Path within the repo (empty string if root) |
| `ref` | Git ref (tag, branch) at fetch time |
| `commit` | Exact commit SHA for reproducibility |
| `fetched_at` | Date when the plugin was fetched |
| `check_url` | URL to check for new releases |

For plugins with multiple upstreams, use `origins` (array) instead of `origin`:

```json
"origins": [
  { "type": "github", "repo": "owner/a", "path": "plugins/x", ... },
  { "type": "github", "repo": "owner/b", "path": "plugins/y", ... }
]
```

#### `upstream_status`

| Field | Description |
|-------|-------------|
| `last_checked` | Date of last update check |
| `latest_ref` | Most recent upstream ref found |
| `latest_commit` | Most recent upstream commit found |
| `has_updates` | Boolean — newer versions exist? |
| `summary` | One-line summary of available updates |
| `changes[]` | Upstream changes since our version (see below) |

Each entry in `changes[]`:

```json
{
  "ref": "v2.0.0",
  "date": "2026-04-15",
  "summary": "Added multi-model support and fixed hook timeouts",
  "files_changed": ["hooks/hooks.json", "skills/agents/SKILL.md"],
  "conflicts_with_customizations": ["hooks/hooks.json"]
}
```

#### `customizations[]`

| Field | Description |
|-------|-------------|
| `id` | Unique identifier (`custom-NN`) |
| `type` | `excluded` \| `removed` \| `modified` \| `added` |
| `target` | File or directory affected (relative to plugin root) |
| `summary` | What was changed |
| `reason` | Why — intent behind the customization |

### Customization types

- **`excluded`** — upstream content not included (the file/dir isn't in our copy)
- **`removed`** — a piece of content stripped from a file we did include
- **`modified`** — content adapted/edited
- **`added`** — new content not in upstream

### Document exclusions explicitly

When you curate a subset of a multi-component upstream, list **every excluded component** as its own entry with a concrete reason. This makes second-pass review tractable: "why didn't we take X?" gets a written answer instead of a re-debate.

## Native plugins

Plugins we wrote from scratch (e.g. `nemo-siamese`) do NOT need `customizations.json`. Their `origin.type` is implicitly `native`. The convention is to either omit the file or use:

```json
{
  "origin": { "type": "native", "note": "Built in-house for nemonemo." }
}
```

`/update-check` skips both cases automatically.

## Update flow

1. `/update-check` scans `plugins/*/.claude-plugin/customizations.json`
2. For each external entry, fetches upstream via `gh api` or `git ls-remote`
3. Reports current vs latest with conflict markers against your `customizations[]`
4. Offers: `apply` (merge upstream, keep customizations), `reset` (fresh copy, drop customizations), or `skip`
5. Upstream clones are cached in `.upstream/` (gitignored)

See `update-check-guide.md` for the full flow.

## Update flow for reference plugins

`/update-check` does NOT cover reference-mode entries. For those:

1. `/check-references` fetches upstream marketplace.json and diffs versions
2. You decide which references to bump in your `marketplace.json`
3. Commit + push; consumers pick up changes via `/plugin update` or new session
