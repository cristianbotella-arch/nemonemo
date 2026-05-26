---
allowed-tools: Bash(bash:*)
description: Pre-publish sanity check for marketplace.json + plugins (schema, paths, version drift).
---

## Guard — marketplace repos only

This command requires `.claude-plugin/marketplace.json` at the repo root. If it doesn't exist, stop:

> This command is for marketplace repos only.

## Your task

Run the health script and report the result verbatim.

```bash
bash scripts/marketplace-health.sh --verbose
```

If any check fails, surface the failures to the user with no editorial reframing — the script's output is precise enough. Suggest the most likely fix for each failure based on the message.

If all checks pass, confirm with one short line.
