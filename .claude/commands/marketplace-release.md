---
allowed-tools: Bash(git:*), Bash(python3:*), Bash(bash:*), Read, Edit, Grep, Glob
description: "Release changed plugins in nemonemo: detect modified vendored plugins since last tag, bump versions, update marketplace.json, update CHANGELOG, commit, tag, push."
---

## Guard — marketplace repos only

This command is only for the nemonemo marketplace repo. Check for `.claude-plugin/marketplace.json` at the repo root. If it doesn't exist, stop:

> This command is for marketplace repos only. It requires `.claude-plugin/marketplace.json` at the repo root.
> For regular projects, use standard git tag/release workflows.

Do NOT proceed unless the file exists.

## Context

- Latest git tag: !`git describe --tags --abbrev=0 2>/dev/null || echo "none"`
- Current marketplace version: !`python3 -c "import json; print(json.load(open('.claude-plugin/marketplace.json'))['metadata']['version'])"`
- Changed plugin directories since last tag (vendored only): !`TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo ""); if [ -n "$TAG" ]; then git diff --name-only "$TAG"..HEAD -- plugins/ | cut -d/ -f1-2 | sort -u; else echo "No tags — all vendored plugins are new"; git diff --name-only HEAD~10..HEAD -- plugins/ | cut -d/ -f1-2 | sort -u; fi`
- Current vendored plugin versions: !`python3 -c "import json, glob, os; rows = sorted(glob.glob('plugins/*/.claude-plugin/plugin.json')); print('\n'.join('{}: {}'.format(os.path.dirname(os.path.dirname(f)), json.load(open(f))['version']) for f in rows) or '(no vendored plugins found)')"`
- Recent commits since last tag: !`TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo ""); if [ -n "$TAG" ]; then git log --oneline "$TAG"..HEAD; else git log --oneline -15; fi`

## Your task

Create a release for nemonemo. Follow these steps:

### 1. Identify changed plugins

From the context above, determine which `plugins/*/` directories have changes since the last git tag. Only vendored plugins (with a local directory) can be bumped — reference entries are bumped manually when upstream releases (see `/check-references`).

If the user also wants to bump a reference plugin's `version` in `marketplace.json`, ask them which one(s) and to what version, then include that in the bump set.

### 2. Determine bump type

Analyze the commits since the last tag for each changed plugin (see `docs/versioning.md` for the policy):
- `feat:` or new files → **minor** bump (1.0.0 → 1.1.0)
- `fix:` only → **patch** bump (1.0.0 → 1.0.1)
- Breaking changes or major rewrites → **major** bump (1.0.0 → 2.0.0)

### 3. Bump plugin versions

For each changed plugin, update the version in:
- `plugins/<name>/.claude-plugin/plugin.json` — the `version` field
- `.claude-plugin/marketplace.json` — the matching plugin entry's `version` field

Both MUST match. Use the Edit tool for precision.

For reference plugins being re-pinned, only `.claude-plugin/marketplace.json` changes (there is no local `plugin.json`).

### 4. Bump marketplace version

Increment the marketplace `metadata.version` in `.claude-plugin/marketplace.json`:
- If any plugin had a major bump → major
- If any plugin had a minor bump → minor
- If only patches → patch

### 4b. Update CHANGELOG.md

Prepend a new `## v{X.Y.Z} — YYYY-MM-DD` entry at the top of `CHANGELOG.md` (right after the `> Format:` line). This is **not optional** — every release commit MUST land a CHANGELOG entry.

Each entry contains:
1. **One-line summary** (what changed at the user level).
2. **`Plugins bumped:`** list in `name: old → new (level — one-line reason)` format.
3. **`Marketplace:`** `old → new (level — why)`.
4. **`Breaking changes:`** — `none` if applicable, otherwise a `### Migration` block with explicit `/plugin uninstall`, `/plugin install`, and command-rename steps.
5. **For reference re-pins**: note that the `version` field bump in `marketplace.json` was a re-pin of upstream version Y to version Z.

Match the voice and structure of existing entries — terse summary, lists not paragraphs where possible.

### 5. Validate

Run the marketplace health script (catches schema errors, path drift, version mismatches):

```bash
bash scripts/marketplace-health.sh
```

If it fails, stop and fix the offending entry before continuing.

### 6. Commit and tag

The `git add` MUST include `CHANGELOG.md` alongside the version-bump files — otherwise the release commit lands without the changelog entry and the documentation drifts.

```bash
git add .claude-plugin/marketplace.json plugins/*/.claude-plugin/plugin.json CHANGELOG.md
git commit -m "release: nemonemo v{new_marketplace_version}

Plugins updated:
- {plugin1} {old} → {new}
- {plugin2} {old} → {new}

Co-Authored-By: Claude <noreply@anthropic.com>"

git tag -a "v{new_marketplace_version}" -m "Release v{new_marketplace_version}"
```

### 7. Push

```bash
git push && git push --tags
```

### 8. Summary

Print a release summary:

```
🚀 Released nemonemo v{version}

   Plugins bumped:
   - nemo-x: 0.1.0 → 0.2.0 (minor)
   - forge-y: 1.4.1 → 1.5.0 (re-pin)

   Tag: v{version}
   Pushed: origin/main

   Consumers: run /reload-plugins or start new session
```

Do all of the above in a single message. Do not use any other tools or do anything else besides these tool calls.
