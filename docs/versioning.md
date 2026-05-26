# Versioning policy

This document defines when and how to bump versions in `nemonemo` — for individual plugins (`plugins/<name>/.claude-plugin/plugin.json`) and for the marketplace as a whole (`.claude-plugin/marketplace.json` `metadata.version`).

The goal is **consumer cache predictability**: a version bump invalidates the consumer's plugin cache, so bumps should happen when behavior actually changes — not when a typo got fixed in a comment.

## Plugin version (semver)

Each plugin uses semver: `MAJOR.MINOR.PATCH`.

### MAJOR (breaking)
Bump when consumers will need to take action to keep things working:
- A command, skill, agent, or hook is **renamed** or **removed**.
- A skill's trigger phrases change in a way that breaks existing prompts.
- A hook's behavior changes such that previous configurations stop working.
- A plugin gains a hard dependency it didn't previously have.

After a major bump, the matching CHANGELOG entry MUST list the migration steps.

### MINOR (additive)
Bump when something **new** ships and existing usage still works:
- New command / skill / agent / hook / subcommand.
- New configuration option (with a default that preserves old behavior).
- Significantly expanded scope of an existing skill.

### PATCH (fixes)
Bump only for bugs or surface refinements observable to the user:
- Bug fix in a hook script, agent prompt, or command.
- Trigger phrase tweak that fixes false negatives.
- Description text in `plugin.json` that materially changes how the plugin advertises itself.

### When NOT to bump
Don't bump for:
- Pure doc edits (`.md` typos, formatting, internal comments) — see carve-out below.
- Test-only changes.
- Refactors that produce identical observable behavior.

**Carve-out:** if doc edits change a SKILL.md `description` (the trigger field), that's a behavior change — the skill will now activate on different prompts. Counts as PATCH at minimum, MINOR if the change is large.

## Marketplace version

The top-level `metadata.version` in `marketplace.json` is the **release identifier** consumers see.

### MAJOR
Bump when at least one of:
- A plugin is **removed** from the marketplace.
- A plugin is **renamed** (consumers' cache for the old name will go stale).
- A breaking change ripples across multiple plugins.

History: `0.x → 1.0.0` happened on 2026-05-26 when we switched from vendoring (`nemo-*`) to references (`forge-*`) — plugin renames forced the major bump.

### MINOR
Bump when at least one plugin had a MINOR or MAJOR bump, **or** when a new plugin (own or reference) is added to the catalog.

### PATCH
Bump when only patches landed across plugins, **or** when only metadata in `marketplace.json` changes (description, etc.) without affecting plugin behavior.

### Rule of thumb
> The marketplace version mirrors the **highest** plugin bump in the release.

So if release N has one minor (`nemo-x` 0.3 → 0.4) and three patches, marketplace bumps minor (`1.2.0 → 1.3.0`). If release N has only patches, marketplace bumps patch.

### When NOT to bump
Maintainer-only changes (anything under `.claude/`, `scripts/`, `docs/`) don't change consumer-visible behavior. Don't bump `metadata.version` for those — but DO leave a CHANGELOG entry as bitácora.

## Reference vs vendored — same rules

The same policy applies whether a plugin is vendored or referenced. The `version` field of a **reference** entry in `marketplace.json` is your pin against upstream — bumping it acts like a version bump for your consumers (invalidates their cache) and signals you've "blessed" the new upstream version.

## Release process

Releases happen via `/marketplace-release` (`.claude/commands/marketplace-release.md`). The command detects which plugins changed since the last git tag, proposes bumps, edits `plugin.json` + `marketplace.json`, updates the CHANGELOG, validates, commits, tags, pushes.

1. Commit work normally (feature commits with `/commit` from the standard git workflow).
2. Run `/marketplace-release` — proposes bumps, you confirm, it ships.
3. Verify CHANGELOG.md entry landed.
4. Verify tag pushed.

## CHANGELOG discipline

Every release MUST have a `CHANGELOG.md` entry under `## v{X.Y.Z} — {YYYY-MM-DD}`.

For each plugin that bumped, list:
- Old version → new version (level: major / minor / patch)
- One-line summary of the change
- Migration steps if the bump is major

The same entry should call out marketplace-level changes (added/removed plugins, renames, schema changes).

## Update-check cadence

For vendored plugins, upstream may ship security or behavior fixes. To keep this from drifting:

- **Manual:** run `/update-check` at least every 14 days (vendored plugins) and `/check-references` similarly (referenced plugins).
- The `last_checked` field in each `customizations.json` is the audit trail. If `last_checked` is more than 30 days old when a release ships, mention it in the release notes.
