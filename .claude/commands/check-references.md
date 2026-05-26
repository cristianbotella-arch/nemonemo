---
allowed-tools: Bash(curl:*), Bash(gh:*), Bash(python3:*), Bash(jq:*), Read
description: Check reference-mode entries in marketplace.json against their upstream marketplace, report version drift.
---

## Guard — marketplace repos only

This command is only for the nemonemo marketplace repo. Check for `.claude-plugin/marketplace.json` at the repo root. If it doesn't exist, stop with: "This command is for marketplace repos only."

## Scope

This command operates on **reference-mode** entries in `marketplace.json` — entries whose `source.url` points to a third-party repo (no local files in this repo). For **vendored** plugins, use `/update-check` instead.

## Your task

For each reference entry, compare the version we have pinned against the version the upstream marketplace currently advertises.

### Step 1 — Classify entries

Load `.claude-plugin/marketplace.json` and split entries into two groups:

- **Vendored**: `source.path` resolves to an existing local directory containing `.claude-plugin/plugin.json` (skip — use `/update-check` for these).
- **Reference**: everything else (these are the entries we'll check).

Use this Python snippet (or equivalent inline) for the classification:

```bash
python3 <<'EOF'
import json, os
m = json.load(open('.claude-plugin/marketplace.json'))
refs = []
for p in m['plugins']:
    src = p.get('source', {})
    path = src.get('path', '')
    local = os.path.isfile(os.path.join(path, '.claude-plugin', 'plugin.json'))
    if not local:
        refs.append({
            'name': p['name'],
            'pinned_version': p['version'],
            'url': src.get('url', ''),
            'path': path,
        })
import json as _j; print(_j.dumps(refs, indent=2))
EOF
```

### Step 2 — Fetch each upstream marketplace.json

For each reference, parse the GitHub repo from `source.url` (format `https://github.com/<owner>/<repo>.git`) and fetch its `marketplace.json` from `main` (or the ref you've pinned — but if no ref is recorded, assume `main`).

Preferred: `gh api` (works with auth, no rate-limit issues):
```bash
gh api repos/<owner>/<repo>/contents/.claude-plugin/marketplace.json \
  --jq '.content' | base64 -d
```

Fallback: raw URL:
```bash
curl -sSL https://raw.githubusercontent.com/<owner>/<repo>/main/.claude-plugin/marketplace.json
```

Cache the parsed JSON in memory keyed by repo URL — multiple references can point to the same upstream repo (the typical dev-forge case), and we only need to fetch each marketplace once.

### Step 3 — Compare versions

For each reference entry, find the matching plugin in the upstream marketplace by `name` field. Compare `pinned_version` (our entry) against the upstream entry's `version`.

If the plugin name is not found in the upstream marketplace, flag it — the upstream may have renamed or removed the plugin.

### Step 4 — Report

Produce a table:

```
Reference Update Status — YYYY-MM-DD
═══════════════════════════════════════════════════════════════════════
Plugin            Upstream                            Pinned   Latest   Status
──────────────── ──────────────────────────────────── ──────── ──────── ──────
forge-commit      dmedina-dev/dev-forge                1.1.3    1.1.3    ✓
forge-keeper      dmedina-dev/dev-forge                1.4.1    1.5.0    ⚡
forge-deep-review dmedina-dev/dev-forge                2.0.2    2.0.2    ✓
═══════════════════════════════════════════════════════════════════════
⚡ 1 plugin has updates   ✓ 2 up to date
```

**Status icons:**
- `⚡` — upstream version is newer than your pin
- `✓` — pin matches upstream
- `⚠` — plugin not found in upstream marketplace (rename or removal candidate)
- `⊘` — could not fetch upstream marketplace (network / auth error — surface the error)

### Step 5 — Apply on request

Ask: "Bump pins? Enter plugin name(s), 'all', or Enter to skip."

For each plugin the user selects:
1. Edit `.claude-plugin/marketplace.json` and change the entry's `version` field to the latest upstream version.
2. (If applicable) note this in `docs/sessions/` or remind the user to do so when they next run `/marketplace-release`.

After editing, run:
```bash
bash scripts/marketplace-health.sh
```
to make sure the catalog is still consistent. Stop if it fails.

Remind the user that to actually ship the bumps to consumers, they still need to run `/marketplace-release` (which will commit, tag, and push).

## Notes

- This command does NOT push or commit anything by itself — that's `/marketplace-release`'s job.
- If `source.url` is not a github.com URL, skip the entry and report it as unsupported.
- If the upstream marketplace is private and `gh api` is not authenticated, surface a clear error rather than failing silently.
