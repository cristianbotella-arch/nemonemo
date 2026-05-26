---
description: Check vendored plugins for upstream updates, show changes and conflicts with local customizations, and optionally apply updates.
---

## Guard — marketplace repos only

This command is only for the nemonemo marketplace repo. Check for `.claude-plugin/marketplace.json` at the repo root. If it doesn't exist, stop with: "This command is for marketplace repos only."

## Scope

This command operates on **vendored plugins with `customizations.json`** (origin.type = github). For **reference-mode** entries in `marketplace.json`, use `/check-references` instead.

## Your task

Follow the 4 steps below. The detailed flow lives in `docs/update-check-guide.md` — read it whenever you need API specifics, conflict-analysis rules, or the apply-update procedure.

### Step 1 — Scan plugins

Scan all `plugins/*/.claude-plugin/customizations.json`. Classify each plugin:
- **External**: has `origin.type = "github"` (or `origins` array with github entries) → eligible for update check.
- **Native**: `origin.type = "native"` or no `customizations.json` → skip.

If no plugins are eligible, report:
> No vendored plugins with customizations.json found. Try `/check-references` for reference-mode plugins.

See `docs/update-check-guide.md` § Plugin scanning.

### Step 2 — Check upstreams

For each eligible plugin, check upstream for new versions using `gh api` (primary) or `git ls-remote` (fallback). Present a quick summary table:

```
Plugin               Upstream                   Current   Latest   Status
─────────────────── ────────────────────────── ───────── ──────── ──────
some-vendored        owner/repo                 v1.0.0    v1.1.0   ⚡
nemo-siamese         —                          —         —        ⊘ (native)
```

See `docs/update-check-guide.md` § Upstream check and § Quick summary format.

### Step 3 — Detail on request

Ask: "Want details on any plugin? Enter name(s), 'all', or Enter to skip."

For each requested plugin, show releases/commits since current version and conflict analysis against `customizations[]` entries.

See `docs/update-check-guide.md` § Detailed view per plugin.

### Step 4 — Apply on request

Ask: "Apply updates? Enter plugin name(s), or Enter to skip."

For each plugin to update, offer three choices:
- **apply** — sync upstream clone in `.upstream/`, copy changes, preserve local customizations
- **reset** — copy fresh from `.upstream/`, clear customizations
- **skip** — leave as-is

Uses persistent full clones in `.upstream/` (gitignored). First apply clones, subsequent applies fetch. One clone per upstream repo, shared across plugins from the same repo.

Execute the chosen action and show a post-update summary.

See `docs/update-check-guide.md` § Apply update flow.
